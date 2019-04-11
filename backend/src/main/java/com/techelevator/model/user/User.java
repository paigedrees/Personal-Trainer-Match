package com.techelevator.model.user;

import javax.validation.constraints.AssertTrue;
import org.hibernate.validator.constraints.NotBlank;

/**
 * User is an object that holds a First Name, Last Name, Username, Role, User Id,
 * Password, Confirmation Password, and if Password Matching boolean for a User
 */
public class User {
	
	@NotBlank(message="Username is required")
    private String username;
	@NotBlank(message="First Name is required")
    private String firstName;
	@NotBlank(message="Last Name is required")
    private String lastName;
	@NotBlank(message="Role is required")
    private String role;
    private long id;
    @NotBlank(message="Password is required")
    private String password;
    private String confirmPassword;
    private boolean passwordMatching;
    
    /**
     * @return True if Password Matches Confirm Password
     */
    @AssertTrue(message = "Passwords must match")
    public boolean isPasswordMatching() {
        if (password != null) {
            return password.equals(confirmPassword);
        }
        return true;
    }
    
    /**
	 * @return First Name of User
	 */
    public String getFirstName() {
		return firstName;
	}

    /**
     * @param First Name to be set for User
     */
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	/**
	 * @return Last Name of User
	 */
	public String getLastName() {
		return lastName;
	}

	/**
	 * @param Last Name to be set for User
	 */
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

    /**
     * @return Password of User
     */
    public String getPassword() {
        return password;
    }

    /**
     * @return Confirmation Password of User
     */
    public String getConfirmPassword() {
        return confirmPassword;
    }

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @return the id
     */
    public long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(long id) {
        this.id = id;
    }

    /**
     * @return the role
     */
    public String getRole() {
        return role;
    }

    /**
     * @param role the role to set
     */
    public void setRole(String role) {
        this.role = role;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @param password to set for the User
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @param confirmation password to set for the User
     */
    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
}