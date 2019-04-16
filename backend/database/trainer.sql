-- Create the TrainerPortal database
DROP DATABASE trainer_portal;
CREATE DATABASE trainer_portal;
\c trainer_portal

BEGIN TRANSACTION;

CREATE TABLE users
(
    -- account
    user_id    int          GENERATED BY DEFAULT AS IDENTITY,
    username   varchar(25)  NOT NULL UNIQUE,
    role       varchar(10)  NOT NULL,

    -- authentication
    password   varchar(256) NOT NULL,
    salt       varchar(256) NOT NULL,

    -- personal information
    first_name varchar(25)  NOT NULL,
    last_name  varchar(25)  NOT NULL,
    address    varchar(120),
    city       varchar(30),
    state      varchar(2),
    zip        varchar(16),
        
    constraint pk_users primary key (user_id),
    constraint chk_role CHECK (role IN ('Trainer', 'Client'))
);

CREATE TABLE client
(
    user_id int NOT NULL UNIQUE,

    constraint pk_client primary key (user_id)
);

CREATE TABLE trainer
(
    user_id        int NOT NULL UNIQUE,
    is_public      boolean NOT NULL DEFAULT false,
    hourly_rate    int,
    rating         int,
    philosophy     varchar(80),
    biography            text,
    certifications varchar(80)[],

    constraint pk_trainer primary key (user_id),
    constraint chk_role CHECK (rating BETWEEN 0 AND 5)
);

CREATE TABLE client_list 
(
    trainer_id    int NOT NULL,
    client_id     int NOT NULL,
    private_notes text[],

    constraint pk_client_list primary key (trainer_id, client_id)
);

CREATE TABLE message
(
    message_id   int       GENERATED BY DEFAULT AS IDENTITY,
    sender_id    int       NOT NULL,
    recipient_id int       NOT NULL,
    post_date    timestamp NOT NULL DEFAULT NOW(),
    unread       boolean   NOT NULL DEFAULT true,
    subject      varchar(250),
    message      text,

    constraint pk_private_message primary key (message_id)
);

CREATE TABLE workout_plan
(
    workoutplan_id      int GENERATED BY DEFAULT AS IDENTITY,
    trainer_id          int NOT NULL,
    client_id           int NOT NULL,
    days_of_week        varchar(7)   NOT NULL DEFAULT 'FFFFFFF',
    title               varchar(30),
    body                varchar(250),

    constraint pk_orkout_plan primary key (workoutplan_id,trainer_id, client_id)
);

-- Stored Procedures
CREATE OR REPLACE FUNCTION random_integer(low INT ,high INT)
RETURNS INT AS
$$
BEGIN
    RETURN floor(random()* (high-low + 1) + low);
END;
$$
LANGUAGE 'plpgsql' STRICT;

CREATE OR REPLACE FUNCTION random_boolean()
RETURNS BOOLEAN AS
$$
BEGIN
    IF random() < 0.5 THEN
        RETURN false;
    ELSE
        RETURN true;
    END IF;
END;
$$
LANGUAGE 'plpgsql' STRICT;

-- user data
INSERT INTO users (user_id,first_name,last_name,username,password,salt,role,city,state) VALUES
 (1,'Test','Trainer','trainer','pKkjz5CLGGIh4ND','fOzycrWX4cXAGGV','Client'                             ,'Koelpinberg'       ,'OH')
