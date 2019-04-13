package com.techelevator.model.user;

import javax.validation.constraints.AssertTrue;
import javax.validation.constraints.Size;

import org.hibernate.validator.constraints.NotBlank;

/**
 * User is an object that holds a First Name, Last Name, Username, Role, User Id,
 * Password, Confirmation Password, and if Password Matching boolean for a User
 */
public class User {
	protected long id;
	@Size(min = 2, max = 25)
	@NotBlank(message="Username is required")
	protected String username;
	@Size(min = 2, max = 10)
	@NotBlank(message="Role is required")
    private String role;
	@Size(min = 2, max = 256)
    @NotBlank(message="Password is required")
	protected String password;
	@Size(min = 2, max = 256)
	protected String confirmPassword;
	@Size(min = 2, max = 25)
	@NotBlank(message="First Name is required")
    private String firstName;
	@Size(min = 2, max = 25)
	@NotBlank(message="Last Name is required")
	private String lastName;
	@Size(min = 2, max = 30)
	private String city;
	@Size(min = 2, max = 2)
	private String state;

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
	 * @return Name of User
	 */
	public String getName() {
		return firstName + " " + lastName;
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
        this.username = username.toUpperCase();
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
    
    /**
	 * @return the City of the Trainer
	 */
	public String getCity() {
		return city;
	}

	/**
	 * @param the City of the Trainer to set
	 */
	public void setCity(String city) {
		this.city = city;
	}

	/**
	 * @return the State of the Trainer
	 */
	public String getState() {
		return state;
	}

	/**
	 * @param the State of the Trainer to set
	 */
	public void setState(String state) {
		this.state = state;
	}
}