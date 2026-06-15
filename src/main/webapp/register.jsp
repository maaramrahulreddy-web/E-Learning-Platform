<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — ELearn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">
            <div class="logo-icon">🎓</div>
            <h2>Create Account</h2>
            <p>Join ELearn and start learning today</p>
        </div>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert-custom alert-error">
            <i class="bi bi-exclamation-circle"></i> <%= request.getAttribute("error") %>
        </div>
        <% } %>
        <form action="register" method="post">
            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="name" name="name" placeholder="Full Name" required>
                <label for="name">Full Name</label>
            </div>
            <div class="form-floating mb-3">
                <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                <label for="email">Email Address</label>
            </div>
            <div class="form-floating mb-4">
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Password" required minlength="6">
                <label for="password">Password</label>
            </div>
            <button type="submit" class="btn-primary-custom">
                <i class="bi bi-person-plus"></i> Create Account
            </button>
        </form>
        <p class="text-center mt-4" style="color:#64748B; font-size:0.9rem;">
            Already have an account? <a href="login" style="color:#4F46E5; font-weight:600;">Sign In</a>
        </p>
    </div>
</div>
<script src="assets/js/main.js"></script>
</body>
</html>