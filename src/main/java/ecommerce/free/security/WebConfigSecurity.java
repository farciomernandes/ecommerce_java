package ecommerce.free.security;

import ecommerce.free.security.config.PublicRoutesConfig;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true, securedEnabled = true)
public class WebConfigSecurity {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        List<PublicRoutesConfig.PublicRoute> publicRoutes = PublicRoutesConfig.getPublicRoutes();

        http
                .authorizeHttpRequests(auth -> {
                    // Configura rotas públicas
                    publicRoutes.forEach(route ->
                            auth.requestMatchers(
                                    new AntPathRequestMatcher(route.path(), route.method().name())
                            ).permitAll()
                    );

                    // Todas as outras requisições exigem autenticação
                    auth.anyRequest().authenticated();
                })
                .formLogin(form -> form
                        .loginPage("/login")
                        .permitAll()
                )
                .logout(logout -> logout
                        .permitAll()
                )
                .csrf(csrf -> {
                    // Desabilita CSRF para rotas públicas que usam POST/PUT/PATCH/DELETE
                    publicRoutes.stream()
                            .filter(route -> !route.method().matches("GET|HEAD|OPTIONS"))
                            .forEach(route ->
                                    csrf.ignoringRequestMatchers(
                                            new AntPathRequestMatcher(route.path(), route.method().name())
                                    )
                            );
                });

        return http.build();
    }
}