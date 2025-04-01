package ecommerce.free;

import ecommerce.free.controller.AccessController;
import ecommerce.free.model.Access;
import ecommerce.free.repository.AccessRepository;
import ecommerce.free.service.AccessService;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest(classes = EcommerceFreeApplication.class)
public class EcommerceFreeApplicationTests {

	@Autowired
	private AccessService accessService;

	@Autowired
	private AccessRepository accessRepository;

	@Autowired
	private AccessController accessController;

	@Test
	public void testServiceCreateAccess() {
		Access access = new Access();
		access.setDescription("ROLE_ADMIN");

		accessRepository.save(access);
	}

	@Test
	public void testControllerCreateAccess() {
		Access access = new Access();
		access.setDescription("ROLE_CUSTOMER");

		access = accessController.saveAccess(access).getBody();

		Assertions.assertEquals(true, access.getId() > 0);
		Assertions.assertEquals("ROLE_CUSTOMER", access.getDescription());

		Access access2 = accessRepository.findById(access.getId()).get();
		Assertions.assertEquals(access.getId(), access2.getId());

		accessRepository.deleteById(access2.getId());
		accessRepository.flush(); // Rodar esse sql de delete no banco de dados.

		Access access3 = accessRepository.findById(access2.getId()).orElse(null);

		Assertions.assertNull(access3);

		access = new Access();

		access.setDescription("ROLE_PEOPLE");

		access = accessController.saveAccess(access).getBody();

		List<Access> accesses = accessRepository.findAccessByDescription("PEOPLE".trim().toUpperCase());

		Assertions.assertEquals(1, accesses.size());
		accessRepository.deleteById(access.getId());
	}
}
