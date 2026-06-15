<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.dao.NotificationDAO" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    String initial = userName.substring(0, 1).toUpperCase();
    int userId = (int) session.getAttribute("userId");
    int unread = new NotificationDAO().getUnreadCount(userId);
%>
<div class="sidebar">
    <a href="<%= request.getContextPath() %>/user/dashboard.jsp" class="sidebar-brand">
        <div class="brand-icon">🎓</div>
        <span>ELearn</span>
    </a>
    <nav class="sidebar-nav">
        <div class="nav-section-title">Main Menu</div>
        <a href="<%= request.getContextPath() %>/user/dashboard.jsp" class="nav-link">
            <i class="bi bi-grid"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/courses" class="nav-link">
            <i class="bi bi-book"></i> Browse Courses
        </a>
        <a href="<%= request.getContextPath() %>/materials" class="nav-link">
            <i class="bi bi-folder2-open"></i> Materials
        </a>
        <a href="<%= request.getContextPath() %>/assignments" class="nav-link">
            <i class="bi bi-journal-check"></i> Assignments
        </a>
        <a href="<%= request.getContextPath() %>/progress" class="nav-link">
            <i class="bi bi-bar-chart-line"></i> My Progress
        </a>
        <a href="<%= request.getContextPath() %>/notifications" class="nav-link"
           style="display:flex;align-items:center;justify-content:space-between;">
            <span><i class="bi bi-bell"></i> Notifications</span>
            <% if (unread > 0) { %>
            <span style="background:#EF4444;color:white;font-size:0.65rem;
                         padding:2px 7px;border-radius:20px;font-weight:700;">
                <%= unread %>
            </span>
            <% } %>
        </a>
        <div class="nav-section-title">Account</div>
        <a href="<%= request.getContextPath() %>/logout" class="nav-link"
           style="color:rgba(239,68,68,0.85);">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar"><%= initial %></div>
            <div>
                <div class="user-name"><%= userName %></div>
                <div class="user-role">Student</div>
            </div>
        </div>
    </div>
</div>