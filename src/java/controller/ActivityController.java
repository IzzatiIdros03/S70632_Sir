package controller;

import dao.EventDAO;
import dao.NotificationDAO;
import model.Event;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

// /activity             → halaman user (lihat & mohon)
// /coordinator/activity → halaman coordinator (urus semua + approve)
@WebServlet(name = "ActivityController", urlPatterns = {"/activity", "/coordinator/activity"})
public class ActivityController extends HttpServlet {

    private EventDAO eventDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        eventDAO = new EventDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();

        if ("/coordinator/activity".equals(path)) {
            // Coordinator only
            if (!"COORDINATOR".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            loadCoordinatorPage(req, resp);
        } else {
            // User page
            loadUserPage(req, resp, user);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        String action = req.getParameter("action");

        if ("/coordinator/activity".equals(path)) {
            if (!"COORDINATOR".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
            }
            handleCoordinator(req, resp, user, action);
        } else {
            handleUser(req, resp, user, action);
        }
    }

    // ================================================================
    // USER ACTIONS
    // ================================================================
    private void handleUser(HttpServletRequest req, HttpServletResponse resp, User user, String action)
            throws ServletException, IOException {

        if ("request".equals(action)) {
            // User mohon aktiviti baru
            try {
                String name = req.getParameter("name");
                String dateStr = req.getParameter("date");
                String timeStr = req.getParameter("time");
                String location = req.getParameter("location");
                String description = req.getParameter("description");

                // Validate input wajib
                if (name == null || name.trim().isEmpty() || dateStr == null || dateStr.isEmpty()) {
                    req.setAttribute("error", "Sila isi nama dan tarikh aktiviti.");
                    loadUserPage(req, resp, user);
                    return;
                }

                // Validate minima 3 hari
                LocalDate actDate = LocalDate.parse(dateStr);
                if (actDate.isBefore(LocalDate.now().plusDays(3))) {
                    req.setAttribute("error", "Permohonan mesti dibuat sekurang-kurangnya 3 hari sebelum tarikh aktiviti.");
                    loadUserPage(req, resp, user);
                    return;
                }

                // Sediakan format Tarikh & Masa yang selamat
                Date sqlDate = Date.valueOf(dateStr);
                Time sqlTime = null;
                if (timeStr != null && !timeStr.trim().isEmpty()) {
                    // Selamatkan keadaan jika format input HTML time cuma HH:mm (tambah :00 untuk saat)
                    if (timeStr.length() == 5) {
                        timeStr += ":00";
                    }
                    sqlTime = Time.valueOf(timeStr);
                }

                // Semak konflik tarikh
                if (eventDAO.hasDateConflict(sqlDate, sqlTime, 0)) {
                    req.setAttribute("error", "Terdapat aktiviti lain yang sudah dijadualkan atau dipohon pada tarikh tersebut. Sila pilih tarikh lain.");
                    loadUserPage(req, resp, user);
                    return;
                }

                Event e = new Event();
                e.setUserId(user.getUserId());
                e.setName(name.trim());
                e.setDate(sqlDate);
                e.setTime(sqlTime);
                e.setLocation(location != null ? location.trim() : "");
                e.setDescription(description != null ? description.trim() : "");

                boolean ok = eventDAO.addEventRequest(e);
                if (ok) {
                    req.setAttribute("success", "Permohonan aktiviti berjaya dihantar! Sila tunggu kelulusan Koordinator.");
                } else {
                    req.setAttribute("error", "Gagal menghantar permohonan ke pangkalan data. Sila cuba lagi.");
                }

            } catch (Exception ex) {
                req.setAttribute("error", "Ralat sistem backend: " + ex.getMessage());
                ex.printStackTrace(); // Papar ralat detail dekat console NetBeans
            }

        } else if ("edit".equals(action)) {
            // User edit aktiviti MILIK SENDIRI
            try {
                int eventId = Integer.parseInt(req.getParameter("event_id"));
                Event existing = eventDAO.getEventById(eventId);

                // Pastikan milik user sendiri
                if (existing == null || existing.getUserId() != user.getUserId()) {
                    req.setAttribute("error", "Anda tidak dibenarkan mengedit aktiviti ini.");
                    loadUserPage(req, resp, user);
                    return;
                }

                String name = req.getParameter("name");
                String dateStr = req.getParameter("date");
                String timeStr = req.getParameter("time");

                if (name == null || name.trim().isEmpty() || dateStr == null || dateStr.isEmpty()) {
                    req.setAttribute("error", "Nama dan tarikh tidak boleh dibiarkan kosong semasa kemaskini.");
                    loadUserPage(req, resp, user);
                    return;
                }

                // Validate minima 3 hari
                LocalDate actDate = LocalDate.parse(dateStr);
                if (actDate.isBefore(LocalDate.now().plusDays(3))) {
                    req.setAttribute("error", "Tarikh aktiviti mesti sekurang-kurangnya 3 hari dari sekarang.");
                    loadUserPage(req, resp, user);
                    return;
                }

                // Sediakan format Tarikh & Masa yang selamat untuk Update
                Date sqlDate = Date.valueOf(dateStr);
                Time sqlTime = null;
                if (timeStr != null && !timeStr.trim().isEmpty()) {
                    if (timeStr.length() == 5) {
                        timeStr += ":00";
                    }
                    sqlTime = Time.valueOf(timeStr);
                }

                // Semak konflik tarikh (exclude event semasa melalui ID)
                if (eventDAO.hasDateConflict(sqlDate, sqlTime, eventId)) {
                    req.setAttribute("error", "Tarikh ini sudah ada aktiviti lain yang bertindih. Sila pilih tarikh berbeza.");
                    loadUserPage(req, resp, user);
                    return;
                }

                Event e = new Event();
                e.setEventId(eventId);
                e.setName(name.trim());
                e.setDate(sqlDate);
                e.setTime(sqlTime);
                e.setLocation(req.getParameter("location") != null ? req.getParameter("location").trim() : "");
                e.setDescription(req.getParameter("description") != null ? req.getParameter("description").trim() : "");
                e.setStatus(existing.getStatus() != null ? existing.getStatus() : "UPCOMING");
                e.setRequestStatus("PENDING_APPROVAL");

                boolean ok = eventDAO.updateEvent(e);
                if (ok) {
                    req.setAttribute("success", "Permohonan aktiviti berjaya dikemaskini!");
                } else {
                    req.setAttribute("error", "Gagal mengemaskini maklumat. Sila cuba lagi.");
                }

            } catch (Exception ex) {
                req.setAttribute("error", "Ralat sistem semasa kemaskini: " + ex.getMessage());
                ex.printStackTrace();
            }

        } else if ("delete".equals(action)) {
            // User padam aktiviti MILIK SENDIRI sahaja
            try {
                int eventId = Integer.parseInt(req.getParameter("event_id"));
                Event existing = eventDAO.getEventById(eventId);

                if (existing != null && existing.getUserId() == user.getUserId()) {
                    eventDAO.deleteEvent(eventId);
                }
                resp.sendRedirect(req.getContextPath() + "/activity?msg=deleted");
                return;
            } catch (Exception ex) {
                System.out.println("Delete error: " + ex.getMessage());
                resp.sendRedirect(req.getContextPath() + "/activity");
                return;
            }
        }

        loadUserPage(req, resp, user);
    }

    // ================================================================
    // COORDINATOR ACTIONS
    // ================================================================
    private void handleCoordinator(HttpServletRequest req, HttpServletResponse resp, User coordinator, String action)
            throws ServletException, IOException {

        if ("add".equals(action)) {
            // Coordinator tambah aktiviti — terus APPROVED
            try {
                String name = req.getParameter("name");
                String dateStr = req.getParameter("date");
                String timeStr = req.getParameter("time");

                if (name == null || name.trim().isEmpty() || dateStr == null || dateStr.isEmpty()) {
                    req.setAttribute("error", "Sila isi sekurang-kurangnya nama dan tarikh.");
                    loadCoordinatorPage(req, resp);
                    return;
                }

                Date sqlDate = Date.valueOf(dateStr);
                Time sqlTime = null;
                if (timeStr != null && !timeStr.trim().isEmpty()) {
                    if (timeStr.length() == 5) {
                        timeStr += ":00";
                    }
                    sqlTime = Time.valueOf(timeStr);
                }

                if (eventDAO.hasDateConflict(sqlDate, sqlTime, 0)) {
                    req.setAttribute("error", "Terdapat aktiviti lain pada tarikh tersebut. Sila pilih tarikh lain.");
                    loadCoordinatorPage(req, resp);
                    return;
                }

                Event e = new Event();
                e.setUserId(coordinator.getUserId());
                e.setApprovedBy(coordinator.getUserId());
                e.setName(name.trim());
                e.setDate(sqlDate);
                e.setTime(sqlTime);
                e.setLocation(req.getParameter("location") != null ? req.getParameter("location").trim() : "");
                e.setDescription(req.getParameter("description") != null ? req.getParameter("description").trim() : "");
                e.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "UPCOMING");

                boolean ok = eventDAO.addEventByCoordinator(e);
                req.setAttribute(ok ? "success" : "error", ok ? "Aktiviti berjaya ditambah!" : "Gagal menambah aktiviti.");

            } catch (Exception ex) {
                req.setAttribute("error", "Ralat: " + ex.getMessage());
                ex.printStackTrace();
            }

        } else if ("edit".equals(action)) {
            // Coordinator edit mana-mana aktiviti
            try {
                int eventId = Integer.parseInt(req.getParameter("event_id"));
                String name = req.getParameter("name");
                String dateStr = req.getParameter("date");
                String timeStr = req.getParameter("time");

                Date sqlDate = Date.valueOf(dateStr);
                Time sqlTime = null;
                if (timeStr != null && !timeStr.trim().isEmpty()) {
                    if (timeStr.length() == 5) {
                        timeStr += ":00";
                    }
                    sqlTime = Time.valueOf(timeStr);
                }

                if (eventDAO.hasDateConflict(sqlDate, sqlTime, eventId)) {
                    req.setAttribute("error", "Tarikh ini sudah ada aktiviti lain. Sila pilih tarikh berbeza.");
                    loadCoordinatorPage(req, resp);
                    return;
                }

                Event e = new Event();
                e.setEventId(eventId);
                e.setName(name.trim());
                e.setDate(sqlDate);
                e.setTime(sqlTime);
                e.setLocation(req.getParameter("location") != null ? req.getParameter("location").trim() : "");
                e.setDescription(req.getParameter("description") != null ? req.getParameter("description").trim() : "");
                e.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "UPCOMING");

                boolean ok = eventDAO.updateEvent(e);
                req.setAttribute(ok ? "success" : "error", ok ? "Aktiviti berjaya dikemaskini!" : "Gagal kemaskini.");

            } catch (Exception ex) {
                req.setAttribute("error", "Ralat: " + ex.getMessage());
                ex.printStackTrace();
            }

        } else if ("delete".equals(action)) {
            try {
                int eventId = Integer.parseInt(req.getParameter("event_id"));
                eventDAO.deleteEvent(eventId);
                resp.sendRedirect(req.getContextPath() + "/coordinator/activity?msg=deleted");
                return;
            } catch (Exception ex) {
                System.out.println("Delete error: " + ex.getMessage());
            }

        } else if ("approve".equals(action) || "reject".equals(action)) {
            try {
                int eventId = Integer.parseInt(req.getParameter("event_id"));
                String decision = "approve".equals(action) ? "APPROVED" : "REJECTED";
                boolean ok = eventDAO.approveReject(eventId, decision, coordinator.getUserId());
                req.setAttribute(ok ? "success" : "error",
                        ok ? ("approve".equals(action) ? "Permohonan telah DILULUSKAN!" : "Permohonan telah DITOLAK.")
                                : "Gagal kemaskini status.");

                // Hantar notifikasi kepada user pemohon
                if (ok) {
                    try {
                        Event event = eventDAO.getEventById(eventId);
                        if (event != null && event.getUserId() != coordinator.getUserId()) {
                            String eventName = event.getName() != null ? event.getName() : "aktiviti";
                            String type, message;
                            if ("APPROVED".equals(decision)) {
                                type = "ACTIVITY_APPROVED";
                                message = "Permohonan aktiviti anda \"" + eventName + "\" telah DILULUSKAN oleh Koordinator!";
                            } else {
                                type = "ACTIVITY_REJECTED";
                                message = "Maaf, permohonan aktiviti anda \"" + eventName + "\" telah DITOLAK oleh Koordinator.";
                            }
                            notificationDAO.addNotification(event.getUserId(), type, message, eventId);
                        }
                    } catch (Exception ne) {
                        System.err.println("Notification error (activity): " + ne.getMessage());
                    }
                }
            } catch (Exception ex) {
                req.setAttribute("error", "Ralat: " + ex.getMessage());
            }
        }

