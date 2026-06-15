package com.elearning.servlet;

import com.elearning.dao.ProgressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/progress")
public class ProgressServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        ProgressDAO dao = new ProgressDAO();
        req.setAttribute("progressMap", dao.getProgressByStudent(userId));
        req.setAttribute("overallProgress", dao.getOverallProgress(userId));
        req.getRequestDispatcher("/user/progress.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        int progress = Integer.parseInt(req.getParameter("progress"));
        new ProgressDAO().updateProgress(userId, courseId, progress);
        res.sendRedirect(req.getContextPath() + "/progress");
    }
}