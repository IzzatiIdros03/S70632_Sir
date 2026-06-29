package controller;

import dao.BookingDAO;
import dao.DonationDAO; // Ditambah untuk menyokong pangkalan data sumbangan
import model.Booking;
import model.Donation; // Ditambah untuk menyokong model data sumbangan
import model.User;
import util.DBConnection;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Properties;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "ToyyibPayController", urlPatterns = {"/payment/createBill", "/payment/return"})
public class ToyyibPayController extends HttpServlet {

    private static final String APP_CONTEXT = "/S70632_Sir";

    private BookingDAO bookingDAO;

    private Properties fileConfig = new Properties();
    private String secretKey = "";
    private String catBooking = "nrp9me01";
    private String catDonation = "d6hgyn2q";
    private String toyyibpayBaseUrl = "https://dev.toyyibpay.com/";
    private String publicBaseUrl = "http://localhost:8081";

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        fileConfig = loadConfigProperties();

        secretKey = getConfig("TOYYIBPAY_SECRET_KEY", "toyyibpay.secret_key", "");
        catBooking = getConfig("TOYYIBPAY_CAT_BOOKING", "toyyibpay.cat_booking", "nrp9me01");
        catDonation = getConfig("TOYYIBPAY_CAT_DONATION", "toyyibpay.cat_donation", "d6hgyn2q");
        toyyibpayBaseUrl = normalizeBaseUrl(getConfig("TOYYIBPAY_BASE_URL", "toyyibpay.base_url", "https://dev.toyyibpay.com/"));
        publicBaseUrl = normalizePublicBaseUrl(getConfig("MMS_PUBLIC_BASE_URL", "mms.public_base_url", "http://localhost:8081"));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/payment/return".equals(path)) {
            handleReturn(req, resp);
            return;
        }
        if ("/payment/createBill".equals(path)) {
            handleCreateBill(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/payment/return".equals(path)) {
            handleReturn(req, resp);
            return;
        }
        if ("/payment/createBill".equals(path)) {
            handleCreateBill(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private void handleCreateBill(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String bookingIdParam = req.getParameter("bookingId");
        String donationIdParam = req.getParameter("donationId");
        String amountParam = req.getParameter("amount");
        String donorName = req.getParameter("donorName");
        String donorEmail = req.getParameter("donorEmail");
        String donorPhone = req.getParameter("donorPhone");

        if (donationIdParam != null && !donationIdParam.isEmpty()) {
            handleDonationBill(req, resp, donationIdParam, amountParam, donorName, donorEmail, donorPhone);
            return;
        }

        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/bookings");
            return;
        }

        handleBookingBill(req, resp, Integer.parseInt(bookingIdParam));
    }

    // ===== BOOKING PAYMENT =====
    private void handleBookingBill(HttpServletRequest req, HttpServletResponse resp, int bookingId)
            throws IOException, ServletException {
        try {
            Booking booking = bookingDAO.getById(bookingId);

            if (booking == null || !"APPROVED".equalsIgnoreCase(booking.getStatus())) {
                req.getSession().setAttribute("payError", "Tempahan belum diluluskan.");
                resp.sendRedirect(req.getContextPath() + "/bookings");
                return;
            }

            long amountSen = Math.round(booking.getTotalAmount() * 100);
            String returnUrl = buildReturnUrl("booking", bookingId);

            System.out.println("=== ToyyibPay Booking ===");
            System.out.println("Booking ID  : " + bookingId);
            System.out.println("API URL     : " + toyyibpayBaseUrl + "index.php/api/createBill");

            String billCode = createBill(
                    catBooking,
                    "Tempahan Masjid #" + bookingId,
                    "Bayaran bagi " + (booking.getFacilityName() != null ? booking.getFacilityName() : "Fasiliti"),
                    amountSen, returnUrl, "MMS-B-" + bookingId,
                    booking.getEmail() != null ? booking.getEmail() : "",
                    booking.getPhone() != null ? booking.getPhone() : "",
                    booking.getUserName() != null ? booking.getUserName() : "Pengguna"
            );

            System.out.println("BillCode Received: " + billCode);

            if (billCode != null && !billCode.isEmpty()) {
                savePaymentRecord(bookingId, booking.getTotalAmount(), billCode);

                String redirectUrl = toyyibpayBaseUrl + billCode;
                System.out.println("Redirecting to: " + redirectUrl);
                resp.sendRedirect(redirectUrl);
            } else {
                req.setAttribute("booking", booking);
                req.setAttribute("simMode", true);
                req.setAttribute("payError", "Tidak dapat cipta bil ToyyibPay. Sila semak Secret Key / Base URL.");
                req.getRequestDispatcher("/payment.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            System.out.println("ToyyibPay error: " + e.getMessage());
            e.printStackTrace();
            req.getSession().setAttribute("payError", "Bayaran ToyyibPay gagal diproses. Sila cuba lagi atau semak konfigurasi ToyyibPay.");
            resp.sendRedirect(req.getContextPath() + "/bookings");
        }
    }

    // ===== DONATION PAYMENT =====
    private void handleDonationBill(HttpServletRequest req, HttpServletResponse resp,
            String donationIdParam, String amountParam,
            String donorName, String donorEmail, String donorPhone)
            throws IOException, ServletException {
        try {
            if (amountParam == null || amountParam.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/donation");
                return;
            }

            double amount = Double.parseDouble(amountParam);
            int donationId = Integer.parseInt(donationIdParam);
            long amountSen = Math.round(amount * 100);
            String returnUrl = buildReturnUrl("donation", donationId);

            String billCode = createBill(
                    catDonation,
                    "Sumbangan Masjid #" + donationId,
                    "Sumbangan kepada masjid",
                    amountSen, returnUrl, "MMS-D-" + donationId,
                    donorEmail != null ? donorEmail : "",
                    donorPhone != null ? donorPhone : "",
                    donorName != null ? donorName : "Penderma"
            );

            if (billCode != null && !billCode.isEmpty()) {
                resp.sendRedirect(toyyibpayBaseUrl + billCode);
            } else {
                req.setAttribute("simMode", true);
                req.setAttribute("payError", "Tidak dapat cipta bil ToyyibPay. Sila semak Secret Key / Base URL.");
                req.getRequestDispatcher("/payment.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            System.out.println("Donation error: " + e.getMessage());
            req.setAttribute("simMode", true);
            req.setAttribute("payError", "Bayaran ToyyibPay gagal diproses. Sila cuba lagi atau semak konfigurasi ToyyibPay.");
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        }
    }

    // ===== CALL TOYYIBPAY API =====
    private String createBill(String categoryCode, String billName, String billDesc,
            long amountSen, String returnUrl, String refNo,
            String email, String phone, String toName) throws IOException {

        if (secretKey == null || secretKey.trim().isEmpty()) {
            System.out.println("ToyyibPay config missing: TOYYIBPAY_SECRET_KEY");
            return null;
        }

        URL url = new URL(toyyibpayBaseUrl + "index.php/api/createBill");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        String safeName = billName.length() > 30 ? billName.substring(0, 30) : billName;

        String data = "userSecretKey=" + URLEncoder.encode(secretKey, "UTF-8")
                + "&categoryCode=" + URLEncoder.encode(categoryCode, "UTF-8")
                + "&billName=" + URLEncoder.encode(safeName, "UTF-8")
                + "&billDescription=" + URLEncoder.encode(billDesc, "UTF-8")
                + "&billPriceSetting=1"
                + "&billPayorInfo=1"
                + "&billAmount=" + amountSen
                + "&billReturnUrl=" + URLEncoder.encode(returnUrl, "UTF-8")
                + "&billCallbackUrl=" + URLEncoder.encode(returnUrl, "UTF-8")
                + "&billExternalReferenceNo=" + URLEncoder.encode(refNo, "UTF-8")
                + "&billTo=" + URLEncoder.encode(toName, "UTF-8")
                + "&billEmail=" + URLEncoder.encode(email, "UTF-8")
                + "&billPhone=" + URLEncoder.encode(phone, "UTF-8")
                + "&billSplitPayment=0"
                + "&billPaymentChannel=0";

        System.out.println("DEBUG: Sending to ToyyibPay:");
        System.out.println("  Secret Key: " + secretKey);
        System.out.println("  Category Code: " + categoryCode);
        System.out.println("  Amount (sen): " + amountSen);
        System.out.println("  Return URL: " + returnUrl);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(data.getBytes("UTF-8"));
        }

        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode >= 200 && responseCode < 300)
                ? conn.getInputStream() : conn.getErrorStream();

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
        }

        System.out.println("ToyyibPay HTTP Status: " + responseCode);
        System.out.println("ToyyibPay Response: " + response);

        if (responseCode < 200 || responseCode >= 300) {
            System.out.println("ToyyibPay API Error (HTTP " + responseCode + "). Check config validity.");
            return null;
        }

        return parseBillCode(response.toString());
    }

    // ===== HANDLER PASCA BAYARAN (RETURN URL) =====
    private void handleReturn(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String statusId = req.getParameter("status_id");
        String billCode = req.getParameter("billcode");
        String refNo = req.getParameter("order_id"); // MMS-B-xxx atau MMS-D-xxx

        boolean success = "1".equals(statusId);

        if (success && refNo != null) {
            // =========================================================================
            // LALUAN A: UNTUK TEMPAHAN FASILITI (BOOKING)
            // =========================================================================
            if (refNo.startsWith("MMS-B-")) {
                try {
                    int bookingId = Integer.parseInt(refNo.replace("MMS-B-", ""));
                    updatePaymentStatus(bookingId, "SUCCESS");
                } catch (Exception e) {
                    System.out.println("Status update error (Booking): " + e.getMessage());
                }
            } // =========================================================================
            // LALUAN B: UNTUK SUMBANGAN (DONATION) 
            // =========================================================================
            else if (refNo.startsWith("MMS-D-")) {
                try {
                    int donationId = Integer.parseInt(refNo.replace("MMS-D-", ""));
                    DonationDAO donationDAO = new DonationDAO();

                    // Update status donation yang sedia ada (yang dah di-INSERT semasa DonationController)
                    // Status: SUCCESS kalau bayar berjaya, FAILED kalau gagal
                    String newStatus = success ? "SUCCESS" : "FAILED";
                    boolean updated = donationDAO.updateDonationStatus(donationId, newStatus);

                    if (updated) {
                        System.out.println("Donation #" + donationId + " status updated to " + newStatus);
                    } else {
                        System.err.println("WARNING: Donation #" + donationId + " update failed. May not exist.");
                    }

                } catch (Exception e) {
                    System.err.println("Ralat update status sumbangan: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }

        req.setAttribute("paySuccess", success);
        req.setAttribute("billCode", billCode);
        req.setAttribute("refNo", refNo);
        req.getRequestDispatcher("/payment.jsp").forward(req, resp);
    }

    private String buildReturnUrl(String type, int id) {
        return publicBaseUrl + APP_CONTEXT + "/payment/return?type=" + type + "&id=" + id;
    }

    private Properties loadConfigProperties() {
        Properties props = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/toyyibpay.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (Exception e) {
            System.out.println("ToyyibPay config load error: " + e.getMessage());
        }
        return props;
    }

    private String getConfig(String envName, String propKey, String fallback) {
        String envValue = System.getenv(envName);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue.trim();
        }
        String propValue = fileConfig.getProperty(propKey);
        if (propValue != null && !propValue.trim().isEmpty()) {
            return propValue.trim();
        }
        return fallback;
    }

    private static String normalizeBaseUrl(String url) {
        String trimmed = url == null ? "" : url.trim();
        if (trimmed.isEmpty()) {
            return "";
        }
        return trimmed.endsWith("/") ? trimmed : (trimmed + "/");
    }

    private static String normalizePublicBaseUrl(String url) {
        String trimmed = url == null ? "" : url.trim();
        while (trimmed.endsWith("/")) {
            trimmed = trimmed.substring(0, trimmed.length() - 1);
        }
        return trimmed.isEmpty() ? "http://localhost:8081" : trimmed;
    }

    private void savePaymentRecord(int bookingId, double amount, String billCode) throws SQLException {
        String sql = "INSERT INTO payment (booking_id, amount, method, status, bill_code, gateway) "
                + "VALUES (?,?,?,?,?,?) "
                + "ON DUPLICATE KEY UPDATE bill_code=VALUES(bill_code), status='PENDING'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setDouble(2, amount);
            ps.setString(3, "TOYYIBPAY");
            ps.setString(4, "PENDING");
            ps.setString(5, billCode);
            ps.setString(6, "TOYYIBPAY");
            ps.executeUpdate();
        }
    }

    private void updatePaymentStatus(int bookingId, String status) throws SQLException {
        String sqlPayment = "UPDATE payment SET status=?, paid_at=NOW() WHERE booking_id=?";
        String sqlBooking = "UPDATE booking SET status='PAID' WHERE booking_id=?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps1 = conn.prepareStatement(sqlPayment)) {
                ps1.setString(1, status);
                ps1.setInt(2, bookingId);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(sqlBooking)) {
                ps2.setInt(1, bookingId);
                ps2.executeUpdate();
            }
            System.out.println("DEBUG: Database updated to SUCCESS (payment) and PAID (booking) for ID: " + bookingId);
        }
    }

    private String parseBillCode(String json) {
        try {
            if (json == null || json.trim().isEmpty()) {
                return null;
            }
            if (json.trim().startsWith("[")) {
                JSONArray arr = new JSONArray(json);
                if (arr.length() > 0) {
                    JSONObject obj = arr.getJSONObject(0);
                    return obj.optString("BillCode", null);
                }
                return null;
            }
            if (json.trim().startsWith("{")) {
                JSONObject obj = new JSONObject(json);
                return obj.optString("BillCode", null);
            }
            return null;
        } catch (Exception e) {
            System.out.println("ParseBillCode error: " + e.getMessage());
        }
        return null;
    }
}
