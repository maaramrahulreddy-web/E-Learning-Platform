<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null || !"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    String initial = userName.substring(0, 1).toUpperCase();
%>
<div class="sidebar">
    <a href="<%= request.getContextPath() %>/admin" class="sidebar-brand">
        <div class="brand-icon">🎓</div>
        <span>ELearn Admin</span>
    </a>
    <nav class="sidebar-nav">
        <div class="nav-section-title">Management</div>
        <a href="<%= request.getContextPath() %>/admin" class="nav-link">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/courses" class="nav-link">
            <i class="bi bi-book"></i> Courses
        </a>
        <a href="<%= request.getContextPath() %>/materials" class="nav-link">
            <i class="bi bi-folder2-open"></i> Materials
        </a>
        <a href="<%= request.getContextPath() %>/assignments" class="nav-link">
            <i class="bi bi-journal-check"></i> Assignments
        </a>
        <a href="<%= request.getContextPath() %>/admin/users.jsp" class="nav-link">
            <i class="bi bi-people"></i> Users
        </a>
        <a href="<%= request.getContextPath() %>/notifications" class="nav-link">
            <i class="bi bi-bell"></i> Notifications
        </a>
        <a href="<%= request.getContextPath() %>/admin/cloud-monitor.jsp" class="nav-link">
            <i class="bi bi-cloud"></i> Cloud Monitor
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
                <div class="user-role">Administrator</div>
            </div>
        </div>
    </div>
</div>