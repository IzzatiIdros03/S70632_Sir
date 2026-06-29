package dao;

import model.Notification;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public void ensureTableExists() {
        String sql = "CREATE TABLE IF NOT EXISTS notification ("
                + "notif_id INT AUTO_INCREMENT PRIMARY KEY,"
                + "user_id INT NOT NULL,"
                + "type VARCHAR(50) NOT NULL,"
                + "message TEXT NOT NULL,"
                + "is_read TINYINT(1) DEFAULT 0,"
                + "ref_id INT DEFAULT 0,"
                + "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
                + "FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE"
                + ")";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            st.execute(sql);
        } catch (SQLException e) {
            System.err.println("NotificationDAO ensureTableExists error: " + e.getMessage());
        }
    }

    public boolean addNotification(int userId, String type, String message, int refId) {
        ensureTableExists();
        String sql = "INSERT INTO notification (user_id, type, message, ref_id) VALUES (?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.setString(3, message);
            ps.setInt(4, refId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("addNotification error: " + e.getMessage());
            return false;
        }
    }

    public List<Notification> getByUser(int userId) {
        ensureTableExists();
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notification WHERE user_id=? ORDER BY created_at DESC LIMIT 20";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("getByUser error: " + e.getMessage());
        }
        return list;
    }

    public int countUnread(int userId) {
        ensureTableExists();
        String sql = "SELECT COUNT(*) FROM notification WHERE user_id=? AND is_read=0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("countUnread error: " + e.getMessage());
        }
        return 0;
    }

    public void markAllRead(int userId) {
        ensureTableExists();
        String sql = "UPDATE notification SET is_read=1 WHERE user_id=? AND is_read=0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("markAllRead error: " + e.getMessage());
        }
    }

    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotifId(rs.getInt("notif_id"));
        n.setUserId(rs.getInt("user_id"));
        n.setType(rs.getString("type"));
        n.setMessage(rs.getString("message"));
        n.setRead(rs.getBoolean("is_read"));
        n.setRefId(rs.getInt("ref_id"));
        n.setCreatedAt(rs.getTimestamp("created_at"));
        return n;
    }
}