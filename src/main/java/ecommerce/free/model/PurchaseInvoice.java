package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "purchase_invoice")
@SequenceGenerator(name = "seq_purchase_invoice", sequenceName = "seq_purchase_invoice", allocationSize = 1, initialValue = 1)
public class PurchaseInvoice implements Serializable {
    // NotaFiscalCompra
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_purchase_invoice")
    private Long id;


    @Column(nullable = false)
    private String invoiceNumber;

    @Column(nullable = false)
    private String invoiceSeries;

    private String descriptionNote;

    @Column(nullable = false)
    private BigDecimal totalAmount;

    private BigDecimal discountAmount;

    @Column(nullable = false)
    private BigDecimal icmsAmount;

    @Temporal(TemporalType.DATE)
    @Column(nullable = false)
    private Date purchaseDate;

    @ManyToOne(targetEntity = People.class)
    @JoinColumn(name = "people_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "people_fk"
    ))
    private People owner;

    @ManyToOne(targetEntity = People.class)
    @JoinColumn(name = "account_payment_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "account_payment_fk"
    ))
    private AccountPayment accountPayment;

    public People getOwner() {
        return owner;
    }

    public void setOwner(People owner) {
        this.owner = owner;
    }

    public AccountPayment getAccountPayment() {
        return accountPayment;
    }

    public void setAccountPayment(AccountPayment accountPayment) {
        this.accountPayment = accountPayment;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public String getInvoiceSeries() {
        return invoiceSeries;
    }

    public void setInvoiceSeries(String invoiceSeries) {
        this.invoiceSeries = invoiceSeries;
    }

    public String getDescriptionNote() {
        return descriptionNote;
    }

    public void setDescriptionNote(String descriptionNote) {
        this.descriptionNote = descriptionNote;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
    }

    public BigDecimal getIcmsAmount() {
        return icmsAmount;
    }

    public void setIcmsAmount(BigDecimal icmsAmount) {
        this.icmsAmount = icmsAmount;
    }

    public Date getPurchaseDate() {
        return purchaseDate;
    }

    public void setPurchaseDate(Date purchaseDate) {
        this.purchaseDate = purchaseDate;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        PurchaseInvoice that = (PurchaseInvoice) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
