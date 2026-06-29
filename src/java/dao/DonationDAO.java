package dao;

import model.Donation;
import util.DBConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DonationDAO {

    // ===== Tambah donation dan return boolean =====
    public boolean addDonation(Donation d) {
        return createDonation(d) > 0;
    }

    // ===== Ganti/Selaras nama method kepada createDonation (Digunakan oleh DonationController) =====
    public int createDonation(Donation d) {
        // Ditambah lajur status ke dalam INSERT statement
        String sql = "INSERT INTO donation (user_id, donor_name, amount, donation_type, payment_method, date, notes, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Jika user_id == 0 (contoh: rekod manual oleh Treasurer), guna NULL supaya tidak melanggar foreign key
            if (d.getUserId() > 0) {
                ps.setInt(1, d.getUserId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, d.getDonorName());
            ps.setBigDecimal(3, d.getAmount());
            ps.setString(4, d.getDonationType());
            // Jika dalam model belum set payment method, kita defaultkan kepada "Online"
            ps.setString(5, d.getPaymentMethod() != null ? d.getPaymentMethod() : "Online");
            ps.setTimestamp(6, d.getDate() != null ? new java.sql.Timestamp(d.getDate().getTime()) : new java.sql.Timestamp(System.currentTimeMillis()));
            ps.setString(7, d.getNotes());
            ps.setString(8, d.getStatus() != null ? d.getStatus() : "PENDING"); // Default status permulaan

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1); // Pulangkan generated auto-increment ID untuk ToyyibPay
                }
            }
        } catch (SQLException e) {
            System.out.println("createDonation Error: " + e.getMessage());
        }
        return -1;
    }

    // ===== Khas untuk ToyyibPayController mengemas kini status sumbangan tanpa perlukan approval =====
    public boolean updateDonationStatus(int donationId, String status) {
        String sql = "UPDATE donation SET status = ? WHERE donation_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, donationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateDonationStatus Error: " + e.getMessage());
            return false;
        }
    }

    // ===== Ambil semua rekod donation =====
    public List<Donation> getAllDonations() {
        List<Donation> list = new ArrayList<>();
        String sql = "SELECT * FROM donation ORDER BY date DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Donation d = new Donation();
                d.setDonationId(rs.getInt("donation_id"));
                d.setUserId(rs.getInt("user_id"));
                d.setDonorName(rs.getString("donor_name"));
                d.setAmount(rs.getBigDecimal("amount"));
                d.setDonationType(rs.getString("donation_type"));
                d.setPaymentMethod(rs.getString("payment_method"));
                d.setDate(rs.getDate("date"));
                d.setNotes(rs.getString("notes"));
                d.setStatus(rs.getString("status")); // Mengambil nilai status dari DB
                list.add(d);
            }
        } catch (SQLException e) {
            System.out.println("getAllDonations Error: " + e.getMessage());
        }
        return list;
    }

    // ===== Edit donation =====
    public boolean editDonation(int id, String name, BigDecimal amt,
            String type, String method, String notes) {
        String sql = "UPDATE donation SET donor_name=?, amount=?, donation_type=?, payment_method=?, notes=? "
                + "WHERE donation_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setBigDecimal(2, amt);
            ps.setString(3, type);
            ps.setString(4, method);
            ps.setString(5, notes);
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("editDonation Error: " + e.getMessage());
            return false;
        }
    }

    // ===== Padam donation =====
    public boolean deleteDonation(int id) {
        String sql = "DELETE FROM donation WHERE donation_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteDonation Error: " + e.getMessage());
            return false;
        }
    }

    // =========================================================================
    // BARISAN METHOD STATISTIK (Ditapis supaya hanya mengira status 'SUCCESS')
    // =========================================================================
    public BigDecimal getTotalAmount() {
        // Ditapis: WHERE status = 'SUCCESS'
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM donation WHERE status = 'SUCCESS'";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            if (r.next()) {
                BigDecimal t = r.getBigDecimal(1);
                return t != null ? t : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            System.out.println("getTotalAmount Error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal getMonthAmount() {
        // Ditapis: AND status = 'SUCCESS'
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM donation "
                + "WHERE MONTH(date)=MONTH(NOW()) AND YEAR(date)=YEAR(NOW()) AND status = 'SUCCESS'";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            if (r.next()) {
                BigDecimal t = r.getBigDecimal(1);
                return t != null ? t : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            System.out.println("getMonthAmount Error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public int getTotalRecords() {
        // Hanya mengira bilangan transaksi sumbangan yang berjaya masuk sahaja
        String sql = "SELECT COUNT(*) FROM donation WHERE status = 'SUCCESS'";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            if (r.next()) {
                return r.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("getTotalRecords Error: " + e.getMessage());
        }
        return 0;
    }

    // ===== DATA CARTA: Jumlah sumbangan mengikut Jenis Tabung (Hanya yang SUCCESS) =====
    public Map<String, BigDecimal> getAmountByType() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT COALESCE(donation_type, 'Lain-lain') as t, COALESCE(SUM(amount), 0) as total "
                + "FROM donation WHERE status = 'SUCCESS' GROUP BY donation_type ORDER BY total DESC";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("t"), r.getBigDecimal("total"));
            }
        } catch (SQLException e) {
            System.out.println("getAmountByType Error: " + e.getMessage());
        }
        return map;
    }

    // ===== DATA CARTA: Jumlah sumbangan mengikut Bulan (Hanya yang SUCCESS) =====
    public Map<String, BigDecimal> getAmountByMonth() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(date, '%b %Y') as lbl, COALESCE(SUM(amount), 0) as total "
                + "FROM donation WHERE date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) AND status = 'SUCCESS' "
                + "GROUP BY YEAR(date), MONTH(date), lbl ORDER BY YEAR(date) ASC, MONTH(date) ASC";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("lbl"), r.getBigDecimal("total"));
            }
        } catch (SQLException e) {
            System.out.println("getAmountByMonth Error: " + e.getMessage());
        }
        return map;
    }

    // ===== HARI: 14 hari terakhir =====
    public Map<String, BigDecimal> getAmountByDay() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(date, '%d %b') as lbl, COALESCE(SUM(amount), 0) as total "
                + "FROM donation WHERE date >= DATE_SUB(CURDATE(), INTERVAL 14 DAY) AND status = 'SUCCESS' "
                + "GROUP BY DATE(date), lbl ORDER BY DATE(date) ASC";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("lbl"), r.getBigDecimal("total"));
            }
        } catch (SQLException e) {
            System.out.println("getAmountByDay Error: " + e.getMessage());
        }
        return map;
    }

    // ===== MINGGU: 8 minggu terakhir =====
    public Map<String, BigDecimal> getAmountByWeek() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT CONCAT('Mgu ', WEEK(date, 1), ' ', YEAR(date)) as lbl, "
                + "COALESCE(SUM(amount), 0) as total "
                + "FROM donation WHERE date >= DATE_SUB(CURDATE(), INTERVAL 8 WEEK) AND status = 'SUCCESS' "
                + "GROUP BY YEAR(date), WEEK(date, 1), lbl "
                + "ORDER BY YEAR(date) ASC, WEEK(date, 1) ASC";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("lbl"), r.getBigDecimal("total"));
            }
        } catch (SQLException e) {
            System.out.println("getAmountByWeek Error: " + e.getMessage());
        }
        return map;
    }

    // ===== TAHUN: 5 tahun terakhir =====
    public Map<String, BigDecimal> getAmountByYear() {
        Map<String, BigDecimal> map = new LinkedHashMap<>();
        String sql = "SELECT YEAR(date) as lbl, COALESCE(SUM(amount), 0) as total "
                + "FROM donation WHERE date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR) AND status = 'SUCCESS' "
                + "GROUP BY YEAR(date) ORDER BY YEAR(date) ASC";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("lbl"), r.getBigDecimal("total"));
            }
        } catch (SQLException e) {
            System.out.println("getAmountByYear Error: " + e.getMessage());
        }
        return map;
    }

    // ===== DATA CARTA: Bilangan Transaksi mengikut Kaedah Pembayaran (Hanya yang SUCCESS) =====
    public Map<String, Integer> getCountByPaymentMethod() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT COALESCE(payment_method, 'Lain-lain') as m, COUNT(*) as cnt "
                + "FROM donation WHERE status = 'SUCCESS' GROUP BY payment_method";
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement(); ResultSet r = s.executeQuery(sql)) {
            while (r.next()) {
                map.put(r.getString("m"), r.getInt("cnt"));
            }
        } catch (SQLException e) {
            System.out.println("getCountByPaymentMethod Error: " + e.getMessage());
        }
        return map;
    }
}