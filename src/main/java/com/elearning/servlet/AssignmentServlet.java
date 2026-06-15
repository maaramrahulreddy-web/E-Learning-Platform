package com.elearning.servlet;

import com.elearning.dao.AssignmentDAO;
import com.elearning.model.Assignment;
import com.elearning.util.CloudinaryConfig;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Date;
import java.util.Map;

@WebServlet("/assignments")
@MultipartConfig
public class AssignmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String role = (String) session.getAttribute("userRole");
        AssignmentDAO dao = new AssignmentDAO();

        if ("admin".equals(role)) {
            req.setAttribute("submissions", dao.getAllSubmissions());
            req.getRequestDispatcher("/admin/assignments.jsp").forward(req, res);
        } else {
            int studentId = (int) session.getAttribute("userId");
            req.setAttribute("assignments", dao.getAssignmentsForStudent(studentId));
            req.setAttribute("submissions", dao.getSubmissionsForStudent(studentId));
            req.getRequestDispatcher("/user/assignments.jsp").forward(req, res);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String action = req.getParameter("action");
        AssignmentDAO dao = new AssignmentDAO();

        if ("submit".equals(action)) {
            int assignmentId = Integer.parseInt(req.getParameter("assignmentId"));
            int studentId = (int) session.getAttribute("userId");
            String fileUrl = "";
            String publicId = "";

            Part filePart = req.getPart("submissionFile");
            if (filePart != null && filePart.getSize() > 0) {
                try (InputStream is = filePart.getInputStream()) {
                    Cloudinary cloudinary = CloudinaryConfig.getInstance();
                    Map uploadResult = cloudinary.uploader().upload(is.readAllBytes(),
                            ObjectUtils.asMap("folder", "elearning/submissions", "resource_type", "raw"));
                    fileUrl = (String) uploadResult.get("secure_url");
                    publicId = (String) uploadResult.get("public_id");
                } catch (Exception e) { e.printStackTrace(); }
            }
            dao.submitAssignment(assignmentId, studentId, fileUrl, publicId);

        } else if ("grade".equals(action)) {
            int submissionId = Integer.parseInt(req.getParameter("submissionId"));
            dao.gradeSubmission(submissionId, req.getParameter("grade"), req.getParameter("feedback"));

        } else if ("add".equals(action)) {
            Assignment a = new Assignment();
            a.setCourseId(Integer.parseInt(req.getParameter("courseId")));
            a.setTitle(req.getParameter("title"));
            a.setDescription(req.getParameter("description"));
            a.setDueDate(Date.valueOf(req.getParameter("dueDate")));
            dao.addAssignment(a);
        }
        res.sendRedirect(req.getContextPath() + "/assignments");
    }
}