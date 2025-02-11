package ecommerce.free.enums;

public enum PaymentAccountStatus {
    PENDING_PAYMENT("Pending Payment"),
    OVERDUE("Overdue"),
    OPEN("Open"),
    RENEGOTIATED("Renegotiated"),
    PAID("Paid");

    private String description;

    private PaymentAccountStatus(String description) {
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