,(2,'Elise','Mayert','Lewis.Paucek','UAs6zyKsgghmcZw','cmvaE2gYpCkM59d','Client'                        ,'South Yvonne'      ,'MD')
,(3,'Zella','Hilpert','Arvel.Ruecker','AjQc1h8S3cPyKTm','zPa43KHWCeNl9yi','Client'                      ,'Doramouth'         ,'OR')
,(4,'Darius','Thompson','Ebba.Mueller47','1RQFACvS2fLeeup','GCXIVxeMYZVfxZn','Client'                   ,'East Carlotta'     ,'IN')
,(5,'Cristina','Russel','Bradford.Ziemann','09X7f1tKIgbIND7','rMirr4sFnQ0bkAW','Client'                 ,'Orionburgh'        ,'DE')
,(6,'Test','Client','client','ttuMvaHBZ0HWVCX','fPpyI1PLJaFOvSQ','Client'                               ,'Langoshmouth'      ,'ME')
,(7,'Ellsworth','Rutherford','Maximillian.Schamberger','3aTCI28burpURRh','PfvkPqKIwMN1Wwd','Client'     ,'East Janis'        ,'RI')
,(8,'Eloise','Skiles','Catherine.Moore','Skeor05X3nJBcwB','LwkU4KSFfhDRc4E','Client'                    ,'Stoltenbergside'   ,'WY')
,(9,'Wilhelm','Effertz','Skyla_Rowe46','oU_PkXeGP_A4q9x','T_EVPauG96wGJsD','Client'                     ,'South Cassidyton'  ,'WY')
,(10,'Bridgette','Wisozk','Jerrod55','AidVtlC0bclToof','mM6i_tySQ4xMWe_','Client'                       ,'Swaniawskifurt'    ,'PA')
,(11,'Lesley','Harris','Carter29','kkQUtIpwSg6uqQA','vt_ZpYEQ06eZ2KR','Client'                          ,'New Braeden'       ,'AR')
,(12,'Dayna','Rohan','Sheila67','EGli40Llqzw_HE8','fbDL72CvOFoffcF','Client'                            ,'North Foster'      ,'NJ')
,(13,'Morton','Schaefer','Obie_Rath','qW6ZQRlKxFlh7Sx','mg3CjDywPaWJFQ_','Client'                       ,'North Naomiemouth' ,'WA')
,(14,'Amira','Sawayn','Jenifer.Bernier','MtYx92ZZ7vsodi9','B5EfSZjGr3OKjLX','Client'                    ,'South Dusty'       ,'WA')
,(15,'Gino','Gutmann','Warren79','ICDkwylkzVqI2nx','5DeAEIONGxwVk8e','Client'                           ,'East Alysson'      ,'NH')
,(16,'Reilly','Mayer','Keegan_Maggio','Q3VEYXYJuwt7oWT','44EsZaKbLXv7kIp','Client'                      ,'South Sherman'     ,'CT')
,(17,'Sonny','Mohr','Bernadette_Gorczany','TI4e73cmara8rPb','7E1tC3bFiDkRajp','Client'                  ,'Stantonberg'       ,'CT')
,(18,'Hayley','Anderson','Ellis_Brakus','hklek6OycU3upx3','S38vsXgq7IpbLN7','Client'                    ,'West Norval'       ,'KY')
,(19,'Hailee','Glover','Aida78','9QC6mQdcGruBUOq','nhdMcQNuoH5rRHa','Client'                            ,'New Annetta'       ,'IN')
,(20,'Conner','Abshire','Lessie.McKenzie98','mmBLag7Dt9ovgqb','1i68Ns09XorOkrK','Client'                ,'McLaughlinbury'    ,'OR')
,(21,'Isaias','Medhurst','Brendon_Hegmann','fDWN7L_aNElDWlB','pcggOUXY36ScmdZ','Client'                 ,'Kristopherberg'    ,'WA')
,(22,'Christine','Tillman','Unique_Davis','4oBQoYM7mceodjI','kDhbkGpIowia4n9','Client'                  ,'North Mekhi'       ,'NC')
,(23,'Dandre','Romaguera','Monserrate.Yost81','d7ZDXioVEs7TsxT','UehUbtLP2dGdzH_','Client'              ,'Melbaport'         ,'CT')
,(24,'Gayle','Dare','Emerson_Labadie','EtPDoxbFcaQyUZ8','JtfZoOPeo3zWxEP','Client'                      ,'South Monroe'      ,'OK')
,(25,'Ezra','Zemlak','Irving.Pouros','39ZRF8UP0f4iX8E','8Lin5ITYfmWgolI','Client'                       ,'Guillermoton'      ,'AR')
,(26,'Maiya','Grady','Leonor.Sawayn38','nCqtVzqSSdq8uhv','G5EDeUR_OyGbMwt','Client'                     ,'Thompsonmouth'     ,'SD')
,(27,'Jonatan','Feeney','Maybelle_Lang92','TUeJ0uWqaTRDi0Z','29JqvAZsSnCbQMI','Client'                  ,'South Genevieveton','DE')
,(28,'Jalon','Robel','Felicita1','ExDfSHfnWFxxJuY','PZuWr5xdzq9aoQt','Client'                           ,'West Kodymouth'    ,'AZ')
,(29,'Einar','Herzog','Rusty.Cormier18','8bF1iWNjqJg9ICL','AXbu_Zx26UWc3Rf','Client'                    ,'South Karliport'   ,'VT')
,(30,'Casandra','Reichel','Elisabeth.Auer','oawIZfF9NvJhIGh','agQ9E6kyL1tIMau','Client'                 ,'South Karliport'   ,'VT')
;

