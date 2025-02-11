package ecommerce.free.model;

import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;
import java.io.Serializable;

@Entity
@Table(name = "juridical_person")
public class JuridicalPerson extends People implements Serializable {

    private static final long serialVersionUID = 1L;

    private String cnpj;
    private String stateRegistration;
    private String municipalRegistration;
    private String socialReason;
    private String fantasyName;
    private String category;

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public String getStateRegistration() {
        return stateRegistration;
    }

    public void setStateRegistration(String stateRegistration) {
        this.stateRegistration = stateRegistration;
    }

    public String getMunicipalRegistration() {
        return municipalRegistration;
    }

    public void setMunicipalRegistration(String municipalRegistration) {
        this.municipalRegistration = municipalRegistration;
    }

    public String getSocialReason() {
        return socialReason;
    }

    public void setSocialReason(String socialReason) {
        this.socialReason = socialReason;
    }

    public String getFantasyName() {
        return fantasyName;
    }

    public void setFantasyName(String fantasyName) {
        this.fantasyName = fantasyName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
