package ecommerce.free;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EntityScan(basePackages = { "ecommerce.free.model" })
@ComponentScan(basePackages = { "ecommerce.*" })
@EnableJpaRepositories(basePackages = { "ecommerce.free.repository" })
@EnableTransactionManagement
public class EcommerceFreeApplication {

	public static void main(String[] args) {
		SpringApplication.run(EcommerceFreeApplication.class, args);
	}

}
