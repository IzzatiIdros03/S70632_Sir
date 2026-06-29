package controller;

import dao.NotificationDAO;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        int unreadCount = notificationDAO.countUnread(currentUser.getUserId());
        req.setAttribute("unreadNotifCount", unreadCount);

        req.getRequestDispatcher("home.jsp").forward(req, resp);
    }
}
