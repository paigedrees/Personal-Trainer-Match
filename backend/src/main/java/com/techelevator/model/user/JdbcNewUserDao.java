package com.techelevator.model.user;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;
import org.bouncycastle.util.encoders.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;
import com.techelevator.authentication.PasswordHasher;
import com.techelevator.model.user.ClientList;

/**
 * 
 */
@Component
public class JdbcNewUserDao implements UserDao{
	
	private JdbcTemplate jdbcTemplate;
    private PasswordHasher passwordHasher;

    /**
     * Create a new user dao with the supplied data source and the password hasher
     * that will salt and hash all the passwords for users.
     *
     * @param dataSource an SQL data source
     * @param passwordHasher an object to salt and hash passwords
     */
    @Autowired
    public JdbcNewUserDao(DataSource dataSource, PasswordHasher passwordHasher) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.passwordHasher = passwordHasher;
    }

    /**
     * Save a new user to the database. The password that is passed in will be
     * salted and hashed before being saved. The original password is never
     * stored in the system. We will never have any idea what it is!
     *
     * @param userName the user name to give the new user
     * @param password the user's password
     * @param role the user's role
     * @return the new user
     */
    @Override
    public User saveUser(String username, String firstName, String lastName, String password, String role) {
        byte[] salt = passwordHasher.generateRandomSalt();
        String hashedPassword = passwordHasher.computeHash(password, salt);
        String saltString = new String(Base64.encode(salt));
        long newId = jdbcTemplate.queryForObject("INSERT INTO users(username, first_name, last_name, password, salt, role) VALUES (?, ?, ?, ?, ?, ?) "
        		+ "RETURNING user_id", Long.class, username,  lastName, hashedPassword, saltString, role);
        if (role.equals("Trainer")) {
        	jdbcTemplate.update("INSERT INTO trainer(user_id) VALUES (?)", newId);
        }
        return createUser(newId, username, firstName, lastName, password, role);
    }
    

    /**
	 * @param User object of the user to change password for
     * @param newPassword the new password
	 */
    @Override
    public void changePassword(User user, String newPassword) {
        byte[] salt = passwordHasher.generateRandomSalt();
        String hashedPassword = passwordHasher.computeHash(newPassword, salt);
        String saltString = new String(Base64.encode(salt));

        jdbcTemplate.update("UPDATE users SET password=?, salt=? WHERE user_id=?",
                hashedPassword, saltString, user.getId());
    }

    /**
     * Look for a user with the given username and password. Since we don't
     * know the password, we will have to get the user's salt from the database,
     * hash the password, and compare that against the hash in the database.
     *
     * @param userName the user name of the user we are checking
     * @param password the password of the user we are checking
     * @return true if the user is found and their password matches
     */
    @Override
    public User getValidUserWithPassword(String userName, String password) {
        String sqlSearchForUser = "SELECT * FROM users WHERE username = ?";

        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSearchForUser, userName.toUpperCase());
        if (results.next()) {
            String storedSalt = results.getString("salt");
            String storedPassword = results.getString("password");
            String hashedPassword = passwordHasher.computeHash(password, Base64.decode(storedSalt));
            if(storedPassword.equals(hashedPassword)) {
                return createUser(results);
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    private User createUser(SqlRowSet results) {
    	switch (results.getString("role")) {
    	case "Trainer":
    		return createTrainer(results);
    	default:
    		return createClient(results);
    	}
    }
    
    private User createUser(Long id, String username, String firstName, String lastName, String password, String role) {
    	User user = new Trainer();
    	user.setId(id);
    	user.setUsername(username);
    	user.setFirstName(firstName);
    	user.setLastName(lastName);
    	user.setRole(role);
    	return user;
    }
    
    private Trainer createTrainer(SqlRowSet results) {
    	Trainer trainer = new Trainer();
    	trainer.setId(results.getLong("user_id"));
    	trainer.setUsername(results.getString("username"));
    	trainer.setFirstName(results.getString("first_mame"));
    	trainer.setLastName(results.getString("last_name"));
    	trainer.setRole(results.getString("role"));
    	trainer.setHourlyRate(results.getInt("rate_per_hour"));
    	trainer.setRating(results.getDouble("rating"));
    	trainer.setPhilosophy(results.getString("philosophy"));
    	trainer.setBioInfo(results.getString("bio"));
    	trainer.setCertifications(results.getObject("certifications", String[].class));
    	trainer.setCity(results.getString("city"));
    	trainer.setState(results.getString("state"));
    	trainer.setPublic(results.getBoolean("is_public"));
    	return trainer;
    }
    
    private Client createClient(SqlRowSet results) {
    	Client client = new Client();
    	client.setId(results.getLong("user_id"));
    	client.setUsername(results.getString("username"));
    	client.setFirstName(results.getString("first_mame"));
    	client.setLastName(results.getString("last_name"));
    	client.setRole(results.getString("role"));
    	client.setCity(results.getString("city"));
    	client.setState(results.getString("state"));
    	return client;
    }
    
    private String getRole(String username) {
    	String sqlSelectUsersRole = "SELECT role FROM users WHERE username = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUsersRole, username);
        if(results.next()) {
            return results.getString("role");
        } else {
            return null;
        }
    }
    private String getRole(long id) {
    	String sqlSelectUsersRole = "SELECT role FROM users WHERE user_id = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUsersRole, id);
        if(results.next()) {
            return results.getString("role");
        } else {
            return null;
        }
    }

    /**
     * @param username the user name of the user requested
     * @return the User requested
     */
    @Override
    public User getUserByUsername(String username) {
    	String role = getRole(username).toLowerCase();
    	String sqlSelectUserByUsername = "SELECT * FROM " + role + " WHERE username = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUserByUsername, username);
        if(results.next()) {
            return createUser(results);
        } else {
            return null;
        }
    }

    /**
     * @param id the id of the user requested
     * @return the User requested
     */
	@Override
	public User getUserById(Long id) {
		String role = getRole(id).toLowerCase();
    	String sqlSelectUserById = "SELECT * FROM " + role + " WHERE user_id = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUserById, id);
        if(results.next()) {
            return createUser(results);
        } else {
            return null;
        }
	}
	
	@Override
	public Trainer getTrainerById(Long id) {
    	String sqlSelectUserById = "SELECT * FROM trainer WHERE user_id = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUserById, id);
        if(results.next()) {
            return createTrainer(results);
        } else {
            return null;
        }
	}
	
	@Override
	public Client getClientById(Long id) {
    	String sqlSelectUserById = "SELECT * FROM client WHERE user_id = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUserById, id);
        if(results.next()) {
            return createClient(results);
        } else {
            return null;
        }
	}
	
	
	@Override
	public void updateClient(Client client) {
		updateUser(client);
	}
	
	@Override
	public void updateTrainer(Trainer trainer) {
		updateUser(trainer);
		jdbcTemplate.update("UPDATE trainer SET hourly_rate=?, rating=?, philosophy=?, bio_info=?, is_public=?, certifications=?  WHERE user_id=?",
				trainer.getHourlyRate(), trainer.getRating(), trainer.getPhilosophy(), trainer.getBioInfo(), trainer.isPublic(), trainer.getCertifications(), trainer.getId());
	}

	
	private void updateUser(User user) {
		jdbcTemplate.update("UPDATE user_profile SET username=?, first_name=?, last_name=?, city=?, state=? WHERE user_id=?",
				user.getUsername(), user.getFirstName(), user.getLastName(), user.getCity(), user.getState(), user.getId());
		
	}

	@Override
	public List<Trainer> getTrainersSearch(String name, String city, String state, int minHourlyRate, int maxHourlyRate, double rating) {
		List<Trainer> trainerList = new ArrayList<Trainer>();
		String sqlSelectTrainersBySearchCriteria = "SELECT * FROM trainer WHERE CONCAT(firstName, ' ', lastName) ILIKE ? AND city ILIKE ? "
					+ "AND state ILIKE ? AND price_per_hour >= ? AND price_per_hour <= ? AND rating >= ? "
					+ "AND certifications ILIKE ? AND is_public = true AND role = 'Trainer'";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectTrainersBySearchCriteria, "%" + name + "%", "%" + city + "%", "%" + state + "%",
        							minHourlyRate, maxHourlyRate, rating);
        while (results.next()) {
        	trainerList.add(createTrainer(results));
        }
        return trainerList;
	}

	@Override
	public ClientList searchClientList(long id, String name, String username) {
		ClientList clientList = new ClientList();
		clientList.setClientList(searchClientListOfTrainer(id, name, username));
		clientList.setTrainer(getTrainerById(id));
		clientList.setPrivateNotes(getPrivateNotes(id, clientList.getClientList()));
		return clientList;
	}
	
	private List<User> searchClientListOfTrainer(long user_id, String name, String username) {
		List<User> clientList = new ArrayList<User>();
		List<User> listOfAllClients = getClientListOfTrainer(user_id);
		for (User user: listOfAllClients) {
			if ((user.getFirstName() + " " + user.getLastName()).contains(name) &&
					user.getUsername().contains(username)) {
				clientList.add(user);
			}
		}
        return clientList;
	}
	
	private List<User> getClientListOfTrainer(long user_id) {
		String sqlSelectUsersByTrainerId = "SELECT client_id FROM client_list WHERE trainer_id = ?";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectUsersByTrainerId, user_id);
        List<User> clientList = new ArrayList<User>();
        while (results.next()) {
        	clientList.add(getUserById(results.getLong("client_id")));
        }
        return clientList;
	}
	
	
	private Map<User,String[]> getPrivateNotes(long id, List<User> clientList) {
		Map<User,String[]> privateNotes = new HashMap<User,String[]>();
		for (User user: clientList) {
			privateNotes.put(user,getPrivateNotesStringArr(id,user.getId()));
		}
        return privateNotes;
	}
	
	private String[] getPrivateNotesStringArr(long user_id, long client_id) {
		String[] privateNotes = null;
		String sqlSelectPrivateNotes = "SELECT privateNotes FROM client_list WHERE trainer_id = ? and client_id = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlSelectPrivateNotes, user_id, client_id);
		if (results.next()) {
			privateNotes = results.getObject("privateNotes", String[].class);
        }
        return privateNotes;
	}

	@Override
	public void addClientToClientList(long trainer_id, long client_id) {
		jdbcTemplate.update("INSERT INTO client_list (trainer_id, client_id) VALUES (?,?)", trainer_id, client_id);
	}
	
	@Override
	public void removeClientFromClientList(long trainer_id, long client_id) {
		jdbcTemplate.execute("DELETE FROM client_list WHERE trainer_id=? AND client_id=?");
	}
	
	@Override
	public void addPrivateNoteToClientList(long trainer_id, long client_id, String privateNote) {
		String[] privateNotesOld = getPrivateNotesStringArr(trainer_id, client_id);
		String[] privateNotesNew = new String[privateNotesOld.length + 1];
		for (int i = 0; i < privateNotesOld.length; i++) {
			privateNotesNew[i] = privateNotesOld[i];
		}
		privateNotesNew[privateNotesOld.length] = privateNote;
		jdbcTemplate.update("UPDATE client_list SET privateNotes=?  WHERE trainer_id=? AND client_id=?",
				privateNotesNew,trainer_id,client_id);
	}
	
	@Override
	public void removePrivateNoteFromClientList(long trainer_id, long client_id, String privateNote) {
		String[] privateNotesOld = getPrivateNotesStringArr(trainer_id, client_id);
		if (privateNotesOld.length - 1 == 0) {
			jdbcTemplate.update("UPDATE client_list SET privateNotes=?  WHERE trainer_id=? AND client_id=?",
					null,trainer_id,client_id);
		}
		else {
			String[] privateNotesNew = new String[privateNotesOld.length - 1];
			int counter = 0;
			for (int i = 0; i < privateNotesOld.length; i++) {
				if (!privateNotesOld[i].equals(privateNote)) {
					privateNotesNew[counter] = privateNotesOld[i];
					counter++;
				}
			}
			jdbcTemplate.update("UPDATE client_list SET privateNotes=?  WHERE trainer_id=? AND client_id=?",
					privateNotesNew,trainer_id,client_id);
		}
	}

	
}
