package dao;

import model.Booking;
import model.Facility;
import util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class BookingDAO {

    public List<Facility> getFacilities() throws SQLException {
        List<Facility> list = new ArrayList<>();
        String sql = "SELECT * FROM facility WHERE status = 'AVAILABLE'";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Facility f = new Facility();
                f.setFacilityId(rs.getInt("facility_id"));
                f.setName(rs.getString("name"));
                f.setType(rs.getString("type"));
                f.setRatePerDay(rs.getDouble("rate_per_day"));
                try {
                    f.setHalfDayRate(rs.getDouble("half_day_rate"));
                } catch (SQLException e) {
                    f.setHalfDayRate(f.getRatePerDay() / 2);
                }
                list.add(f);
            }
        }
        return list;
    }

    public boolean hasConflict(int facilityId, LocalDate startDate, LocalDate endDate,
            String sessionType, int excludeBookingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM booking "
                + "WHERE facility_id=? AND status IN ('APPROVED','PENDING') AND booking_id!=? "
                + "AND NOT (end_date < ? OR start_date > ?) "
                + "AND (session_type=? OR session_type='FULL_DAY' OR ?='FULL_DAY')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facilityId);
            ps.setInt(2, excludeBookingId);
            ps.setDate(3, Date.valueOf(startDate));
            ps.setDate(4, Date.valueOf(endDate));
            ps.setString(5, sessionType);
            ps.setString(6, sessionType);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public List<Booking> getAll() throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.name as user_name, f.name as facility_name FROM booking b "
                + "JOIN user u ON b.user_id=u.user_id JOIN facility f ON b.facility_id=f.facility_id "
                + "ORDER BY b.booking_id DESC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Booking b = mapRow(rs);
                b.setUserName(rs.getString("user_name"));
                b.setFacilityName(rs.getString("facility_name"));
                list.add(b);
            }
        }
        return list;
    }

    public List<Booking> getByUser(int userId) throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, f.name as facility_name FROM booking b "
                + "JOIN facility f ON b.facility_id=f.facility_id WHERE b.user_id=? ORDER BY b.booking_id DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = mapRow(rs);
                b.setFacilityName(rs.getString("facility_name"));
                list.add(b);
            }
        }
        return list;
    }

    public Booking getById(int id) throws SQLException {
        String sql = "SELECT b.*, f.name as facility_name FROM booking b "
                + "JOIN facility f ON b.facility_id=f.facility_id WHERE b.booking_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Booking b = mapRow(rs);
                b.setFacilityName(rs.getString("facility_name"));
                return b;
            }
        }
        return null;
    }

    public List<Booking> getReportByDate(LocalDate start, LocalDate end) throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.name as user_name, f.name as facility_name FROM booking b "
                + "JOIN user u ON b.user_id=u.user_id JOIN facility f ON b.facility_id=f.facility_id "
                + "WHERE b.start_date>=? AND b.end_date<=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(start));
            ps.setDate(2, Date.valueOf(end));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = mapRow(rs);
                b.setUserName(rs.getString("user_name"));
                b.setFacilityName(rs.getString("facility_name"));
                list.add(b);
            }
        }
        return list;
    }

    public int createBooking(Booking b) throws SQLException {
        String sql = "INSERT INTO booking (user_id,address,facility_id,booking_type,session_type,"
                + "start_time,end_time,email,phone,start_date,end_date,total_days,total_amount,status) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, b.getUserId());
            ps.setString(2, b.getAddress());
            ps.setInt(3, b.getFacilityId());
            ps.setString(4, b.getBookingType());
            ps.setString(5, b.getSessionType() != null ? b.getSessionType() : "FULL_DAY");
            if (b.getStartTime() != null) {
                ps.setTime(6, b.getStartTime());
            } else {
                ps.setNull(6, Types.TIME);
            }
            if (b.getEndTime() != null) {
                ps.setTime(7, b.getEndTime());
            } else {
                ps.setNull(7, Types.TIME);
            }
            ps.setString(8, b.getEmail());
            ps.setString(9, b.getPhone());
            ps.setDate(10, Date.valueOf(b.getStartDate()));
            ps.setDate(11, Date.valueOf(b.getEndDate()));
            ps.setInt(12, b.getTotalDays());
            ps.setDouble(13, b.getTotalAmount());
            ps.setString(14, "PENDING");
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        }
    }

    public boolean updateBooking(Booking b) throws SQLException {
        long days = ChronoUnit.DAYS.between(b.getStartDate(), b.getEndDate()) + 1;
        String sql = "UPDATE booking SET address=?,booking_type=?,session_type=?,start_time=?,end_time=?,"
                + "email=?,phone=?,facility_id=?,start_date=?,end_date=?,total_days=?,total_amount=? WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getAddress());
            ps.setString(2, b.getBookingType());
            ps.setString(3, b.getSessionType() != null ? b.getSessionType() : "FULL_DAY");
            if (b.getStartTime() != null) {
                ps.setTime(4, b.getStartTime());
            } else {
                ps.setNull(4, Types.TIME);
            }
            if (b.getEndTime() != null) {
                ps.setTime(5, b.getEndTime());
            } else {
                ps.setNull(5, Types.TIME);
            }
            ps.setString(6, b.getEmail());
            ps.setString(7, b.getPhone());
            ps.setInt(8, b.getFacilityId());
            ps.setDate(9, Date.valueOf(b.getStartDate()));
            ps.setDate(10, Date.valueOf(b.getEndDate()));
            ps.setInt(11, (int) days);
            ps.setDouble(12, b.getTotalAmount());
            ps.setInt(13, b.getBookingId());
            return ps.executeUpdate() > 0;
        }
    }

    public void updateStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE booking SET status=? WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        }
    }

    public boolean cancelBooking(int bookingId) throws SQLException {
        String sql = "UPDATE booking SET status='CANCELED' WHERE booking_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    public double calculateAmount(int facilityId, String sessionType, int totalDays) throws SQLException {
        String sql = "SELECT rate_per_day, half_day_rate FROM facility WHERE facility_id=?";
        double fullRate = 100.0, halfRate = 50.0;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, facilityId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                fullRate = rs.getDouble("rate_per_day");
                try {
                    halfRate = rs.getDouble("half_day_rate");
                } catch (SQLException e) {
                    halfRate = fullRate / 2;
                }
            }
        }
        double rate = "HALF_DAY".equals(sessionType) ? halfRate : fullRate;
        double total = rate * totalDays;
        if (totalDays >= 3) {
            total *= 0.80;
        }
        return total;
    }

    // ===== STATS & CHART METHODS =====
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM booking WHERE status=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM booking WHERE status IN ('APPROVED','PAID')";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0;
    }

    public double getMonthRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM booking "
                + "WHERE status IN ('APPROVED','PAID') AND MONTH(start_date)=MONTH(NOW()) AND YEAR(start_date)=YEAR(NOW())";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0;
    }

    // Booking count per bulan — 6 bulan terakhir (untuk bar chart)
    public Map<String, Integer> getBookingCountByMonth() throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(start_date,'%b %Y') as lbl, COUNT(*) as cnt "
                + "FROM booking WHERE start_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) "
                + "GROUP BY YEAR(start_date), MONTH(start_date), lbl "
                + "ORDER BY YEAR(start_date) ASC, MONTH(start_date) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getInt("cnt"));
            }
        }
        return map;
    }

    // Jumlah tempahan — 14 hari terakhir
    public Map<String, Integer> getBookingCountByDay() throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(start_date,'%d %b') as lbl, COUNT(*) as cnt "
                + "FROM booking WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 14 DAY) "
                + "GROUP BY DATE(start_date), lbl ORDER BY DATE(start_date) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getInt("cnt"));
            }
        }
        return map;
    }

    // Jumlah tempahan — 8 minggu terakhir
    public Map<String, Integer> getBookingCountByWeek() throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT CONCAT('Mgu ', WEEK(start_date,1),' ',YEAR(start_date)) as lbl, COUNT(*) as cnt "
                + "FROM booking WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 8 WEEK) "
                + "GROUP BY YEAR(start_date), WEEK(start_date,1), lbl "
                + "ORDER BY YEAR(start_date) ASC, WEEK(start_date,1) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getInt("cnt"));
            }
        }
        return map;
    }

    // Jumlah tempahan — 5 tahun terakhir
    public Map<String, Integer> getBookingCountByYear() throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT YEAR(start_date) as lbl, COUNT(*) as cnt "
                + "FROM booking WHERE start_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR) "
                + "GROUP BY YEAR(start_date) ORDER BY YEAR(start_date) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getInt("cnt"));
            }
        }
        return map;
    }

    // Hasil per bulan — 6 bulan terakhir (untuk line chart)
    public Map<String, Double> getRevenueByMonth() throws SQLException {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(start_date,'%b %Y') as lbl, COALESCE(SUM(total_amount),0) as total "
                + "FROM booking WHERE status IN ('APPROVED','PAID') AND start_date >= DATE_SUB(NOW(), INTERVAL 6 MONTH) "
                + "GROUP BY YEAR(start_date), MONTH(start_date), lbl "
                + "ORDER BY YEAR(start_date) ASC, MONTH(start_date) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getDouble("total"));
            }
        }
        return map;
    }

    // HARI: 14 hari terakhir
    public Map<String, Double> getRevenueByDay() throws SQLException {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(start_date,'%d %b') as lbl, COALESCE(SUM(total_amount),0) as total "
                + "FROM booking WHERE status IN ('APPROVED','PAID') AND start_date >= DATE_SUB(CURDATE(), INTERVAL 14 DAY) "
                + "GROUP BY DATE(start_date), lbl ORDER BY DATE(start_date) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getDouble("total"));
            }
        }
        return map;
    }

    // MINGGU: 8 minggu terakhir
    public Map<String, Double> getRevenueByWeek() throws SQLException {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT CONCAT('Mgu ', WEEK(start_date,1),' ',YEAR(start_date)) as lbl, "
                + "COALESCE(SUM(total_amount),0) as total "
                + "FROM booking WHERE status IN ('APPROVED','PAID') AND start_date >= DATE_SUB(CURDATE(), INTERVAL 8 WEEK) "
                + "GROUP BY YEAR(start_date), WEEK(start_date,1), lbl "
                + "ORDER BY YEAR(start_date) ASC, WEEK(start_date,1) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getDouble("total"));
            }
        }
        return map;
    }

    // TAHUN: 5 tahun terakhir
    public Map<String, Double> getRevenueByYear() throws SQLException {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT YEAR(start_date) as lbl, COALESCE(SUM(total_amount),0) as total "
                + "FROM booking WHERE status IN ('APPROVED','PAID') AND start_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR) "
                + "GROUP BY YEAR(start_date) ORDER BY YEAR(start_date) ASC";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("lbl"), rs.getDouble("total"));
            }
        }
        return map;
    }

    // Booking mengikut fasiliti (untuk doughnut / horizontal bar)
    public Map<String, Integer> getBookingCountByFacility() throws SQLException {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT f.name, COUNT(b.booking_id) as cnt FROM facility f "
                + "LEFT JOIN booking b ON f.facility_id=b.facility_id "
                + "GROUP BY f.facility_id, f.name";
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put(rs.getString("name"), rs.getInt("cnt"));
            }
        }
        return map;
    }

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setUserId(rs.getInt("user_id"));
        b.setAddress(rs.getString("address"));
        b.setBookingType(rs.getString("booking_type"));
        b.setEmail(rs.getString("email"));
        b.setPhone(rs.getString("phone"));
        b.setFacilityId(rs.getInt("facility_id"));
        b.setStartDate(rs.getDate("start_date").toLocalDate());
        b.setEndDate(rs.getDate("end_date").toLocalDate());
        b.setTotalAmount(rs.getDouble("total_amount"));
        b.setStatus(rs.getString("status"));
        try {
            b.setTotalDays(rs.getInt("total_days"));
        } catch (SQLException e) {
            b.setTotalDays((int) (ChronoUnit.DAYS.between(b.getStartDate(), b.getEndDate()) + 1));
        }
        try {
            b.setSessionType(rs.getString("session_type"));
        } catch (SQLException e) {
            b.setSessionType("FULL_DAY");
        }
        try {
            b.setStartTime(rs.getTime("start_time"));
        } catch (SQLException e) {
            b.setStartTime(null);
        }
        try {
            b.setEndTime(rs.getTime("end_time"));
        } catch (SQLException e) {
            b.setEndTime(null);
        }
        return b;
    }
}
