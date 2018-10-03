package com.example.workshop.hello;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

//    private FeatureManager featureManager;
//
//    public HelloController(FeatureManager featureManager) {
//        this.featureManager = featureManager;
//    }

    @RequestMapping("/hello")
    public String greetingPhilips() {

        if(FeatureToggles.FEATURE_ONE.isActive()) {
            return "Hello Philips";
        }
        return "Hello Philips Innovation Campus";
    }
}
