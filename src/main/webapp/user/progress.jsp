<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<%
    if (session.getAttribute("loggedUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Map<String, Integer> progressMap = (Map<String, Integer>) request.getAttribute("progressMap");
    int overallProgress = request.getAttribute("overallProgress") != null
                          ? (int) request.getAttribute("overallProgress") : 0;
    if (progressMap == null) progressMap = new java.util.LinkedHashMap<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/head.jsp"/>
    <title>Progress — ELearn</title>
</head>
<body>
<div class="app-layout">
    <jsp:include page="/user/sidebar.jsp"/>
    <div class="main-content">
        <div class="top-navbar">
            <div class="page-title">Learning Progress</div>
        </div>
        <div class="content-area">

            <div class="card-custom" style="margin-bottom:28px;">
                <div class="card-body-custom">
                    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;">
                        <div>
                            <h5 style="font-weight:700;margin:0;">Overall Progress</h5>
                            <p style="color:#64748B;font-size:0.88rem;margin:4px 0 0;">
                                Across all enrolled courses
                            </p>
                        </div>
                        <div style="font-size:2.8rem;font-weight:800;color:#4F46E5;
                                    background:rgba(79,70,229,0.08);padding:12px 20px;border-radius:12px;">
                            <%= overallProgress %>%
                        </div>
                    </div>
                    <div class="progress-bar-wrap" style="height:14px;">
                        <div class="progress-bar-fill" style="width:<%= overallProgress %>%;"></div>
                    </div>
                </div>
            </div>

            <div class="card-custom">
                <div class="card-header-custom">
                    <h5><i class="bi bi-bar-chart-line"></i> Course-wise Progress</h5>
                </div>
                <div class="card-body-custom">
                    <% if (progressMap.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="bi bi-graph-up"></i>
                        <h5>No progress data yet</h5>
                        <p>Enroll in courses to track your progress.</p>
                    </div>
                    <% } else {
                        for (Map.Entry<String, Integer> entry : progressMap.entrySet()) {
                            int pct = entry.getValue();
                            String barColor = pct >= 80
                                ? "linear-gradient(90deg,#10B981,#34D399)"
                                : pct >= 50
                                ? "linear-gradient(90deg,#F59E0B,#FCD34D)"
                                : "linear-gradient(90deg,#EF4444,#F87171)";
                            String pctColor = pct >= 80 ? "#10B981" : pct >= 50 ? "#F59E0B" : "#EF4444";
                    %>
                    <div style="margin-bottom:24px;">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
                            <span style="font-weight:600;font-size:0.95rem;"><%= entry.getKey() %></span>
                            <span style="font-size:0.88rem;font-weight:700;color:<%= pctColor %>;">
                                <%= pct %>%
                            </span>
                        </div>
                        <div class="progress-bar-wrap">
                            <div class="progress-bar-fill"
                                 style="width:<%= pct %>%;background:<%= barColor %>;"></div>
                        </div>
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