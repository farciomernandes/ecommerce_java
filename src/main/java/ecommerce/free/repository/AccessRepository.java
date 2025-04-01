package ecommerce.free.repository;

import ecommerce.free.model.Access;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public interface AccessRepository extends JpaRepository<Access, Long> {

    @Query("SELECT a FROM Access a WHERE UPPER(TRIM(a.description)) LIKE %?1%")
    List<Access> findAccessByDescription(String description);
}
