package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "store_sale_purchase")
@SequenceGenerator(name = "seq_store_sale_purchase", sequenceName = "seq_store_sale_purchase", allocationSize = 1, initialValue = 1)
public class StoreSalePurchase implements Serializable {
    // VendaCompraLojaVirtual
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_store_sale_purchase")
    private Long id;

    @ManyToOne(targetEntity = People.class)
    @JoinColumn(name = "people_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "people_fk"
    ))
    private People customer;

    @ManyToOne(targetEntity = Address.class)
    @JoinColumn(name = "address_delivery_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "address_delivery_fk"
    ))
    private Address deliveryAddress;


    @ManyToOne(targetEntity = Address.class)
    @JoinColumn(name = "billing_address_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "billing_address_fk"
    ))
    private Address billingAddress;


    @Column(nullable = false)
    private BigDecimal totalValue;
    private BigDecimal discountValue;

    @ManyToOne(targetEntity = PaymentMethod.class)
    @JoinColumn(name = "payment_method_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "payment_method_fk"
    ))
    private PaymentMethod paymentMethod;

    @OneToOne
    @JoinColumn(name = "sales_invoice_id", nullable = false,
    foreignKey = @ForeignKey(value = ConstraintMode.CONSTRAINT, name = "sales_invoice_fk"))
    private SalesInvoice salesInvoice; // Nota Fiscal

    @ManyToOne(targetEntity = CouponDiscount.class)
    @JoinColumn(name = "coupon_discount_id", foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "coupon_discount_fk"
    ))
    private CouponDiscount couponDiscount;

    @Column(nullable = false)
    private BigDecimal shippingValue;

    @Column(nullable = false)
    private Integer receiveDay;

    @Temporal(TemporalType.DATE)
    private Date saleDate;

    @Temporal(TemporalType.DATE)
    private Date deliveryDate;

    public BigDecimal getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(BigDecimal totalValue) {
        this.totalValue = totalValue;
    }

    public BigDecimal getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(BigDecimal discountValue) {
        this.discountValue = discountValue;
    }

    public PaymentMethod getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(PaymentMethod paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public SalesInvoice getSalesInvoice() {
        return salesInvoice;
    }

    public void setSalesInvoice(SalesInvoice salesInvoice) {
        this.salesInvoice = salesInvoice;
    }

    public CouponDiscount getCouponDiscount() {
        return couponDiscount;
    }

    public void setCouponDiscount(CouponDiscount couponDiscount) {
        this.couponDiscount = couponDiscount;
    }

    public BigDecimal getShippingValue() {
        return shippingValue;
    }

    public void setShippingValue(BigDecimal shippingValue) {
        this.shippingValue = shippingValue;
    }

    public Integer getReceiveDay() {
        return receiveDay;
    }

    public void setReceiveDay(Integer receiveDay) {
        this.receiveDay = receiveDay;
    }

    public Date getSaleDate() {
        return saleDate;
    }

    public void setSaleDate(Date saleDate) {
        this.saleDate = saleDate;
    }

    public Date getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
    }

    public People getCustomer() {
        return customer;
    }

    public void setCustomer(People customer) {
        this.customer = customer;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Address getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(Address deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public Address getBillingAddress() {
        return billingAddress;
    }

    public void setBillingAddress(Address billingAddress) {
        this.billingAddress = billingAddress;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        StoreSalePurchase that = (StoreSalePurchase) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
