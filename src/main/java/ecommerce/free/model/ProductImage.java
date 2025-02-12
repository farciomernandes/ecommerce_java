package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "product_image")
@SequenceGenerator(name = "seq_product_image", sequenceName = "seq_product_image", allocationSize = 1, initialValue = 1)
public class ProductImage implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_product_image")
    private Long id;

    @Column(columnDefinition = "text")
    private String originalImage;

    @Column(columnDefinition = "text")
    private String thumbnailImage;

    @ManyToOne
    @JoinColumn(
            name = "product_id", nullable = false, foreignKey = @ForeignKey(
                        value = ConstraintMode.CONSTRAINT, name = "product_fk"
                    )
    )
    private Product product;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        ProductImage that = (ProductImage) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
