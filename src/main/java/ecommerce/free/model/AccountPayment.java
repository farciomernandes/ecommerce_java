package ecommerce.free.model;

import ecommerce.free.enums.PaymentAccountStatus;
import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "account_payment")
@SequenceGenerator(name = "seq_account_payment", sequenceName = "seq_account_payment", allocationSize = 1, initialValue = 1)
public class AccountPayment implements Serializable {
    // ContaPagar
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_account_payment")
    private Long id;

    private String description;
    private BigDecimal totalValue;

    @Temporal(TemporalType.DATE)
    private Date paymentDate;

    @Temporal(TemporalType.DATE)
    private Date dueDate;

    @Enumerated(EnumType.STRING)
    private PaymentAccountStatus status;

    @ManyToOne(targetEntity = People.class)
    @JoinColumn(name = "owner_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "owner_fk"
    ))
    private People owner;

    @ManyToOne(targetEntity = People.class)
    @JoinColumn(name = "supplier_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "supplier_fk"
    ))
    private People supplier; //Fornecedor

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(BigDecimal totalValue) {
        this.totalValue = totalValue;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public PaymentAccountStatus getStatus() {
        return status;
    }

    public void setStatus(PaymentAccountStatus status) {
        this.status = status;
    }

    public People getOwner() {
        return owner;
    }

    public void setOwner(People owner) {
        this.owner = owner;
    }

    public People getSupplier() {
        return supplier;
    }

    public void setSupplier(People supplier) {
        this.supplier = supplier;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        AccountPayment accountPayment = (AccountPayment) o;
        return Objects.equals(id, accountPayment.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
