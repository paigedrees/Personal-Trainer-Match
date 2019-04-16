package com.techelevator.model.user;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Trainer {
	@MapToDB("user_id")
	private Integer trainerID;
	
	@MapToDB
	@Size(min = 5, max = 25)
	private String username;
	
	@MapToDB("first_name")
	@Size(min = 0, max = 25)
	private String firstName;
	
	@MapToDB("last_name")
	@Size(min = 0, max = 25)
	private String lastName;
	
	@MapToDB
	@Size(min = 1, max = 30)
	private String city;
	
	@MapToDB
	@Size(min = 2, max = 2)
	private String state;

	@MapToDB("is_public")
	@NotNull(message="isPublic is required")
	private Boolean isPublic;

	@MapToDB("hourly_rate")
	private Integer hourlyRate;
	
	@MapToDB
	private Integer rating;
	
	@MapToDB
	private String philosophy;
	
	@MapToDB
	private String biography;

	@MapToDB("certifications_pickle")
	private String certificationsPickle;
	
	private ArrayList<String> certifications = new ArrayList<String>();
	
	private ObjectMapper jsonMapper = new ObjectMapper();

	public int getTrainerID() {
		return trainerID;
	}

	public void setTrainerID(int trainerID) {
		this.trainerID = trainerID;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public boolean isPublic() {
		return isPublic;
	}

	public void setPublic(boolean isPublic) {
		this.isPublic = isPublic;
	}

	public int getHourlyRate() {
		return hourlyRate;
	}

	public void setHourlyRate(int hourlyRate) {
		this.hourlyRate = hourlyRate;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getPhilosophy() {
		return philosophy;
	}

	public void setPhilosophy(String philosophy) {
		this.philosophy = philosophy;
	}

	public String getBiography() {
		return biography;
	}

	public void setBiography(String biography) {
		this.biography = biography;
	}

	public Boolean getIsPublic() {
		return isPublic;
	}

	public void setIsPublic(Boolean isPublic) {
		this.isPublic = isPublic;
	}

	public void setTrainerID(Integer trainerID) {
		this.trainerID = trainerID;
	}

	public void setHourlyRate(Integer hourlyRate) {
		this.hourlyRate = hourlyRate;
	}

	public void setRating(Integer rating) {
		this.rating = rating;
	}

	
	public ArrayList<String> getCertifications() {
		return certifications;
	}

	public void setCertifications(ArrayList<String> certifications) {
		this.certifications = certifications;
		
	    final ByteArrayOutputStream out = new ByteArrayOutputStream();
	    try {
			jsonMapper.writeValue(out, certifications);
		} catch (Exception e) {
			e.printStackTrace();
		}
	    this.certificationsPickle = out.toString();
	}

	public String getCertificationsPickle() {
		return certificationsPickle;
	}

	public void setCertificationsPickle(String certificationsPickle) {
		this.certificationsPickle = certificationsPickle;
		try {
			this.certifications = jsonMapper.readValue(certificationsPickle, new TypeReference<List<String>>(){});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}


