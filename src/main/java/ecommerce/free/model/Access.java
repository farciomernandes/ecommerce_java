package ecommerce.free.model;

import jakarta.persistence.*;
import org.springframework.security.core.GrantedAuthority;

import java.util.Objects;

@Entity
@Table(name = "access")
@SequenceGenerator(name = "seq_access", sequenceName = "seq_access", allocationSize = 1, initialValue = 1)
public class Access implements GrantedAuthority {
    // Roles
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_access")
    private Long id;

    @Column(nullable = false)
    private String description;

    @Override
    public String getAuthority() {
        return this.description;
    }

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

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Access access = (Access) o;
        return Objects.equals(id, access.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
