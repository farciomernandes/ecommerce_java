package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Objects;

@Entity
@Table(name = "product")
@SequenceGenerator(name = "seq_product", sequenceName = "seq_product", allocationSize = 1, initialValue = 1)
public class Product implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_product")
    private Long id;

    private String unitType;
    private String name;

    @Column(columnDefinition = "text", length = 2000)
    private String description;

    // Nota Item Produto - ASSOCIAR

    private Double weight;
    private Double width;
    private Double height;
    private Double depth;
    private BigDecimal salePrice = BigDecimal.ZERO;
    private Integer stock = 0;
    private Integer qtdStockAlert = 0;
    private String linkYoutube;
    private Boolean alertQtdStock = Boolean.FALSE;
    private Integer qtdClick = 0;
    private Boolean activated = Boolean.TRUE;

    public Boolean getActivated() {
        return activated;
    }

    public void setActivated(Boolean activated) {
        this.activated = activated;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUnitType() {
        return unitType;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    public Double getWidth() {
        return width;
    }

    public void setWidth(Double width) {
        this.width = width;
    }

    public Double getHeight() {
        return height;
    }

    public void setHeight(Double height) {
        this.height = height;
    }

    public Double getDepth() {
        return depth;
    }

    public void setDepth(Double depth) {
        this.depth = depth;
    }

    public BigDecimal getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(BigDecimal salePrice) {
        this.salePrice = salePrice;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public Integer getQtdStockAlert() {
        return qtdStockAlert;
    }

    public void setQtdStockAlert(Integer qtdStockAlert) {
        this.qtdStockAlert = qtdStockAlert;
    }

    public String getLinkYoutube() {
        return linkYoutube;
    }

    public void setLinkYoutube(String linkYoutube) {
        this.linkYoutube = linkYoutube;
    }

    public Boolean getAlertQtdStock() {
        return alertQtdStock;
    }

    public void setAlertQtdStock(Boolean alertQtdStock) {
        this.alertQtdStock = alertQtdStock;
    }

    public Integer getQtdClick() {
        return qtdClick;
    }

    public void setQtdClick(Integer qtdClick) {
        this.qtdClick = qtdClick;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Product product = (Product) o;
        return Objects.equals(id, product.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
