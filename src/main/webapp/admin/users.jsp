<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.User, com.elearning.dao.UserDAO, java.util.List" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<User> users = new UserDAO().getAllUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users — ELearn Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">User Management</div>
        </div>
        <div class="content-area">
            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-people"></i> All Users (<%= users.size() %>)</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (users.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-person-x"></i>
                        <h5>No users found</h5>
                    </div>
                    <% } else { %>
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
                            <% for (User u : users) { %>
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
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/main.js"></script>
</body>
</html>