package controller;

import dao.DonationDAO;
import model.Donation;
import model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;

@WebServlet(name = "DonationController", urlPatterns = {"/donation", "/donation/process"})
public class DonationController extends HttpServlet {

    private DonationDAO donationDAO;

    @Override
    public void init() {
        donationDAO = new DonationDAO();
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

        // Papar borang sumbangan
        req.getRequestDispatcher("/donation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            String amountParam = req.getParameter("amount");
            String donorName = req.getParameter("donorName");
            String donorEmail = req.getParameter("donorEmail");
            String donorPhone = req.getParameter("donorPhone");

            // Validate amount
            if (amountParam == null || amountParam.trim().isEmpty()) {
                req.setAttribute("payError", "Sila masukkan amaun sumbangan.");
                req.getRequestDispatcher("/donation.jsp").forward(req, resp);
                return;
            }

            BigDecimal amount;
            try {
                amount = new BigDecimal(amountParam.trim());
                if (amount.compareTo(BigDecimal.ONE) < 0) {
                    req.setAttribute("payError", "Amaun sumbangan mesti sekurang-kurangnya RM 1.00");
                    req.getRequestDispatcher("/donation.jsp").forward(req, resp);
                    return;
                }
            } catch (NumberFormatException e) {
                req.setAttribute("payError", "Amaun sumbangan tidak sah.");
                req.getRequestDispatcher("/donation.jsp").forward(req, resp);
                return;
            }

            // ===== SIMPAN DULU KE DB DENGAN STATUS PENDING =====
            Donation d = new Donation();
            d.setUserId(currentUser.getUserId());
            d.setDonorName(donorName != null && !donorName.trim().isEmpty()
                    ? donorName.trim() : currentUser.getName());
            d.setAmount(amount);
            d.setDonationType("Sumbangan Am");
            d.setPaymentMethod("Online");
            d.setDate(new java.sql.Date(System.currentTimeMillis()));
            d.setNotes("Sumbangan online via ToyyibPay");
            d.setStatus("PENDING"); // tunggu callback ToyyibPay

            int newDonationId = donationDAO.createDonation(d);

            if (newDonationId <= 0) {
                System.err.println("=========== Donation INSERT FAILED ===========");
                req.setAttribute("payError", "Gagal menyimpan rekod sumbangan. Sila cuba lagi.");
                req.getRequestDispatcher("/donation.jsp").forward(req, resp);
                return;
            }

            System.out.println("DonationController: Created donation_id=" + newDonationId + " (PENDING)");

            // ===== FORWARD KE TOYYIBPAY DENGAN ID SEBENAR =====
            String forwardUrl = "/payment/createBill?donationId=" + newDonationId
                    + "&amount=" + amountParam
                    + "&donorName=" + URLEncoder.encode(d.getDonorName(), "UTF-8")
                    + "&donorEmail=" + (donorEmail != null ? URLEncoder.encode(donorEmail, "UTF-8") : "")
                    + "&donorPhone=" + (donorPhone != null ? URLEncoder.encode(donorPhone, "UTF-8") : "");

            req.getRequestDispatcher(forwardUrl).forward(req, resp);

        } catch (Exception e) {
            System.err.println("DonationController error: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("payError", "Ralat proses sumbangan: " + e.getMessage());
            req.getRequestDispatcher("/donation.jsp").forward(req, resp);
        }
    }
}
