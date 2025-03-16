package ecommerce.free.model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "sales_invoice")
@SequenceGenerator(name = "seq_sales_invoice", sequenceName = "seq_sales_invoice", allocationSize = 1, initialValue = 1)
public class SalesInvoice implements Serializable {
    // NotaFiscalVenda
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_sales_invoice")
    private Long id;

    @Column(nullable = false)
    private String number;

    @Column(nullable = false)
    private String series;

    @Column(nullable = false)
    private String type;

    @Column(columnDefinition = "text", nullable = false)
    private String xml;

    @Column(columnDefinition = "text",  nullable = false)
    private String pdf;

    @OneToOne
    @JoinColumn(name = "store_sale_purchase_id", nullable = false,
    foreignKey = @ForeignKey(value = ConstraintMode.CONSTRAINT, name = "store_sale_purchase_fk"))
    private StoreSalePurchase storeSalePurchase;

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getSeries() {
        return series;
    }

    public void setSeries(String series) {
        this.series = series;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getXml() {
        return xml;
    }

    public void setXml(String xml) {
        this.xml = xml;
    }

    public String getPdf() {
        return pdf;
    }

    public void setPdf(String pdf) {
        this.pdf = pdf;
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
        SalesInvoice that = (SalesInvoice) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
