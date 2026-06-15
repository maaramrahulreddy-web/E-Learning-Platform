package com.elearning.servlet;

import com.elearning.dao.CourseDAO;
import com.elearning.model.Course;
import com.elearning.util.CloudinaryConfig;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@WebServlet("/courses")
@MultipartConfig
public class CourseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String action = req.getParameter("action");
        CourseDAO dao = new CourseDAO();

        if ("enroll".equals(action)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            int studentId = (int) session.getAttribute("userId");
            dao.enrollStudent(studentId, courseId);
            res.sendRedirect(req.getContextPath() + "/user/dashboard.jsp");
            return;
        }

        req.setAttribute("courses", dao.getAllCourses());
        String role = (String) session.getAttribute("userRole");
        if ("admin".equals(role)) {
            req.getRequestDispatcher("/admin/courses.jsp").forward(req, res);
        } else {
            req.getRequestDispatcher("/user/courses.jsp").forward(req, res);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String category = req.getParameter("category");
            int instructorId = (int) session.getAttribute("userId");
            String thumbnailUrl = "";

            Part filePart = req.getPart("thumbnail");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream is = filePart.getInputStream()) {
                    Cloudinary cloudinary = CloudinaryConfig.getInstance();
                    Map uploadResult = cloudinary.uploader().upload(is.readAllBytes(),
                            ObjectUtils.asMap("folder", "elearning/thumbnails"));
                    thumbnailUrl = (String) uploadResult.get("secure_url");
                } catch (Exception e) { e.printStackTrace(); }
            }

            Course course = new Course();
            course.setTitle(title);
            course.setDescription(description);
            course.setCategory(category);
            course.setInstructorId(instructorId);
            course.setThumbnailUrl(thumbnailUrl);
            new CourseDAO().addCourse(course);

        } else if ("delete".equals(action)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            new CourseDAO().deleteCourse(courseId);
        }
        res.sendRedirect(req.getContextPath() + "/courses");
    }
}