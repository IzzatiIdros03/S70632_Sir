package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Baca dari environment variable Railway dulu; kalau tiada (contoh: run di NetBeans tempatan), guna default Docker tempatan
    private static final String DB_HOST = getEnvOrDefault("MYSQLHOST", "db");
    private static final String DB_PORT = getEnvOrDefault("MYSQLPORT", "3306");
    private static final String DB_NAME = getEnvOrDefault("MYSQLDATABASE", "mms_db");
    private static final String USER = getEnvOrDefault("MYSQLUSER", "root");
    private static final String PASSWORD = getEnvOrDefault("MYSQLPASSWORD", "admin");

    private static final String URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found", e);
        }
    }
}
