package ecommerce.free;

import ecommerce.free.controller.AccessController;
import ecommerce.free.model.Access;
import ecommerce.free.repository.AccessRepository;
import ecommerce.free.service.AccessService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

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

		accessController.saveAccess(access);
	}
}
