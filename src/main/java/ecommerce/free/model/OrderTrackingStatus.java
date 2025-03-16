package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "order_tracking_status")
@SequenceGenerator(name = "seq_order_tracking_status", sequenceName = "seq_order_tracking_status", allocationSize = 1, initialValue = 1)
public class OrderTrackingStatus implements Serializable {
    // Status_Rastreio
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_order_tracking_status")
    private Long id;

    private String distributionCenter;
    private String city;
    private String state;
    private String status;

    // Venda Ecommerce - ASSOCIAR
    @ManyToOne
    @JoinColumn(name = "store_sale_purchase_id", nullable = false,
            foreignKey = @ForeignKey(value = ConstraintMode.CONSTRAINT, name = "store_sale_purchase_fk"))
    private StoreSalePurchase storeSalePurchase;

    public String getDistributionCenter() {
        return distributionCenter;
    }

    public void setDistributionCenter(String distributionCenter) {
        this.distributionCenter = distributionCenter;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
        OrderTrackingStatus that = (OrderTrackingStatus) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
