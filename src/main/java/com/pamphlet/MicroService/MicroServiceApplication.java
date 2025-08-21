package com.pamphlet.MicroService;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class MicroServiceApplication {

    @RequestMapping("/")
    public String home() {
        String className = this.getClass().getSimpleName();
        return className + " is running";
    }

	public static void main(String[] args) {
		SpringApplication.run(MicroServiceApplication.class, args);
	}

}
