<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.dao.CourseDAO,com.elearning.dao.AssignmentDAO,java.util.List,com.elearning.model.Course" %>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    int userId = (int) session.getAttribute("userId");
    CourseDAO courseDAO = new CourseDAO();
    AssignmentDAO assignDAO = new AssignmentDAO();
    List<Course> enrolled = courseDAO.getEnrolledCourses(userId);
    int pendingAssignments = assignDAO.getAssignmentsForStudent(userId).size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Dashboard — ELearn</title>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/user/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">My Dashboard</div>
        </div>
        <div class="content-area">

            <div style="margin-bottom:28px;">
                <h3 style="font-size:1.5rem; font-weight:700;">
                    Hello, <%= session.getAttribute("userName") %>! 👋
                </h3>
                <p style="color:#64748B;">Keep up the great work on your learning journey.</p>
            </div>

            <div class="stats-grid">
                <div class="stat-card blue">
                    <div class="stat-icon blue"><i class="bi bi-book-half"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= enrolled.size() %></div>
                        <div class="stat-label">Enrolled Courses</div>
                    </div>
                </div>
                <div class="stat-card orange">
                    <div class="stat-icon orange"><i class="bi bi-journal-text"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= pendingAssignments %></div>
                        <div class="stat-label">Assignments</div>
                    </div>
                </div>
                <div class="stat-card teal">
                    <div class="stat-icon teal"><i class="bi bi-cloud-check"></i></div>
                    <div class="stat-info">
                        <div class="stat-value">Live</div>
                        <div class="stat-label">Cloud Access</div>
                    </div>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-collection"></i> My Enrolled Courses</h5>
                    <a href="<%= request.getContextPath() %>/courses"
                       class="btn-sm-custom btn-primary-sm">+ Browse More</a>
                </div>
                <div class="card-body-custom">
                    <% if (enrolled.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h5>No courses enrolled yet</h5>
                        <p>Browse and enroll in courses to get started.</p>
                        <a href="<%= request.getContextPath() %>/courses"
                           class="btn-sm-custom btn-primary-sm" style="margin-top:12px;">Browse Courses</a>
                    </div>
                    <% } else { %>
                    <div class="courses-grid">
                        <% for (Course c : enrolled) { %>
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
                                <a href="<%= request.getContextPath() %>/materials?action=byCourse&courseId=<%= c.getId() %>"
                                   class="btn-sm-custom btn-secondary-sm" style="margin-top:12px;">
                                    <i class="bi bi-folder2-open"></i> View Materials
                                </a>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>

        </div>
    </div>
</div>
<script src="<%= request.getContextPath() %>/assets/js/main.js"></script>
</body>
</html>