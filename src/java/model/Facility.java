package model;

public class Facility {

    private int facilityId;
    private String name;
    private String type;
    private int capacity;
    private double ratePerDay;      // harga full day
    private double halfDayRate;     // harga half day
    private String status;

    public int getFacilityId() {
        return facilityId;
    }

    public void setFacilityId(int facilityId) {
        this.facilityId = facilityId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public double getRatePerDay() {
        return ratePerDay;
    }

    public void setRatePerDay(double ratePerDay) {
        this.ratePerDay = ratePerDay;
    }

    public double getHalfDayRate() {
        return halfDayRate;
    }

    public void setHalfDayRate(double halfDayRate) {
        this.halfDayRate = halfDayRate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
