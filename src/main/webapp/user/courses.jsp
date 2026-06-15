<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.Course,java.util.List" %>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (courses == null) courses = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Courses — ELearn</title>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/user/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Browse Courses</div>
        </div>
        <div class="content-area">
            <% if (courses.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-journals"></i>
                <h5>No courses available yet</h5>
                <p>Check back later for new courses.</p>
            </div>
            <% } else { %>
            <div class="courses-grid">
                <% for (Course c : courses) { %>
                <div class="course-card">
                    <% if (c.getThumbnailUrl() != null && !c.getThumbnailUrl().isEmpty()) { %>
                    <img src="<%= c.getThumbnailUrl() %>" class="course-thumb" alt="<%= c.getTitle() %>">
                    <% } else { %>
                    <div class="course-thumb-placeholder">📚</div>
                    <% } %>
                    <div class="course-body">
                        <div class="course-category">
                            <%= c.getCategory() != null ? c.getCategory() : "General" %>
                        </div>
                        <div class="course-title"><%= c.getTitle() %></div>
                        <div class="course-instructor">
                            <i class="bi bi-person"></i>
                            <%= c.getInstructorName() != null ? c.getInstructorName() : "Admin" %>
                        </div>
                        <p style="font-size:0.82rem;color:#94A3B8;margin-bottom:16px;line-height:1.5;">
                            <%= c.getDescription() != null && c.getDescription().length() > 90
                                ? c.getDescription().substring(0,90)+"..." : c.getDescription() %>
                        </p>
                        <a href="<%= request.getContextPath() %>/courses?action=enroll&courseId=<%= c.getId() %>"
                           class="btn-sm-custom btn-primary-sm"
                           onclick="return confirm('Enroll in this course?')">
                            <i class="bi bi-plus-circle"></i> Enroll Now
                        </a>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/main.js"></script>
</body>
</html>