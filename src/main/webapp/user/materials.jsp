<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.CourseMaterial,java.util.List" %>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<CourseMaterial> materials = (List<CourseMaterial>) request.getAttribute("materials");
    if (materials == null) materials = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Materials — ELearn</title>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/user/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Course Materials</div>
        </div>
        <div class="content-area">
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-folder2-open"></i> Learning Resources</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (materials.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-folder-x"></i>
                        <h5>No materials uploaded yet</h5>
                        <p>Your instructor hasn't added materials yet.</p>
                    </div>
                    <% } else { %>
                    <table class="table-custom">
                        <thead>
                            <tr><th>Type</th><th>Title</th><th>Course</th><th>Uploaded</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <% for (CourseMaterial m : materials) {
                                String icon = "pdf".equals(m.getFileType()) ? "bi-file-earmark-pdf" :
                                              "video".equals(m.getFileType()) ? "bi-play-circle" : "bi-file-earmark-text";
                                String iconColor = "pdf".equals(m.getFileType()) ? "#EF4444" :
                                                   "video".equals(m.getFileType()) ? "#8B5CF6" : "#06B6D4";
                            %>
                            <tr>
                                <td><i class="bi <%= icon %>" style="font-size:1.5rem;color:<%= iconColor %>;"></i></td>
                                <td><strong><%= m.getTitle() %></strong></td>
                                <td>
                                    <span class="badge-custom badge-student">
                                        <%= m.getCourseTitle() != null ? m.getCourseTitle() : "—" %>
                                    </span>
                                </td>
                                <td style="font-size:0.8rem;color:#94A3B8;">
                                    <%= m.getUploadedAt() != null ? m.getUploadedAt().toString().substring(0,10) : "—" %>
                                </td>
                                <td>
                                    <% if (m.getFileUrl() != null && !m.getFileUrl().isEmpty()) { %>
                                    <a href="<%= m.getFileUrl() %>" target="_blank"
                                       class="btn-sm-custom btn-primary-sm">
                                        <i class="bi bi-download"></i> Download
                                    </a>
                                    <% } %>
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