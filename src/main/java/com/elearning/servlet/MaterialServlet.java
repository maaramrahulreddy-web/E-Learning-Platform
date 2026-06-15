package com.elearning.servlet;

import com.elearning.dao.MaterialDAO;
import com.elearning.model.CourseMaterial;
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

@WebServlet("/materials")
@MultipartConfig
public class MaterialServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String action = req.getParameter("action");
        MaterialDAO dao = new MaterialDAO();
        String role = (String) session.getAttribute("userRole");

        if ("delete".equals(action) && "admin".equals(role)) {
            dao.deleteMaterial(Integer.parseInt(req.getParameter("id")));
            res.sendRedirect(req.getContextPath() + "/materials");
            return;
        }

        if ("byCourse".equals(action)) {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            req.setAttribute("materials", dao.getMaterialsByCourse(courseId));
            req.setAttribute("courseId", courseId);
            req.getRequestDispatcher("/user/materials.jsp").forward(req, res);
            return;
        }

        req.setAttribute("materials", dao.getAllMaterials());
        if ("admin".equals(role)) {
            req.getRequestDispatcher("/admin/materials.jsp").forward(req, res);
        } else {
            req.getRequestDispatcher("/user/materials.jsp").forward(req, res);
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

        String fileUrl = "";
        String publicId = "";
        String error = null;

        try {
            int courseId = Integer.parseInt(req.getParameter("courseId"));
            String title = req.getParameter("title");
            String fileType = req.getParameter("fileType");
            Part filePart = req.getPart("materialFile");

            // Validation
            if (courseId == 0) {
                error = "Please select a course";
            } else if (title == null || title.trim().isEmpty()) {
                error = "Please enter a title";
            } else if (filePart == null || filePart.getSize() == 0) {
                error = "Please select a file to upload";
            } else {
                String fileName = filePart.getSubmittedFileName().toLowerCase();
                String resourceType;

                if (fileName.endsWith(".mp4") || fileName.endsWith(".mov")
                        || fileName.endsWith(".avi") || fileName.endsWith(".webm")) {
                    resourceType = "video";
                } else if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")
                        || fileName.endsWith(".png") || fileName.endsWith(".gif")) {
                    resourceType = "image";
                } else {
                    resourceType = "raw"; // PDF, DOC, DOCX, ZIP, PPT, etc.
                }

                try (InputStream is = filePart.getInputStream()) {
                    Cloudinary cloudinary = CloudinaryConfig.getInstance();
                    Map uploadResult = cloudinary.uploader().upload(
                        is.readAllBytes(),
                        ObjectUtils.asMap(
                            "folder", "elearning/materials",
                            "resource_type", resourceType
                        )
                    );
                    fileUrl  = (String) uploadResult.get("secure_url");
                    publicId = (String) uploadResult.get("public_id");

                    // Save to database
                    CourseMaterial material = new CourseMaterial();
                    material.setCourseId(courseId);
                    material.setTitle(title);
                    material.setFileUrl(fileUrl);
                    material.setFileType(fileType);
                    material.setCloudinaryPublicId(publicId);

                    MaterialDAO dao = new MaterialDAO();
                    if (dao.addMaterial(material)) {
                        // Redirect back to materials on success
                        res.sendRedirect(req.getContextPath() + "/materials");
                        return;
                    } else {
                        error = "Failed to save material to database";
                    }
                } catch (Exception e) {
                    error = "Upload failed: " + e.getMessage();
                    e.printStackTrace();
                }
            }
        } catch (NumberFormatException e) {
            error = "Invalid course ID";
        } catch (Exception e) {
            error = "An error occurred: " + e.getMessage();
            e.printStackTrace();
        }

        // If there was an error, redirect back with error message
        if (error != null) {
            req.setAttribute("materials", new MaterialDAO().getAllMaterials());
            req.setAttribute("error", error);
            req.getRequestDispatcher("/admin/materials.jsp").forward(req, res);
        }
    }
}