package ecommerce.free.enums;

public enum AccountReceivableStatus {
    PENDING_PAYMENT("Pending Payment"),
    OVERDUE("Overdue"),
    OPEN("Open"),
    PAID("Paid");

    private String description;

    private AccountReceivableStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return this.description;
    }

    @Override
    public String toString() {
        return this.description;
    }
}
