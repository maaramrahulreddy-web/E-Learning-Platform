<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.User, java.util.List" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    int totalUsers       = request.getAttribute("totalUsers")       != null ? (int) request.getAttribute("totalUsers")       : 0;
    int totalCourses     = request.getAttribute("totalCourses")     != null ? (int) request.getAttribute("totalCourses")     : 0;
    int totalSubmissions = request.getAttribute("totalSubmissions") != null ? (int) request.getAttribute("totalSubmissions") : 0;
    List<User> allUsers  = (List<User>) request.getAttribute("allUsers");
    if (allUsers == null) allUsers = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — ELearn</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/admin/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Admin Dashboard</div>
        </div>
        <div class="content-area">

            <div class="stats-grid">
                <div class="stat-card blue">
                    <div class="stat-icon blue"><i class="bi bi-people"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= totalUsers %></div>
                        <div class="stat-label">Total Students</div>
                    </div>
                </div>
                <div class="stat-card teal">
                    <div class="stat-icon teal"><i class="bi bi-collection"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= totalCourses %></div>
                        <div class="stat-label">Total Courses</div>
                    </div>
                </div>
                <div class="stat-card orange">
                    <div class="stat-icon orange"><i class="bi bi-file-earmark-check"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= totalSubmissions %></div>
                        <div class="stat-label">Submissions</div>
                    </div>
                </div>
                <div class="stat-card green">
                    <div class="stat-icon green"><i class="bi bi-cloud-check"></i></div>
                    <div class="stat-info">
                        <div class="stat-value">Active</div>
                        <div class="stat-label">Cloud Status</div>
                    </div>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-people"></i> Recent Users</h5>
                    <a href="<%= request.getContextPath() %>/admin/users.jsp"
                       class="btn-sm-custom btn-secondary-sm">View All</a>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int count = 0;
                               for (User u : allUsers) {
                                   if (count++ >= 8) break; %>
                            <tr>
                                <td><%= u.getId() %></td>
                                <td>
                                    <div style="display:flex; align-items:center; gap:10px;">
                                        <div style="width:32px; height:32px; border-radius:50%;
                                                    background:linear-gradient(135deg,#4F46E5,#06B6D4);
                                                    display:flex; align-items:center; justify-content:center;
                                                    color:white; font-weight:700; font-size:0.8rem;">
                                            <%= u.getName().substring(0,1).toUpperCase() %>
                                        </div>
                                        <%= u.getName() %>
                                    </div>
                                </td>
                                <td style="color:#64748B;"><%= u.getEmail() %></td>
                                <td>
                                    <span class="badge-custom badge-<%= u.getRole() %>">
                                        <%= u.getRole() %>
                                    </span>
                                </td>
                                <td style="font-size:0.8rem; color:#94A3B8;">
                                    <%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0,10) : "—" %>
                                </td>
                                <td>
                                    <form action="<%= request.getContextPath() %>/admin" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="updateRole">
                                        <input type="hidden" name="userId" value="<%= u.getId() %>">
                                        <select name="role" class="form-control-custom"
                                                style="width:120px; display:inline; padding:4px 8px; font-size:0.8rem;"
                                                onchange="this.form.submit()">
                                            <option value="student"    <%= "student".equals(u.getRole())    ? "selected" : "" %>>Student</option>
                                            <option value="instructor" <%= "instructor".equals(u.getRole()) ? "selected" : "" %>>Instructor</option>
                                            <option value="admin"      <%= "admin".equals(u.getRole())      ? "selected" : "" %>>Admin</option>
                                        </select>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/admin" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="deleteUser">
                                        <input type="hidden" name="userId" value="<%= u.getId() %>">
                                        <button type="submit" class="btn-sm-custom btn-danger-sm"
                                                onclick="return confirm('Delete this user permanently?')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/main.js"></script>
</body>
</html>