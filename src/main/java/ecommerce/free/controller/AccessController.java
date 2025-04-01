package ecommerce.free.controller;

import ecommerce.free.model.Access;
import ecommerce.free.repository.AccessRepository;
import ecommerce.free.service.AccessService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RestController
public class AccessController {

    @Autowired
    private AccessService accessService;

    @Autowired
    private AccessRepository accessRepository;

    @ResponseBody
    @PostMapping(value = "**/save-access")
    public ResponseEntity<Access> saveAccess(@RequestBody Access access) {
        Access accesSaved = accessService.save(access);
        return new ResponseEntity<Access>(accesSaved, HttpStatus.OK);
    }

    @ResponseBody
    @DeleteMapping(value = "**/delete-access")
    public ResponseEntity<?> deleteAccess(@RequestBody Access access) {
        accessRepository.deleteById(access.getId());
        return new ResponseEntity<>(HttpStatus.OK);
    }



}
