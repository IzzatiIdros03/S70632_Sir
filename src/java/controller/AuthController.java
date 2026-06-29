package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "AuthController", urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        switch (path) {
            case "/login":
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                break;
            case "/register":
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                break;
            case "/logout":
                req.getSession().invalidate();
                resp.sendRedirect(req.getContextPath() + "/login");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        try {
            if ("/register".equals(path)) {
                handleRegister(req, resp);
            } else if ("/login".equals(path)) {
                handleLogin(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {

        User u = new User();
        u.setName(req.getParameter("name"));
        u.setEmail(req.getParameter("email"));
        u.setPhone(req.getParameter("phone"));
        u.setPassword(req.getParameter("password"));

        // default role user yang daftar sendiri
        u.setRole("COMMUNITY");

        if (userDAO.register(u)) {
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("error", "Pendaftaran gagal.");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userDAO.login(email, password);
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("currentUser", user);

            // redirect ikut role
            if ("COORDINATOR".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/bookings");
            } else if ("TREASURER".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/treasurer/report");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
        } else {
            req.setAttribute("error", "Emel atau kata laluan salah.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
