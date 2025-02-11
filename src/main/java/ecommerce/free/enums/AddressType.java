package ecommerce.free.enums;

public enum AddressType {
    BILLING("Billing"),
    DELIVERY("Delivery");

    private String description;

    private AddressType(String description){
        this.description = description;
    }

    public String getDescription(){
        return this.description;
    }

    @Override
    public String toString() {
        return this.description;
    }
}
