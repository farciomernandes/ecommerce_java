package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "product_review")
@SequenceGenerator(name = "seq_product_review", sequenceName = "seq_product_review", allocationSize = 1, initialValue = 1)
public class ProductReview implements Serializable {
    // AvaliacaoProduto
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_product_review")
    private Long id;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private Integer rating;

    @ManyToOne(targetEntity = People.class)
    @JoinColumn(name = "people_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "people_fk"
    ))
    private People people;

    @ManyToOne(targetEntity = Product.class)
    @JoinColumn(name = "product_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "product_fk"
    ))
    private Product product;

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

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public People getPeople() {
        return people;
    }

    public void setPeople(People people) {
        this.people = people;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        ProductReview that = (ProductReview) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
