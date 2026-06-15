package com.elearning.servlet;

import com.elearning.dao.UserDAO;
import com.elearning.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        UserDAO dao = new UserDAO();

        if (dao.emailExists(email)) {
            req.setAttribute("error", "Email already registered!");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);

        if (dao.registerUser(user)) {
            req.setAttribute("success", "Registration successful! Please login.");
            req.getRequestDispatcher("/login.jsp").forward(req, res);
        } else {
            req.setAttribute("error", "Registration failed. Try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, res);
        }
    }
}