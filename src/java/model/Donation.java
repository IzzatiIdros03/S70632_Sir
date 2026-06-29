package model;

import java.math.BigDecimal;
import java.sql.Date;

// Model untuk table donation dalam database
public class Donation {

    private int donationId;
    private int userId;
    private String donorName;
    private BigDecimal amount;
    private String donationType;
    private String paymentMethod;
    private Date date; // Memetakan lajur 'date' di database
    private String notes;
    private String status; // Ditambah untuk menyokong status PENDING/SUCCESS dari ToyyibPay

    // Constructor kosong
    public Donation() {
    }

    // ===== ALIAS GETTER & SETTER UNTUK KESELARASAN CONTROLLER =====
    // Ditambah supaya DonationController yang panggil .getDonationDate() / .setDonationDate() tidak error
    public Date getDonationDate() {
        return date;
    }

    public void setDonationDate(Date donationDate) {
        this.date = donationDate;
    }

    // ===== GETTER DAN SETTER ASAL =====
    public int getDonationId() {
        return donationId;
    }

    public void setDonationId(int donationId) {
        this.donationId = donationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getDonorName() {
        return donorName;
    }

    public void setDonorName(String donorName) {
        this.donorName = donorName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getDonationType() {
        return donationType;
    }

    public void setDonationType(String donationType) {
        this.donationType = donationType;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // ===== GETTER & SETTER BARU UNTUK STATUS =====
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
