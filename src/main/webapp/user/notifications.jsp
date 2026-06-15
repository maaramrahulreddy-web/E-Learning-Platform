<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.Notification,java.util.List" %>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    int unreadCount = request.getAttribute("unreadCount") != null
                      ? (int) request.getAttribute("unreadCount") : 0;
    if (notifications == null) notifications = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Notifications — ELearn</title>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/user/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">
                Notifications
                <% if (unreadCount > 0) { %>
                <span style="background:#EF4444;color:white;font-size:0.7rem;
                             padding:3px 10px;border-radius:20px;font-weight:700;">
                    <%= unreadCount %> new
                </span>
                <% } %>
            </div>
            <% if (unreadCount > 0) { %>
            <a href="<%= request.getContextPath() %>/notifications?action=markRead"
               class="btn-sm-custom btn-secondary-sm">
                <i class="bi bi-check-all"></i> Mark All Read
            </a>
            <% } %>
        </div>
        <div class="content-area">
            <div class="card-custom">
                <div class="card-body-custom" style="padding:0;">
                    <% if (notifications.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-bell-slash"></i>
                        <h5>No notifications yet</h5>
                        <p>You'll be notified about deadlines and updates here.</p>
                    </div>
                    <% } else {
                        for (Notification n : notifications) { %>
                    <div style="padding:18px 24px;border-bottom:1px solid #E2E8F0;
                                display:flex;align-items:flex-start;gap:14px;
                                background:<%= !n.isRead() ? "rgba(79,70,229,0.03)" : "white" %>;">
                        <div style="width:42px;height:42px;border-radius:50%;flex-shrink:0;
                                    background:<%= !n.isRead() ? "rgba(79,70,229,0.12)" : "#F1F5F9" %>;
                                    display:flex;align-items:center;justify-content:center;">
                            <i class="bi bi-bell"
                               style="color:<%= !n.isRead() ? "#4F46E5" : "#94A3B8" %>;"></i>
                        </div>
                        <div style="flex:1;">
                            <p style="margin:0;font-size:0.92rem;color:#1E293B;
                                      font-weight:<%= !n.isRead() ? "600" : "400" %>;">
                                <%= n.getMessage() %>
                            </p>
                            <p style="margin:5px 0 0;font-size:0.78rem;color:#94A3B8;">
                                <i class="bi bi-clock"></i>
                                <%= n.getCreatedAt() != null ? n.getCreatedAt().toString().substring(0,16) : "" %>
                            </p>
                        </div>
                        <% if (!n.isRead()) { %>
                        <div style="width:9px;height:9px;border-radius:50%;
                                    background:#4F46E5;margin-top:8px;flex-shrink:0;"></div>
                        <% } %>
                    </div>
                    <% } } %>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/main.js"></script>
</body>
</html>