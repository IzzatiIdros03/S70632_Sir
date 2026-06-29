package controller;

import dao.NotificationDAO;
import model.Notification;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationController", urlPatterns = {"/notifications", "/notifications/markRead"})
public class NotificationController extends HttpServlet {

    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        List<Notification> notifs = notificationDAO.getByUser(user.getUserId());
        int unreadCount = notificationDAO.countUnread(user.getUserId());
        req.setAttribute("notifications", notifs);
        req.setAttribute("unreadCount", unreadCount);
        req.getRequestDispatcher("/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        if ("/notifications/markRead".equals(req.getServletPath())) {
            notificationDAO.markAllRead(user.getUserId());
        }
        resp.sendRedirect(req.getContextPath() + "/notifications");
    }
}