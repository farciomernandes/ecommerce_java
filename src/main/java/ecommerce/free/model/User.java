package ecommerce.free.model;

import jakarta.persistence.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "users")
@SequenceGenerator(name = "seq_users", sequenceName = "seq_users", allocationSize = 1, initialValue = 1)
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_users")
    private Long id;


    @Column(nullable = false)
    private String login;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date actualDatePassword;

    @OneToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "user_access",
            uniqueConstraints = @UniqueConstraint(
                    columnNames = {"users_id", "access_id"}, name = "unique_access_user"
            ),
            joinColumns = @JoinColumn(
                    name = "users_id", referencedColumnName = "id", table= "users",
                    unique = false, foreignKey = @ForeignKey(name = "users_fk", value = ConstraintMode.CONSTRAINT)
            ),
            inverseJoinColumns = @JoinColumn(
                    name = "access_id", unique = false, referencedColumnName = "id", table = "access",
                   foreignKey = @ForeignKey(name = "access_fk", value = ConstraintMode.CONSTRAINT)
            )
    )
    private List<Access> accesses;

    @ManyToOne(targetEntity = People.class)
    @JoinColumn(name = "people_id", nullable = false, foreignKey = @ForeignKey(
            value = ConstraintMode.CONSTRAINT, name = "people_fk"
    ))
    private People people;


    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        /**
         * São os acessos. Roles.
         * ADMIN, FINANCES, CLIENT
         */
        return List.of();
    }

    @Override
    public String getPassword() {
        return this.password;
    }

    @Override
    public String getUsername() {
        return this.login;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
