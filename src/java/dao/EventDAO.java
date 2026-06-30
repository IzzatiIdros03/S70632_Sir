package dao;

import model.Event;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    // ===== USER: Ambil event yang dah APPROVED sahaja (senarai awam) =====
    public List<Event> getApprovedEvents() {
        List<Event> list = new ArrayList<>();
        // FIX: guna IS NULL OR != supaya event dengan status NULL tetap dikira
        String sql = "SELECT e.*, u.name as user_name FROM event e "
                + "LEFT JOIN user u ON e.user_id = u.user_id "
                + "WHERE e.request_status = 'APPROVED' "
                + "AND (e.status IS NULL OR e.status != 'COMPLETED') "
                + "ORDER BY e.date ASC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getApprovedEvents error: " + e.getMessage());
        }
        return list;
    }

    // ===== USER: Ambil event yang dibuat oleh user tertentu (semua status) =====
    public List<Event> getMyEvents(int userId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, u.name as user_name FROM event e "
                + "LEFT JOIN user u ON e.user_id = u.user_id "
                + "WHERE e.user_id = ? ORDER BY e.date DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getMyEvents error: " + e.getMessage());
        }
        return list;
    }

    // ===== COORDINATOR: Ambil semua event (semua status) =====
    public List<Event> getAllEvents() {
        List<Event> list = new ArrayList<>();
        // Pending dulu atas, lepas tu ikut tarikh
        String sql = "SELECT e.*, u.name as user_name FROM event e "
                + "LEFT JOIN user u ON e.user_id = u.user_id "
                + "ORDER BY FIELD(e.request_status,'PENDING_APPROVAL','APPROVED','REJECTED'), e.date DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            // fallback kalau FIELD function tak support
            String sql2 = "SELECT e.*, u.name as user_name FROM event e "
                    + "LEFT JOIN user u ON e.user_id = u.user_id ORDER BY e.date DESC";
            try (Connection conn2 = DBConnection.getConnection(); PreparedStatement ps2 = conn2.prepareStatement(sql2); ResultSet rs2 = ps2.executeQuery()) {
                while (rs2.next()) {
                    list.add(mapRow(rs2));
                }
            } catch (SQLException ex) {
                System.out.println("getAllEvents error: " + ex.getMessage());
            }
        }
        return list;
    }

    // ===== Ambil event by ID =====
    public Event getEventById(int eventId) {
        String sql = "SELECT e.*, u.name as user_name FROM event e "
                + "LEFT JOIN user u ON e.user_id = u.user_id "
                + "WHERE e.event_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            System.out.println("getEventById error: " + e.getMessage());
        }
        return null;
    }

    // ===== SEMAK KONFLIK TARIKH: Adakah ada event APPROVED pada tarikh yg sama? =====
    // Return true = ADA konflik (tarikh dah diambil)
    public boolean hasDateConflict(Date date, Time time, int excludeEventId) {
        // Konflik jika ada event APPROVED pada tarikh yang sama
        // (untuk simplify, semak tarikh sahaja — satu tarikh satu slot)
        String sql = "SELECT COUNT(*) FROM event "
                + "WHERE date = ? AND event_id != ? "
                + "AND request_status IN ('APPROVED', 'PENDING_APPROVAL')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, date);
            ps.setInt(2, excludeEventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("hasDateConflict error: " + e.getMessage());
        }
        return false;
    }

    // ===== USER: Tambah permohonan event — status PENDING_APPROVAL =====
    public boolean addEventRequest(Event e) {
        String sql = "INSERT INTO event (user_id, requested_by, name, date, time, location, description, status, request_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'PENDING_APPROVAL')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, e.getUserId());
            ps.setInt(2, e.getUserId()); // requested_by = user yg mohon
            ps.setString(3, e.getName());
            ps.setDate(4, e.getDate());
            if (e.getTime() != null) {
                ps.setTime(5, e.getTime());
            } else {
                ps.setNull(5, Types.TIME);
            }
            ps.setString(6, e.getLocation());
            ps.setString(7, e.getDescription());
            ps.setString(8, "UPCOMING");
            int rows = ps.executeUpdate();
            System.out.println("addEventRequest: " + rows + " row(s) inserted for user_id=" + e.getUserId());
            return rows > 0;
        } catch (SQLException ex) {
            // Cetak error LENGKAP supaya kita tahu punca sebenar
            System.err.println("=========== addEventRequest SQL ERROR ===========");
            System.err.println("Message  : " + ex.getMessage());
            System.err.println("SQLState : " + ex.getSQLState());
            System.err.println("ErrorCode: " + ex.getErrorCode());
            ex.printStackTrace();
            System.err.println("=================================================");
            return false;
        }
    }

    // ===== COORDINATOR: Tambah event terus — auto APPROVED =====
    public boolean addEventByCoordinator(Event e) {
        String sql = "INSERT INTO event (user_id, approved_by, name, date, time, location, description, status, request_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'APPROVED')";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, e.getUserId());
            ps.setInt(2, e.getApprovedBy());
            ps.setString(3, e.getName());
            ps.setDate(4, e.getDate());
            if (e.getTime() != null) {
                ps.setTime(5, e.getTime());
            } else {
                ps.setNull(5, Types.TIME);
            }
            ps.setString(6, e.getLocation());
            ps.setString(7, e.getDescription());
            ps.setString(8, e.getStatus() != null ? e.getStatus() : "UPCOMING");
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("addEventByCoordinator error: " + ex.getMessage());
            return false;
        }
    }

    // ===== Update event (nama, tarikh, masa, lokasi, penerangan, status) =====
    public boolean updateEvent(Event e) {
        boolean updateRequestStatus = e.getRequestStatus() != null;
        String sql = updateRequestStatus
                ? "UPDATE event SET name=?, date=?, time=?, location=?, description=?, status=?, request_status=? WHERE event_id=?"
                : "UPDATE event SET name=?, date=?, time=?, location=?, description=?, status=? WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getName());
            ps.setDate(2, e.getDate());
            if (e.getTime() != null) {
                ps.setTime(3, e.getTime());
            } else {
                ps.setNull(3, Types.TIME);
            }
            ps.setString(4, e.getLocation());
            ps.setString(5, e.getDescription());
            ps.setString(6, e.getStatus() != null ? e.getStatus() : "UPCOMING");
            if (updateRequestStatus) {
                ps.setString(7, e.getRequestStatus());
                ps.setInt(8, e.getEventId());
            } else {
                ps.setInt(7, e.getEventId());
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("updateEvent error: " + ex.getMessage());
            return false;
        }
    }

    // ===== Padam event =====
    public boolean deleteEvent(int eventId) {
        String sql = "DELETE FROM event WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteEvent error: " + e.getMessage());
            return false;
        }
    }

    // ===== COORDINATOR: Lulus atau Tolak permohonan =====
    public boolean approveReject(int eventId, String decision, int coordinatorId) {
        // decision: "APPROVED" atau "REJECTED"
        String sql = "UPDATE event SET request_status=?, approved_by=? WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, decision);
            ps.setInt(2, coordinatorId);
            ps.setInt(3, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("approveReject error: " + e.getMessage());
            return false;
        }
    }

    // ===== Stats =====
    // ===== Auto-delete aktiviti COMPLETED =====
    public int deleteCompleted() {
        String sql = "DELETE FROM event WHERE status = 'COMPLETED'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("deleteCompleted error: " + e.getMessage());
            return 0;
        }
    }

    // ===== Ambil semua event APPROVED untuk kalendar (date + name + status) =====
    public List<Event> getEventsForCalendar() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, u.name as user_name FROM event e "
                + "LEFT JOIN user u ON e.user_id = u.user_id "
                + "WHERE e.request_status = 'APPROVED' ORDER BY e.date ASC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("getEventsForCalendar error: " + e.getMessage());
        }
        return list;
    }

    public int countUpcoming() {
        return countByCondition("request_status = 'APPROVED' AND date >= CURDATE()");
    }

    public int countPending() {
        return countByCondition("request_status = 'PENDING_APPROVAL'");
    }

    public int countApproved() {
        return countByCondition("request_status = 'APPROVED'");
    }

    private int countByCondition(String cond) {
        try (Connection conn = DBConnection.getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM event WHERE " + cond)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("count error: " + e.getMessage());
        }
        return 0;
    }

    // ===== Helper: map ResultSet ke Event =====
    private Event mapRow(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setEventId(rs.getInt("event_id"));
        e.setUserId(rs.getInt("user_id"));
        e.setName(rs.getString("name"));
        e.setDate(rs.getDate("date"));
        e.setTime(rs.getTime("time"));
        e.setLocation(rs.getString("location"));
        e.setDescription(rs.getString("description"));
        e.setStatus(rs.getString("status"));
        // column baru guna try-catch supaya tak crash kalau column belum ada
        try {
            e.setRequestStatus(rs.getString("request_status"));
        } catch (SQLException ex) {
            e.setRequestStatus("APPROVED");
        }
        try {
            e.setApprovedBy(rs.getInt("approved_by"));
        } catch (SQLException ex) {
            e.setApprovedBy(0);
        }
        try {
            e.setUserName(rs.getString("user_name"));
        } catch (SQLException ex) {
            e.setUserName("");
        }
        return e;
    }
}
