<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.CourseMaterial, com.elearning.model.Course, com.elearning.dao.CourseDAO, java.util.List" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<CourseMaterial> materials = (List<CourseMaterial>) request.getAttribute("materials");
    if (materials == null) materials = new java.util.ArrayList<>();
    List<Course> courses = new CourseDAO().getAllCourses();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Materials — ELearn Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Course Materials</div>
            <button class="btn-sm-custom btn-primary-sm" onclick="openModal('addMaterialModal')">
                <i class="bi bi-cloud-upload"></i> Upload Material
            </button>
        </div>
        <div class="content-area">

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert-custom alert-error" style="margin-bottom:20px;">
                <i class="bi bi-exclamation-circle"></i> <%= request.getAttribute("error") %>
            </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
            <div class="alert-custom alert-success" style="margin-bottom:20px;">
                <i class="bi bi-check-circle"></i> <%= request.getAttribute("success") %>
            </div>
            <% } %>

            <div class="modal-overlay" id="addMaterialModal">
                <div class="modal-box">
                    <h4><i class="bi bi-cloud-upload"></i> Upload Learning Material</h4>
                    <form action="<%= request.getContextPath() %>/materials" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label-custom">Select Course</label>
                            <select name="courseId" class="form-control-custom" required>
                                <option value="">-- Select Course --</option>
                                <% for (Course c : courses) { %>
                                <option value="<%= c.getId() %>"><%= c.getTitle() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Material Title</label>
                            <input type="text" name="title" class="form-control-custom" required
                                   placeholder="e.g. Week 1 - Lecture Notes">
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">File Type</label>
                            <select name="fileType" class="form-control-custom">
                                <option value="pdf">PDF</option>
                                <option value="video">Video</option>
                                <option value="document">Document</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">File</label>
                            <input type="file" name="materialFile" class="form-control-custom" required>
                            <small style="color:#94A3B8; font-size:0.78rem;">
                                <i class="bi bi-cloud"></i> Stored securely on Cloudinary CDN
                            </small>
                        </div>
                        <div style="display:flex; gap:12px;">
                            <button type="submit" class="btn-sm-custom btn-success-sm">
                                <i class="bi bi-cloud-upload"></i> Upload
                            </button>
                            <button type="button" class="btn-sm-custom btn-secondary-sm"
                                    onclick="closeModal('addMaterialModal')">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-folder2-open"></i> All Materials (<%= materials.size() %>)</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (materials.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-folder-x"></i>
                        <h5>No materials uploaded yet</h5>
                        <p>Upload your first learning resource above.</p>
                    </div>
                    <% } else { %>
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>Title</th>
                                <th>Course</th>
                                <th>Uploaded</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CourseMaterial m : materials) {
                                String icon = "pdf".equals(m.getFileType()) ? "bi-file-earmark-pdf" :
                                              "video".equals(m.getFileType()) ? "bi-play-circle" : "bi-file-earmark-text";
                                String iconColor = "pdf".equals(m.getFileType()) ? "#EF4444" :
                                                   "video".equals(m.getFileType()) ? "#8B5CF6" : "#06B6D4";
                            %>
                            <tr>
                                <td><i class="bi <%= icon %>" style="font-size:1.5rem; color:<%= iconColor %>;"></i></td>
                                <td><strong><%= m.getTitle() %></strong></td>
                                <td>
                                    <span class="badge-custom badge-student">
                                        <%= m.getCourseTitle() %>
                                    </span>
                                </td>
                                <td style="font-size:0.8rem; color:#94A3B8;">
                                    <%= m.getUploadedAt() != null ? m.getUploadedAt().toString().substring(0,10) : "—" %>
                                </td>
                                <td>
                                    <% if (m.getFileUrl() != null && !m.getFileUrl().isEmpty()) { %>
                                    <a href="<%= m.getFileUrl() %>" target="_blank"
                                       class="btn-sm-custom btn-secondary-sm">
                                        <i class="bi bi-eye"></i> View
                                    </a>
                                    <% } %>
                                    <a href="<%= request.getContextPath() %>/materials?action=delete&id=<%= m.getId() %>"
                                       class="btn-sm-custom btn-danger-sm"
                                       onclick="return confirm('Delete this material?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/main.js"></script>
</body>
</html>