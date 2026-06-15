package com.elearning.servlet;

import com.elearning.dao.AssignmentDAO;
import com.elearning.dao.CourseDAO;
import com.elearning.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        UserDAO userDAO = new UserDAO();
        CourseDAO courseDAO = new CourseDAO();
        AssignmentDAO assignmentDAO = new AssignmentDAO();

        req.setAttribute("totalUsers", userDAO.getTotalUsers());
        req.setAttribute("totalCourses", courseDAO.getTotalCourses());
        req.setAttribute("totalSubmissions", assignmentDAO.getTotalSubmissions());
        req.setAttribute("allUsers", userDAO.getAllUsers());

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp"); return;
        }

        String action = req.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("updateRole".equals(action)) {
            userDAO.updateUserRole(Integer.parseInt(req.getParameter("userId")), req.getParameter("role"));
        } else if ("deleteUser".equals(action)) {
            userDAO.deleteUser(Integer.parseInt(req.getParameter("userId")));
        }
        res.sendRedirect(req.getContextPath() + "/admin");
    }
}