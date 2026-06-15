<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.model.Submission, com.elearning.model.Course, com.elearning.dao.CourseDAO, java.util.List" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Submission> submissions = (List<Submission>) request.getAttribute("submissions");
    if (submissions == null) submissions = new java.util.ArrayList<>();
    List<Course> courses = new CourseDAO().getAllCourses();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignments — ELearn Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="/admin/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Assignment Management</div>
            <button class="btn-sm-custom btn-primary-sm" onclick="openModal('addAssignmentModal')">
                <i class="bi bi-plus-circle"></i> Add Assignment
            </button>
        </div>
        <div class="content-area">

            <div class="modal-overlay" id="addAssignmentModal">
                <div class="modal-box">
                    <h4><i class="bi bi-journal-plus"></i> Add New Assignment</h4>
                    <form action="<%= request.getContextPath() %>/assignments" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label class="form-label-custom">Course</label>
                            <select name="courseId" class="form-control-custom" required>
                                <option value="">-- Select Course --</option>
                                <% for (Course c : courses) { %>
                                <option value="<%= c.getId() %>"><%= c.getTitle() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Assignment Title</label>
                            <input type="text" name="title" class="form-control-custom" required
                                   placeholder="e.g. Module 1 Quiz">
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Description / Instructions</label>
                            <textarea name="description" class="form-control-custom" rows="3"
                                      placeholder="Instructions for students..."></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Due Date</label>
                            <input type="date" name="dueDate" class="form-control-custom" required>
                        </div>
                        <div style="display:flex; gap:12px;">
                            <button type="submit" class="btn-sm-custom btn-success-sm">
                                <i class="bi bi-check-lg"></i> Save
                            </button>
                            <button type="button" class="btn-sm-custom btn-secondary-sm"
                                    onclick="closeModal('addAssignmentModal')">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-overlay" id="gradeModal">
                <div class="modal-box">
                    <h4><i class="bi bi-star"></i> Grade Submission</h4>
                    <form action="<%= request.getContextPath() %>/assignments" method="post">
                        <input type="hidden" name="action" value="grade">
                        <input type="hidden" name="submissionId" id="gradeSubmissionId">
                        <div class="form-group">
                            <label class="form-label-custom">Grade (A, B, C or e.g. 85/100)</label>
                            <input type="text" name="grade" class="form-control-custom" required
                                   placeholder="e.g. A or 90/100">
                        </div>
                        <div class="form-group">
                            <label class="form-label-custom">Feedback</label>
                            <textarea name="feedback" class="form-control-custom" rows="4"
                                      placeholder="Write detailed feedback for the student..."></textarea>
                        </div>
                        <div style="display:flex; gap:12px;">
                            <button type="submit" class="btn-sm-custom btn-success-sm">Submit Grade</button>
                            <button type="button" class="btn-sm-custom btn-secondary-sm"
                                    onclick="closeModal('gradeModal')">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-journal-check"></i> All Submissions (<%= submissions.size() %>)</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <% if (submissions.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-inbox"></i>
                        <h5>No submissions yet</h5>
                        <p>Students haven't submitted assignments yet.</p>
                    </div>
                    <% } else { %>
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Assignment</th>
                                <th>File</th>
                                <th>Grade</th>
                                <th>Submitted</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Submission s : submissions) { %>
                            <tr>
                                <td>
                                    <div style="display:flex; align-items:center; gap:8px;">
                                        <div style="width:30px; height:30px; border-radius:50%;
                                                    background:linear-gradient(135deg,#4F46E5,#06B6D4);
                                                    display:flex; align-items:center; justify-content:center;
                                                    color:white; font-size:0.75rem; font-weight:700;">
                                            <%= s.getStudentName() != null ? s.getStudentName().substring(0,1).toUpperCase() : "?" %>
                                        </div>
                                        <%= s.getStudentName() %>
                                    </div>
                                </td>
                                <td><strong><%= s.getAssignmentTitle() %></strong></td>
                                <td>
                                    <% if (s.getFileUrl() != null && !s.getFileUrl().isEmpty()) { %>
                                    <a href="<%= s.getFileUrl() %>" target="_blank"
                                       class="btn-sm-custom btn-secondary-sm">
                                        <i class="bi bi-file-earmark-arrow-down"></i> View
                                    </a>
                                    <% } else { %>
                                    <span style="color:#94A3B8; font-size:0.82rem;">No file</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (s.getGrade() != null && !s.getGrade().isEmpty()) { %>
                                    <span class="badge-custom badge-graded">
                                        <i class="bi bi-patch-check"></i> <%= s.getGrade() %>
                                    </span>
                                    <% } else { %>
                                    <span class="badge-custom badge-pending">Ungraded</span>
                                    <% } %>
                                </td>
                                <td style="font-size:0.8rem; color:#94A3B8;">
                                    <%= s.getSubmittedAt() != null ? s.getSubmittedAt().toString().substring(0,10) : "—" %>
                                </td>
                                <td>
                                    <button class="btn-sm-custom btn-primary-sm"
                                        onclick="document.getElementById('gradeSubmissionId').value='<%= s.getId() %>'; openModal('gradeModal')">
                                        <i class="bi bi-pencil-square"></i> Grade
                                    </button>
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