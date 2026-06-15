package com.elearning.servlet;

import com.elearning.dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        String role = (String) session.getAttribute("userRole");
        NotificationDAO dao = new NotificationDAO();

        if ("markRead".equals(req.getParameter("action"))) {
            dao.markAllRead(userId);
            res.sendRedirect(req.getContextPath() + "/notifications");
            return;
        }

        req.setAttribute("notifications", dao.getNotificationsForUser(userId));
        req.setAttribute("unreadCount", dao.getUnreadCount(userId));

        if ("admin".equals(role)) {
            req.getRequestDispatcher("/admin/notifications.jsp").forward(req, res);
        } else {
            req.getRequestDispatcher("/user/notifications.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String action = req.getParameter("action");
        String message = req.getParameter("message");
        NotificationDAO dao = new NotificationDAO();

        if ("sendAll".equals(action)) {
            dao.sendToAll(message);
        } else if ("sendOne".equals(action)) {
            dao.sendNotification(Integer.parseInt(req.getParameter("targetUserId")), message);
        }
        res.sendRedirect(req.getContextPath() + "/notifications");
    }
}