        loadCoordinatorPage(req, resp);
    }

    // ================================================================
    // HELPERS
    // ================================================================
    private void loadUserPage(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        // Auto-delete aktiviti yang dah COMPLETED
        eventDAO.deleteCompleted();
        List<Event> calendarEvents = eventDAO.getEventsForCalendar();
        req.setAttribute("approvedEvents", eventDAO.getApprovedEvents());
        req.setAttribute("calendarEvents", calendarEvents);
        req.setAttribute("calendarEventsJson", buildCalendarEventsJson(calendarEvents));
        req.setAttribute("myEvents", eventDAO.getMyEvents(user.getUserId()));
        req.setAttribute("countUpcoming", eventDAO.countUpcoming());
        req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
        req.getRequestDispatcher("/activity.jsp").forward(req, resp);
    }

    private String buildCalendarEventsJson(List<Event> events) {
        JSONArray arr = new JSONArray();
        for (Event ev : events) {
            JSONObject props = new JSONObject();
            props.put("eventId", String.valueOf(ev.getEventId()));
            props.put("location", ev.getLocation() != null ? ev.getLocation() : "-");
            props.put("time", ev.getTime() != null ? ev.getTime().toString() : "");
            props.put("organizer", ev.getUserName() != null ? ev.getUserName() : "-");
            props.put("dateStr", ev.getDate() != null ? ev.getDate().toString() : "");
            props.put("description", ev.getDescription() != null ? ev.getDescription() : "");

            JSONObject obj = new JSONObject();
            obj.put("title", ev.getName() != null ? ev.getName() : "");
            obj.put("start", ev.getDate() != null ? ev.getDate().toString() : "");
            obj.put("extendedProps", props);
            arr.put(obj);
        }
        return arr.toString();
    }

    private void loadCoordinatorPage(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("allEvents", eventDAO.getAllEvents());
        req.setAttribute("countPending", eventDAO.countPending());
        req.setAttribute("countApproved", eventDAO.countApproved());
        req.setAttribute("countUpcoming", eventDAO.countUpcoming());
        req.getRequestDispatcher("/coordinator_activity.jsp").forward(req, resp);
    }
}
