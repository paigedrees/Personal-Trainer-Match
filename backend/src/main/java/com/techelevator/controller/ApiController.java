package com.techelevator.controller;

import com.techelevator.authentication.AuthProvider;
import com.techelevator.authentication.UnauthorizedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * ApiController
 */
@RestController
@RequestMapping("/api")
public class ApiController {

    @Autowired
    private AuthProvider authProvider;

    @GetMapping
    public String authorizedOnly() throws UnauthorizedException {
        /*
        You can lock down which roles are allowed by checking
        if the current user has a role.

        In this example, if the user does not have the admin role
        we send back an unauthorized error.
        */
        if( ! authProvider.userHasRole(new String[] {"trainer", "client"})) {
            throw new UnauthorizedException();
        }
        return "Success";
    }
}