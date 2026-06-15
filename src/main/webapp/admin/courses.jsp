<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.Course, java.util.List" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (courses == null) courses = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courses — ELearn Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Course Management</div>
            <button class="btn-sm-custom btn-primary-sm" onclick="openModal('addCourseModal')">
                <i class="bi bi-plus-circle"></i> Add Course
            </button>
        </div>
        <div class="content-area">

            <div class="modal-overlay" id="addCourseModal">
                <div class="modal-box">
                    <h4><i class="bi bi-book-half"></i> Add New Course</h4>
                    <form action="<%= request.getContextPath() %>/courses" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label class="form-label-custom">Course Title</label>
                            <input type="text" name="title" class="form-control-custom" required
                                   placeholder="e.g. Introduction to Java">
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Description</label>
                            <textarea name="description" class="form-control-custom" rows="3"
                                      placeholder="Describe this course..."></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Category</label>
                            <input type="text" name="category" class="form-control-custom"
                                   placeholder="e.g. Programming, Design, Data Science">
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Thumbnail Image</label>
                            <input type="file" name="thumbnail" class="form-control-custom" accept="image/*">
                            <small style="color:#94A3B8; font-size:0.78rem;">
                                <i class="bi bi-cloud-upload"></i> Uploaded to Cloudinary automatically
                            </small>
                        </div>
                        <div style="display:flex; gap:12px;">
                            <button type="submit" class="btn-sm-custom btn-success-sm">
                                <i class="bi bi-check-lg"></i> Save Course
                            </button>
                            <button type="button" class="btn-sm-custom btn-secondary-sm"
                                    onclick="closeModal('addCourseModal')">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-collection"></i> All Courses (<%= courses.size() %>)</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (courses.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-journals"></i>
                        <h5>No courses yet</h5>
                        <p>Add your first course using the button above.</p>
                    </div>
                    <% } else { %>
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Thumbnail</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Instructor</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Course c : courses) { %>
                            <tr>
                                <td>
                                    <% if (c.getThumbnailUrl() != null && !c.getThumbnailUrl().isEmpty()) { %>
                                    <img src="<%= c.getThumbnailUrl() %>"
                                         style="width:64px; height:42px; object-fit:cover; border-radius:6px;">
                                    <% } else { %>
                                    <div style="width:64px; height:42px; border-radius:6px;
                                                background:linear-gradient(135deg,#4F46E5,#06B6D4);
                                                display:flex; align-items:center; justify-content:center; font-size:20px;">
                                        📚
                                    </div>
                                    <% } %>
                                </td>
                                <td><strong><%= c.getTitle() %></strong></td>
                                <td>
                                    <span class="badge-custom badge-student">
                                        <%= c.getCategory() != null ? c.getCategory() : "General" %>
                                    </span>
                                </td>
                                <td style="color:#64748B;">
                                    <%= c.getInstructorName() != null ? c.getInstructorName() : "Admin" %>
                                </td>
                                <td style="font-size:0.8rem; color:#94A3B8;">
                                    <%= c.getCreatedAt() != null ? c.getCreatedAt().toString().substring(0,10) : "—" %>
                                </td>
                                <td>
                                    <form action="<%= request.getContextPath() %>/courses" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="courseId" value="<%= c.getId() %>">
                                        <button type="submit" class="btn-sm-custom btn-danger-sm"
                                                onclick="return confirm('Delete this course and all its data?')">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </form>
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