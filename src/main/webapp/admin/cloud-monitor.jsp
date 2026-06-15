<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.elearning.dao.MaterialDAO, com.elearning.dao.CourseDAO, com.elearning.dao.UserDAO" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    int totalMaterials = new MaterialDAO().getTotalMaterials();
    int totalCourses   = new CourseDAO().getTotalCourses();
    int totalUsers     = new UserDAO().getTotalUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cloud Monitor — ELearn Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>
<div class="app-layout">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Cloud Resource Monitor</div>
            <span style="background:rgba(16,185,129,0.1); color:#10B981; padding:6px 16px;
                         border-radius:20px; font-size:0.82rem; font-weight:600;">
                <i class="bi bi-circle-fill"
                   style="font-size:0.5rem; animation:pulse 1.5s infinite; margin-right:4px;"></i>
                Cloudinary Connected
            </span>
        </div>
        <div class="content-area">

            <div class="stats-grid">
                <div class="stat-card blue">
                    <div class="stat-icon blue"><i class="bi bi-cloud-arrow-up"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= totalMaterials %></div>
                        <div class="stat-label">Files on Cloud</div>
                    </div>
                </div>
                <div class="stat-card teal">
                    <div class="stat-icon teal"><i class="bi bi-collection"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= totalCourses %></div>
                        <div class="stat-label">Active Courses</div>
                    </div>
                </div>
                <div class="stat-card green">
                    <div class="stat-icon green"><i class="bi bi-people"></i></div>
                    <div class="stat-info">
                        <div class="stat-value"><%= totalUsers %></div>
                        <div class="stat-label">Registered Students</div>
                    </div>
                </div>
                <div class="stat-card orange">
                    <div class="stat-icon orange"><i class="bi bi-shield-lock"></i></div>
                    <div class="stat-info">
                        <div class="stat-value">HTTPS</div>
                        <div class="stat-label">Secure Transfers</div>
                    </div>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-folder2"></i> Cloudinary Storage Buckets</h5>
                </div>
                <div class="card-body-custom">
                    <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:20px;">
                        <% String[][] buckets = {
                            {"📁", "Thumbnails",  "elearning/thumbnails/",  "#4F46E5"},
                            {"📄", "Materials",   "elearning/materials/",   "#06B6D4"},
                            {"📤", "Submissions", "elearning/submissions/", "#10B981"},
                            {"🔒", "Security",    "All URLs HTTPS secured", "#F59E0B"}
                        };
                        for (String[] b : buckets) { %>
                        <div style="background:#F8FAFC; border-radius:12px; padding:20px;
                                    border:1px solid #E2E8F0; transition:transform 0.2s;"
                             onmouseover="this.style.transform='translateY(-3px)'"
                             onmouseout="this.style.transform='translateY(0)'">
                            <div style="font-size:2rem; margin-bottom:10px;"><%= b[0] %></div>
                            <div style="font-weight:700; margin-bottom:4px; color:#1E293B;"><%= b[1] %></div>
                            <div style="font-size:0.82rem; color:#64748B; margin-bottom:10px;"><%= b[2] %></div>
                            <div style="font-size:0.8rem; font-weight:600; color:#10B981;">
                                <i class="bi bi-check-circle-fill"></i> Active
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-activity"></i> System Status</h5>
                </div>
                <div class="card-body-custom" style="padding:0;">
                    <table class="table-custom">
                        <thead>
                            <tr><th>Component</th><th>Status</th><th>Details</th></tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><i class="bi bi-database" style="color:#4F46E5; margin-right:8px;"></i>MySQL Database</td>
                                <td><span class="badge-custom badge-graded"><i class="bi bi-circle-fill" style="font-size:0.5rem;"></i> Online</span></td>
                                <td style="font-size:0.85rem; color:#64748B;">localhost:3306/elearning_db</td>
                            </tr>
                            <tr>
                                <td><i class="bi bi-cloud" style="color:#06B6D4; margin-right:8px;"></i>Cloudinary CDN</td>
                                <td><span class="badge-custom badge-graded"><i class="bi bi-circle-fill" style="font-size:0.5rem;"></i> Connected</span></td>
                                <td style="font-size:0.85rem; color:#64748B;">Secure file storage &amp; delivery active</td>
                            </tr>
                            <tr>
                                <td><i class="bi bi-server" style="color:#F59E0B; margin-right:8px;"></i>Tomcat Server</td>
                                <td><span class="badge-custom badge-graded"><i class="bi bi-circle-fill" style="font-size:0.5rem;"></i> Running</span></td>
                                <td style="font-size:0.85rem; color:#64748B;">Apache Tomcat 10.0.26 — JDK 21</td>
                            </tr>
                            <tr>
                                <td><i class="bi bi-shield-check" style="color:#10B981; margin-right:8px;"></i>BCrypt Security</td>
                                <td><span class="badge-custom badge-graded"><i class="bi bi-circle-fill" style="font-size:0.5rem;"></i> Active</span></td>
                                <td style="font-size:0.85rem; color:#64748B;">Password hashing enabled on all accounts</td>
                            </tr>
                            <tr>
                                <td><i class="bi bi-lock" style="color:#8B5CF6; margin-right:8px;"></i>Session Management</td>
                                <td><span class="badge-custom badge-graded"><i class="bi bi-circle-fill" style="font-size:0.5rem;"></i> Active</span></td>
                                <td style="font-size:0.85rem; color:#64748B;">Role-based access control enforced</td>
                            </tr>
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