package ecommerce.free.security.config;

import org.springframework.http.HttpMethod;
import java.util.Arrays;
import java.util.List;

public class PublicRoutesConfig {

    public record PublicRoute(String path, HttpMethod method) {}

    public static List<PublicRoute> getPublicRoutes() {
        return Arrays.asList(
                new PublicRoute("/save-access", HttpMethod.POST),
                new PublicRoute("/delete-access", HttpMethod.DELETE),
                new PublicRoute("/login", HttpMethod.POST),
                new PublicRoute("/public/**", HttpMethod.GET)
        );
    }
}