INSERT INTO trainer (user_id,hourly_rate,rating,is_public,philosophy,biography,certifications) VALUES
 (1,55,1,true,'We need to quantify the solid state SSL protocol!','Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.','{"American Council on Exercise (ACE)", "National Academy of Sports Medicine (NASM)", "International Sports Sciences Association (ISSA)", "American College of Sports Medicine (ACSM)", "National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"}')
,(2,25,5,true,'You can''t back up the firewall without synthesizing the 1080p XSS interface!','Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '{"International Sports Sciences Association (ISSA)", "National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"}')
,(3,60,2,true,'I''ll calculate the bluetooth AGP transmitter, that should sensor the FTP driver!','Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '{"National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"}')
,(4,200,4,true,'Try to transmit the IB firewall, maybe it will transmit the primary transmitter!','Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '{"American Council on Exercise (ACE)", "American College of Sports Medicine (ACSM)", "National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"}')
,(5,25,2,true,'You can''t index the pixel without copying the optical ADP matrix!','Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry''s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', '{"National Federation of Professional Trainers (NFPT)"}')
;


INSERT INTO message (message_id, sender_id, recipient_id, post_date, unread, subject, message) VALUES
 (1,1,2,'1/10/2019',true,'Subject 1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
,(2,1,2,'1/10/2019',false,'Subject 2', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
,(3,1,2,'1/10/2019',true,'Subject 3', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
,(4,2,1,'1/11/2019',true,'Reply 1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
,(5,2,1,'1/11/2019',false,'Reply 2', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
;

-- Fixup Schema
-- ============

-- user_id sequence
select setval('users_user_id_seq', (select max(user_id) from users));

-- Foreign Key Constraints
ALTER TABLE client
ADD FOREIGN KEY(user_id)
REFERENCES users(user_id);

ALTER TABLE trainer
ADD FOREIGN KEY(user_id)
REFERENCES users(user_id);

ALTER TABLE client_list
ADD FOREIGN KEY(trainer_id) REFERENCES users(user_id),
ADD FOREIGN KEY(client_id)  REFERENCES users(user_id);

ALTER TABLE message
ADD FOREIGN KEY(sender_id)    REFERENCES users(user_id),
ADD FOREIGN KEY(recipient_id) REFERENCES users(user_id);


ALTER TABLE workout_plan
ADD FOREIGN KEY(trainer_id) REFERENCES users(user_id),
ADD FOREIGN KEY(client_id)  REFERENCES users(user_id);

-- Realistic values
-- ================

-- the password is 'password' for everyone
UPDATE users
SET
    username = UPPER(username),
    password = '327BtUzwOFiH7YN3BjySWA==',
    salt     = 'TCtA0l/RfWIfJkIRtEppHOp53FcciS4xSEJOu3z0J8kAOcKZFVQRu7ew4agRozh5Je6IL5Ruqv+gcSS4H1Mp6zPg0EOHQG16DQejzWNeZN3GIdi4E/368H2ze72papiIql8HmHhuDhQ6uS8VreE3xxo6ro19CenQp9ORnXEut3s='
;

-- the first 5 users are trainers, the rest are clients
UPDATE users
SET role = 'Trainer'
WHERE user_id <= 5;

UPDATE trainer SET is_public = random_boolean();

-- clients
INSERT INTO client (user_id)
SELECT user_id FROM users
WHERE user_id > 5;


-- client list
INSERT INTO client_list (trainer_id, client_id) VALUES
 (1,6)
,(1,7);

-- work_out plan
INSERT INTO workout_plan (trainer_id, client_id, days_of_week, title, body)
VALUES (1, 6, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(1, 6, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(1, 6, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(1, 7, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(1, 7, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week');


COMMIT TRANSACTION;

