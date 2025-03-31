package ecommerce.free.service;

import ecommerce.free.model.Access;
import ecommerce.free.repository.AccessRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class AccessService {

    @Autowired
    private AccessRepository accessRepository;

    public Access save(Access access) {
        return accessRepository.save(access);
    }
}
