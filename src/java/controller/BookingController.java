package controller;

import dao.BookingDAO;
import model.Booking;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@WebServlet(name = "BookingController", urlPatterns = {
    "/bookings", "/booking/new", "/booking/save",
    "/booking/cancel", "/booking/edit", "/booking/update"
})
public class BookingController extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        try {
            switch (path) {
                case "/booking/cancel":
                    handleCancel(req, resp);
                    break;

                case "/bookings":
                    List<Booking> list = bookingDAO.getByUser(currentUser.getUserId());
                    req.setAttribute("bookings", list);
                    req.getRequestDispatcher("/user_bookings.jsp").forward(req, resp);
                    break;

                case "/booking/new":
                    // Check: tarikh mesti 3 hari dari sekarang
                    req.setAttribute("facilities", bookingDAO.getFacilities());
                    req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
                    req.getRequestDispatcher("/booking.jsp").forward(req, resp);
                    break;

                case "/booking/edit":
                    int id = Integer.parseInt(req.getParameter("id"));
                    Booking b = bookingDAO.getById(id);
                    if (b != null && "PENDING".equals(b.getStatus())) {
                        req.setAttribute("booking", b);
                        req.setAttribute("facilities", bookingDAO.getFacilities());
                        req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
                        req.getRequestDispatcher("/edit_booking.jsp").forward(req, resp);
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/bookings");
                    }
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/bookings");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        try {
            if ("/booking/save".equals(path)) {
                handleSave(req, resp);
            } else if ("/booking/update".equals(path)) {
                handleUpdate(req, resp);
            } else if ("/booking/cancel".equals(path)) {
                handleCancel(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // ===== BUAT BOOKING BARU =====
    // Flow baru: user buat booking -> PENDING -> tunggu admin approve -> baru boleh bayar
    private void handleSave(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        try {
            String facilityIdStr = req.getParameter("facilityId");
            String startDateStr = req.getParameter("startDate");
            String endDateStr = req.getParameter("endDate");
            String sessionType = req.getParameter("sessionType"); // FULL_DAY atau HALF_DAY
            String startTimeStr = req.getParameter("startTime");
            String endTimeStr = req.getParameter("endTime");

            // Validate semua field ada
            if (facilityIdStr == null || startDateStr == null || endDateStr == null) {
                req.setAttribute("error", "Sila isi semua maklumat yang diperlukan.");
                req.setAttribute("facilities", bookingDAO.getFacilities());
                req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
                req.getRequestDispatcher("/booking.jsp").forward(req, resp);
                return;
            }

            LocalDate start = LocalDate.parse(startDateStr);
            LocalDate end = LocalDate.parse(endDateStr);

            // Validate: tarikh mesti 3 hari dari sekarang
            if (start.isBefore(LocalDate.now().plusDays(3))) {
                req.setAttribute("error", "Tempahan mesti dibuat sekurang-kurangnya 3 hari lebih awal dari tarikh mula.");
                req.setAttribute("facilities", bookingDAO.getFacilities());
                req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
                req.getRequestDispatcher("/booking.jsp").forward(req, resp);
                return;
            }

            // Validate: tarikh tamat tidak boleh sebelum tarikh mula
            if (end.isBefore(start)) {
                req.setAttribute("error", "Tarikh tamat tidak boleh sebelum tarikh mula.");
                req.setAttribute("facilities", bookingDAO.getFacilities());
                req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
                req.getRequestDispatcher("/booking.jsp").forward(req, resp);
                return;
            }

            int facilityId = Integer.parseInt(facilityIdStr);
            long days = ChronoUnit.DAYS.between(start, end) + 1;

            // Kira harga ikut fasiliti, sesi, dan diskaun
            double total = bookingDAO.calculateAmount(facilityId, sessionType, (int) days);

            Booking b = new Booking();
            b.setUserId(user.getUserId());
            b.setFacilityId(facilityId);
            b.setAddress(req.getParameter("address"));
            b.setBookingType(req.getParameter("bookingType"));
            b.setSessionType(sessionType != null ? sessionType : "FULL_DAY");
            b.setEmail(user.getEmail());
            b.setPhone(user.getPhone());
            b.setStartDate(start);
            b.setEndDate(end);
            b.setTotalDays((int) days);
            b.setTotalAmount(total);

            // Set masa
            if (startTimeStr != null && !startTimeStr.isEmpty()) {
                b.setStartTime(Time.valueOf(startTimeStr + ":00"));
            }
            if (endTimeStr != null && !endTimeStr.isEmpty()) {
                b.setEndTime(Time.valueOf(endTimeStr + ":00"));
            }

            // Simpan — status PENDING, user tak perlu bayar dulu
            bookingDAO.createBooking(b);

            // Redirect ke senarai tempahan dengan mesej berjaya
            resp.sendRedirect(req.getContextPath() + "/bookings?msg=success");

        } catch (Exception e) {
            req.setAttribute("error", "Ralat: " + e.getMessage());
            req.setAttribute("facilities", bookingDAO.getFacilities());
            req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
            req.getRequestDispatcher("/booking.jsp").forward(req, resp);
        }
    }

    // ===== UPDATE BOOKING (edit) =====
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException, ServletException {

        try {
            int bookingId = Integer.parseInt(req.getParameter("bookingId"));
            LocalDate start = LocalDate.parse(req.getParameter("startDate"));
            LocalDate end = LocalDate.parse(req.getParameter("endDate"));
            String sessionType = req.getParameter("sessionType");
            String startTimeStr = req.getParameter("startTime");
            String endTimeStr = req.getParameter("endTime");
            int facilityId = Integer.parseInt(req.getParameter("facilityId"));

            // Validate 3 hari
            if (start.isBefore(LocalDate.now().plusDays(3))) {
                req.setAttribute("error", "Tempahan mesti sekurang-kurangnya 3 hari dari sekarang.");
                Booking existing = bookingDAO.getById(bookingId);
                req.setAttribute("booking", existing);
                req.setAttribute("facilities", bookingDAO.getFacilities());
                req.setAttribute("minDate", LocalDate.now().plusDays(3).toString());
                req.getRequestDispatcher("/edit_booking.jsp").forward(req, resp);
                return;
            }

            long days = ChronoUnit.DAYS.between(start, end) + 1;
            double total = bookingDAO.calculateAmount(facilityId, sessionType, (int) days);

            Booking b = new Booking();
            b.setBookingId(bookingId);
            b.setAddress(req.getParameter("address"));
            b.setBookingType(req.getParameter("bookingType") != null ? req.getParameter("bookingType") : "Lain-lain");
            b.setSessionType(sessionType != null ? sessionType : "FULL_DAY");
            b.setEmail(req.getParameter("email"));
            b.setPhone(req.getParameter("phone"));
            b.setFacilityId(facilityId);
            b.setStartDate(start);
            b.setEndDate(end);
            b.setTotalDays((int) days);
            b.setTotalAmount(total);

            if (startTimeStr != null && !startTimeStr.isEmpty()) {
                b.setStartTime(Time.valueOf(startTimeStr + ":00"));
            }
            if (endTimeStr != null && !endTimeStr.isEmpty()) {
                b.setEndTime(Time.valueOf(endTimeStr + ":00"));
            }

            bookingDAO.updateBooking(b);
            resp.sendRedirect(req.getContextPath() + "/bookings?msg=updated");

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/bookings?msg=error");
        }
    }

    // ===== CANCEL BOOKING =====
    private void handleCancel(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null) {
            idParam = req.getParameter("bookingId");
        }
        if (idParam != null) {
            bookingDAO.cancelBooking(Integer.parseInt(idParam));
        }
        resp.sendRedirect(req.getContextPath() + "/bookings?msg=canceled");
    }
}
