package model;

import java.sql.Timestamp;

public class Notification {
    private int notifId;
    private int userId;
    private String type;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;
    private int refId;

    public int getNotifId() { return notifId; }
    public void setNotifId(int notifId) { this.notifId = notifId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getRefId() { return refId; }
    public void setRefId(int refId) { this.refId = refId; }
}