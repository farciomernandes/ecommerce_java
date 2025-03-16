package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "store_sale_item")
@SequenceGenerator(name = "seq_store_sale_purchase", sequenceName = "seq_store_sale_purchase", allocationSize = 1, initialValue = 1)
public class StoreSaleItem implements Serializable {
    // ItemVendaLoja
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_store_sale_purchase")
    private Long id;


    @Column(nullable = false)
    private Double quantity;

    @ManyToOne(targetEntity = Product.class)
    @JoinColumn(name = "product_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "product_fk"
    ))
    private Product product;

    @ManyToOne(targetEntity = StoreSalePurchase.class)
    @JoinColumn(name = "store_sale_purchase_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "store_sale_purchase_fk"
    ))
    private StoreSalePurchase storeSalePurchase;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Double getQuantity() {
        return quantity;
    }

    public void setQuantity(Double quantity) {
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public StoreSalePurchase getStoreSalePurchase() {
        return storeSalePurchase;
    }

    public void setStoreSalePurchase(StoreSalePurchase storeSalePurchase) {
        this.storeSalePurchase = storeSalePurchase;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        StoreSaleItem that = (StoreSaleItem) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
