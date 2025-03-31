package ecommerce.free.controller;

import ecommerce.free.model.Access;
import ecommerce.free.service.AccessService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AccessController {

    @Autowired
    private AccessService accessService;

    public Access saveAccess(Access access) {
        return accessService.save((access));
    }


}
