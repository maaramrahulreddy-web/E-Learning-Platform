<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.Assignment,com.elearning.model.Submission,java.util.List" %>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Assignment> assignments = (List<Assignment>) request.getAttribute("assignments");
    List<Submission> submissions = (List<Submission>) request.getAttribute("submissions");
    if (assignments == null) assignments = new java.util.ArrayList<>();
    if (submissions == null) submissions = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Assignments — ELearn</title>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/user/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">My Assignments</div>
        </div>
        <div class="content-area">

            <div class="modal-overlay" id="submitModal">
                <div class="modal-box">
                    <h4><i class="bi bi-upload"></i> Submit Assignment</h4>
                    <form action="<%= request.getContextPath() %>/assignments" method="post"
                          enctype="multipart/form-data">
                        <input type="hidden" name="action" value="submit">
                        <input type="hidden" name="assignmentId" id="modalAssignmentId">
                        <div class="form-group">
                            <label class="form-label-custom">Upload File (PDF, DOC, ZIP)</label>
                            <input type="file" name="submissionFile" class="form-control-custom" required>
                        </div>
                        <div style="display:flex;gap:12px;">
                            <button type="submit" class="btn-sm-custom btn-success-sm">
                                <i class="bi bi-cloud-upload"></i> Submit
                            </button>
                            <button type="button" class="btn-sm-custom btn-secondary-sm"
                                    onclick="closeModal('submitModal')">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-journal-check"></i> Pending Assignments</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (assignments.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h5>No assignments found</h5>
                        <p>Enroll in courses to get assignments.</p>
                    </div>
                    <% } else { %>
                    <table class="table-custom">
                        <thead>
                            <tr><th>Assignment</th><th>Course</th><th>Due Date</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                            <% for (Assignment a : assignments) { %>
                            <tr>
                                <td>
                                    <strong><%= a.getTitle() %></strong><br>
                                    <small style="color:#94A3B8;">
                                        <%= a.getDescription() != null ? a.getDescription() : "" %>
                                    </small>
                                </td>
                                <td><%= a.getCourseTitle() %></td>
                                <td>
                                    <span style="background:rgba(245,158,11,0.1);color:#B45309;
                                                 padding:4px 10px;border-radius:20px;font-size:0.8rem;font-weight:600;">
                                        <i class="bi bi-calendar3"></i> <%= a.getDueDate() %>
                                    </span>
                                </td>
                                <td>
                                    <button class="btn-sm-custom btn-primary-sm"
                                        onclick="document.getElementById('modalAssignmentId').value='<%= a.getId() %>'; openModal('submitModal')">
                                        <i class="bi bi-upload"></i> Submit
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } %>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-star"></i> My Submissions & Grades</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (submissions.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-file-earmark-x"></i>
                        <h5>No submissions yet</h5>
                        <p>Submit your first assignment above.</p>
                    </div>
                    <% } else { %>
                    <table class="table-custom">
                        <thead>
                            <tr><th>Assignment</th><th>File</th><th>Grade</th><th>Feedback</th><th>Submitted</th></tr>
                        </thead>
                        <tbody>
                            <% for (Submission s : submissions) { %>
                            <tr>
                                <td><strong><%= s.getAssignmentTitle() %></strong></td>
                                <td>
                                    <% if (s.getFileUrl() != null && !s.getFileUrl().isEmpty()) { %>
                                    <a href="<%= s.getFileUrl() %>" target="_blank"
                                       class="btn-sm-custom btn-secondary-sm">
                                        <i class="bi bi-file-earmark-arrow-down"></i> View
                                    </a>
                                    <% } else { %><span style="color:#94A3B8;">—</span><% } %>
                                </td>
                                <td>
                                    <% if (s.getGrade() != null && !s.getGrade().isEmpty()) { %>
                                    <span class="badge-custom badge-graded">
                                        <i class="bi bi-patch-check"></i> <%= s.getGrade() %>
                                    </span>
                                    <% } else { %>
                                    <span class="badge-custom badge-pending">Pending</span>
                                    <% } %>
                                </td>
                                <td style="font-size:0.85rem;color:#64748B;max-width:200px;">
                                    <%= s.getFeedback() != null && !s.getFeedback().isEmpty() ? s.getFeedback() : "—" %>
                                </td>
                                <td style="font-size:0.8rem;color:#94A3B8;">
                                    <%= s.getSubmittedAt() != null ? s.getSubmittedAt().toString().substring(0,10) : "—" %>
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