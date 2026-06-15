<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.Notification, com.elearning.model.User, com.elearning.dao.UserDAO, java.util.List" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    if (notifications == null) notifications = new java.util.ArrayList<>();
    List<User> allUsers = new UserDAO().getAllUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications — ELearn Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Notifications</div>
            <button class="btn-sm-custom btn-primary-sm" onclick="openModal('sendModal')">
                <i class="bi bi-send"></i> Send Notification
            </button>
        </div>
        <div class="content-area">

            <div class="modal-overlay" id="sendModal">
                <div class="modal-box">
                    <h4><i class="bi bi-send"></i> Send Notification</h4>
                    <form action="<%= request.getContextPath() %>/notifications" method="post">
                        <div class="form-group">
                            <label class="form-label-custom">Send To</label>
                            <select name="action" class="form-control-custom" id="sendTarget"
                                    onchange="toggleUserSelect(this.value)">
                                <option value="sendAll">All Students</option>
                                <option value="sendOne">Specific User</option>
                            </select>
                        </div>
                        <div class="form-group" id="userSelectGroup" style="display:none;">
                            <label class="form-label-custom">Select User</label>
                            <select name="targetUserId" class="form-control-custom">
                                <% for (User u : allUsers) { %>
                                <option value="<%= u.getId() %>">
                                    <%= u.getName() %> (<%= u.getRole() %>)
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Message</label>
                            <textarea name="message" class="form-control-custom" rows="4"
                                      placeholder="Enter notification message..." required></textarea>
                        </div>
                        <div style="display:flex; gap:12px;">
                            <button type="submit" class="btn-sm-custom btn-success-sm">
                                <i class="bi bi-send"></i> Send
                            </button>
                            <button type="button" class="btn-sm-custom btn-secondary-sm"
                                    onclick="closeModal('sendModal')">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-bell"></i> Notification Log</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (notifications.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-bell-slash"></i>
                        <h5>No notifications sent yet</h5>
                    </div>
                    <% } else { %>
                    <table class="table-custom">
                        <thead>
                            <tr><th>Message</th><th>Status</th><th>Sent At</th></tr>
                        </thead>
                        <tbody>
                            <% for (Notification n : notifications) { %>
                            <tr>
                                <td><%= n.getMessage() %></td>
                                <td>
                                    <span class="badge-custom <%= n.isRead() ? "badge-graded" : "badge-pending" %>">
                                        <%= n.isRead() ? "Read" : "Unread" %>
                                    </span>
                                </td>
                                <td style="font-size:0.8rem; color:#94A3B8;">
                                    <%= n.getCreatedAt() != null ? n.getCreatedAt().toString().substring(0,16) : "—" %>
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
<script>
function toggleUserSelect(val) {
    document.getElementById('userSelectGroup').style.display = val === 'sendOne' ? 'block' : 'none';
}
</script>
</body>
</html>