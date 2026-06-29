package controller;

import dao.BookingDAO;
import dao.DonationDAO;
import model.Donation;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

// TREASURER: manage donation, view booking, report dengan chart
// /treasurer/donations -> manage sumbangan
// /treasurer/report    -> laporan kewangan dengan chart
@WebServlet(name = "TreasurerDonationController", urlPatterns = {
    "/treasurer/donations", "/treasurer/report"
})
public class TreasurerDonationController extends HttpServlet {

    private DonationDAO donationDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        donationDAO = new DonationDAO();
        bookingDAO = new BookingDAO();
    }

    // Helper: check login & role
    private boolean isTreasurer(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession s = req.getSession(false);
        User u = (s != null) ? (User) s.getAttribute("currentUser") : null;
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        if (!"TREASURER".equalsIgnoreCase(u.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isTreasurer(req, resp)) {
            return;
        }
        try {
            if ("/treasurer/donations".equals(req.getServletPath())) {
                loadDonationPage(req, resp);
            } else {
                loadReport(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isTreasurer(req, resp)) {
            return;
        }
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                handleAdd(req, resp);
            } else if ("edit".equals(action)) {
                handleEdit(req, resp);
            } else if ("delete".equals(action)) {
                donationDAO.deleteDonation(Integer.parseInt(req.getParameter("donation_id")));
                resp.sendRedirect(req.getContextPath() + "/treasurer/donations");
            } else {
                resp.sendRedirect(req.getContextPath() + "/treasurer/donations");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ===== DONATION PAGE =====
    private void loadDonationPage(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        req.setAttribute("donations", donationDAO.getAllDonations());
        req.setAttribute("totalAmount", donationDAO.getTotalAmount());
        req.setAttribute("monthAmount", donationDAO.getMonthAmount());
        req.setAttribute("totalRecords", donationDAO.getTotalRecords());
        req.getRequestDispatcher("/treasurer_donation.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        try {
            Donation d = new Donation();
            d.setDonorName(req.getParameter("donor_name").trim());
            d.setAmount(new BigDecimal(req.getParameter("amount")));
            String type = req.getParameter("donation_type");
            d.setDonationType((type != null && !type.trim().isEmpty()) ? type.trim() : "Tabung Umum");
            d.setPaymentMethod(req.getParameter("payment_method"));
            d.setDate(java.sql.Date.valueOf(req.getParameter("date")));
            d.setNotes(req.getParameter("notes") != null ? req.getParameter("notes").trim() : "");
            d.setUserId(0);
            boolean ok = donationDAO.addDonation(d);
            req.setAttribute(ok ? "success" : "error", ok ? "Rekod berjaya ditambah!" : "Gagal tambah.");
        } catch (Exception e) {
            req.setAttribute("error", "Ralat: " + e.getMessage());
        }
        loadDonationPage(req, resp);
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        try {
            boolean ok = donationDAO.editDonation(
                    Integer.parseInt(req.getParameter("donation_id")),
                    req.getParameter("donor_name").trim(),
                    new BigDecimal(req.getParameter("amount")),
                    req.getParameter("donation_type"),
                    req.getParameter("payment_method"),
                    req.getParameter("notes"));
            req.setAttribute(ok ? "success" : "error", ok ? "Rekod berjaya dikemaskini!" : "Gagal kemaskini.");
        } catch (Exception e) {
            req.setAttribute("error", "Ralat: " + e.getMessage());
        }
        loadDonationPage(req, resp);
    }

    // ===== REPORT PAGE — data betul dari database =====
    private void loadReport(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {

        // Donation stats
        req.setAttribute("totalDonation", donationDAO.getTotalAmount());
        req.setAttribute("monthDonation", donationDAO.getMonthAmount());
        req.setAttribute("totalDonationRecords", donationDAO.getTotalRecords());
        req.setAttribute("donations", donationDAO.getAllDonations());

        // Booking stats (treasurer boleh view)
        req.setAttribute("allBookings", bookingDAO.getAll());
        req.setAttribute("totalBookings", bookingDAO.getAll().size());
        req.setAttribute("approvedBookings", bookingDAO.countByStatus("APPROVED"));
        req.setAttribute("pendingBookings", bookingDAO.countByStatus("PENDING"));
        req.setAttribute("totalRevenue", bookingDAO.getTotalRevenue());
        req.setAttribute("monthRevenue", bookingDAO.getMonthRevenue());

        // ===== CHART DATA — semua dari real database =====
        // ==== HASIL TEMPAHAN — 4 mode ====
        Map<String, Double> revByMonth = bookingDAO.getRevenueByMonth();
        req.setAttribute("revMonthLabels", toJson(revByMonth.keySet().toArray()));
        req.setAttribute("revMonthData", toJson(revByMonth.values().toArray()));

        Map<String, Double> revByDay = bookingDAO.getRevenueByDay();
        req.setAttribute("revDayLabels", toJson(revByDay.keySet().toArray()));
        req.setAttribute("revDayData", toJson(revByDay.values().toArray()));

        Map<String, Double> revByWeek = bookingDAO.getRevenueByWeek();
        req.setAttribute("revWeekLabels", toJson(revByWeek.keySet().toArray()));
        req.setAttribute("revWeekData", toJson(revByWeek.values().toArray()));

        Map<String, Double> revByYear = bookingDAO.getRevenueByYear();
        req.setAttribute("revYearLabels", toJson(revByYear.keySet().toArray()));
        req.setAttribute("revYearData", toJson(revByYear.values().toArray()));

        // ==== SUMBANGAN — 4 mode ====
        Map<String, BigDecimal> donByMonth = donationDAO.getAmountByMonth();
        req.setAttribute("donMonthLabels", toJson(donByMonth.keySet().toArray()));
        req.setAttribute("donMonthData", toJson(donByMonth.values().toArray()));

        Map<String, BigDecimal> donByDay = donationDAO.getAmountByDay();
        req.setAttribute("donDayLabels", toJson(donByDay.keySet().toArray()));
        req.setAttribute("donDayData", toJson(donByDay.values().toArray()));

        Map<String, BigDecimal> donByWeek = donationDAO.getAmountByWeek();
        req.setAttribute("donWeekLabels", toJson(donByWeek.keySet().toArray()));
        req.setAttribute("donWeekData", toJson(donByWeek.values().toArray()));

        Map<String, BigDecimal> donByYear = donationDAO.getAmountByYear();
        req.setAttribute("donYearLabels", toJson(donByYear.keySet().toArray()));
        req.setAttribute("donYearData", toJson(donByYear.values().toArray()));

        // Doughnut: Kaedah bayaran sumbangan
        Map<String, Integer> donByMethod = donationDAO.getCountByPaymentMethod();
        req.setAttribute("donMethodLabels", toJson(donByMethod.keySet().toArray()));
        req.setAttribute("donMethodData", toJson(donByMethod.values().toArray()));

        // Pie: Status tempahan
        req.setAttribute("bookingStatusData", "["
                + bookingDAO.countByStatus("PENDING") + ","
                + bookingDAO.countByStatus("APPROVED") + ","
                + bookingDAO.countByStatus("REJECTED") + ","
                + bookingDAO.countByStatus("CANCELED") + "]");

        req.getRequestDispatcher("/treasurer_report.jsp").forward(req, resp);
    }

    // Helper: Object[] -> JSON string
    private String toJson(Object[] arr) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] instanceof String) {
                sb.append("\"").append(arr[i].toString().replace("\"", "\\\"")).append("\"");
            } else {
                sb.append(arr[i]);
            }
            if (i < arr.length - 1) {
                sb.append(",");
            }
        }
        return sb.append("]").toString();
    }
}