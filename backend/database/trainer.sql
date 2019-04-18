-- Create the TrainerPortal database
DROP DATABASE IF EXISTS trainer_portal;
CREATE DATABASE trainer_portal;
\c trainer_portal

BEGIN TRANSACTION;

CREATE TABLE app_user
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
        
    constraint pk_app_user primary key (user_id),
    constraint chk_role CHECK (role IN ('Trainer', 'Client'))
);

CREATE TABLE client
(
    user_id int NOT NULL UNIQUE,

    constraint pk_client primary key (user_id)
);

CREATE TABLE trainer
(
    user_id               int     NOT NULL UNIQUE,
    is_public             boolean NOT NULL DEFAULT false,
    hourly_rate           int,
    rating                int,
    philosophy            varchar(80),
    biography             text,
    certifications_pickle varchar,

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
    completed boolean   NOT NULL DEFAULT false,   

    constraint pk_workout_plan primary key (workoutplan_id, trainer_id, client_id)
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
INSERT INTO app_user 
 (user_id , first_name , last_name   , username                 , password , salt   , role     , address                  , city                , state , zip) VALUES
 (1       , 'Test'     , 'Trainer'   , 'trainer'                , 'pass'   , 'salt' , 'Trainer' , '558 Cliffe Knoll'       , 'Koelpinberg'       , 'OH'  , '41042')
,(2       , 'Elise'    , 'Mayert'    , 'Lewis.Paucek'           , 'pass'   , 'salt' , 'Trainer' , '705 Fenton Ride'        , 'South Yvonne'      , 'MD'  , '41042')
,(3       , 'Zella'    , 'Hilpert'   , 'Arvel.Ruecker'          , 'pass'   , 'salt' , 'Trainer' , '626 Lunnfields Lane'    , 'Doramouth'         , 'OR'  , '41042')
,(4       , 'Darius'   , 'Thompson'  , 'Ebba.Mueller47'         , 'pass'   , 'salt' , 'Trainer' , '261 Crossley West'      , 'East Carlotta'     , 'IN'  , '41042')
,(5       , 'Cristina' , 'Russel'    , 'Bradford.Ziemann'       , 'pass'   , 'salt' , 'Trainer' , '658 Rosebank By-Pass'   , 'Orionburgh'        , 'DE'  , '41042')
,(6       , 'Test'     , 'Client'    , 'client'                 , 'pass'   , 'salt' , 'Trainer' , '648 Hanbury Green'      , 'Langoshmouth'      , 'ME'  , '41042')
,(7       , 'Ellsworth', 'Rutherford', 'Maximillian.Schamberger', 'pass'   , 'salt' , 'Trainer' , '557 Spa Road'           , 'East Janis'        , 'RI'  , '41042')
,(8       , 'Eloise'   , 'Skiles'    , 'Catherine.Moore'        , 'pass'   , 'salt' , 'Trainer' , '921 Johnson Moorings'   , 'Stoltenbergside'   , 'WY'  , '41042')
,(9       , 'Wilhelm'  , 'Effertz'   , 'Skyla_Rowe46'           , 'pass'   , 'salt' , 'Trainer' , '232 Shannon Glas'       , 'South Cassidyton'  , 'WY'  , '41042')
,(10      , 'Bridgette', 'Wisozk'    , 'Jerrod55'               , 'pass'   , 'salt' , 'Trainer' , '639 Old Oak Rise'       , 'Swaniawskifurt'    , 'PA'  , '41042')
,(11      , 'Lesley'   , 'Harris'    , 'Carter29'               , 'pass'   , 'salt' , 'Trainer' , '330 Knole Grove'        , 'New Braeden'       , 'AR'  , '41042')
,(12      , 'Dayna'    , 'Rohan'     , 'Sheila67'               , 'pass'   , 'salt' , 'Trainer' , '336 Ferndale Dell'      , 'North Foster'      , 'NJ'  , '41042')
,(13      , 'Morton'   , 'Schaefer'  , 'Obie_Rath'              , 'pass'   , 'salt' , 'Trainer' , '897 Hay Lea'            , 'North Naomiemouth' , 'WA'  , '41042')
,(14      , 'Amira'    , 'Sawayn'    , 'Jenifer.Bernier'        , 'pass'   , 'salt' , 'Trainer' , '487 Tudor Orchard'      , 'South Dusty'       , 'WA'  , '41042')
,(15      , 'Gino'     , 'Gutmann'   , 'Warren79'               , 'pass'   , 'salt' , 'Trainer' , '895 Barnes Crest'       , 'East Alysson'      , 'NH'  , '41042')
,(16      , 'Reilly'   , 'Mayer'     , 'Keegan_Maggio'          , 'pass'   , 'salt' , 'Trainer' , '365 Ger-Y-Ffrwd'        , 'South Sherman'     , 'CT'  , '41042')
,(17      , 'Sonny'    , 'Mohr'      , 'Bernadette_Gorczany'    , 'pass'   , 'salt' , 'Trainer' , '355 Rusland Park'       , 'Stantonberg'       , 'CT'  , '41042')
,(18      , 'Hayley'   , 'Anderson'  , 'Ellis_Brakus'           , 'pass'   , 'salt' , 'Trainer' , '671 Buckley Park'       , 'West Norval'       , 'KY'  , '41042')
,(19      , 'Hailee'   , 'Glover'    , 'Aida78'                 , 'pass'   , 'salt' , 'Trainer' , '136 Almond Elms'        , 'New Annetta'       , 'IN'  , '41042')
,(20      , 'Conner'   , 'Abshire'   , 'Lessie.McKenzie98'      , 'pass'   , 'salt' , 'Trainer' , '849 Sutton Parkway'     , 'McLaughlinbury'    , 'OR'  , '41042')
,(21      , 'Isaias'   , 'Medhurst'  , 'Brendon_Hegmann'        , 'pass'   , 'salt' , 'Client' , '486 Blenkarne Road'     , 'Kristopherberg'    , 'WA'  , '41042')
,(22      , 'Christine', 'Tillman'   , 'Unique_Davis'           , 'pass'   , 'salt' , 'Client' , '740 Jesmond Isaf'       , 'North Mekhi'       , 'NC'  , '41042')
,(23      , 'Dandre'   , 'Romaguera' , 'Monserrate.Yost81'      , 'pass'   , 'salt' , 'Client' , '539 Colliers Villas'    , 'Melbaport'         , 'CT'  , '41042')
,(24      , 'Gayle'    , 'Dare'      , 'Emerson_Labadie'        , 'pass'   , 'salt' , 'Client' , '913 Sandpiper Laurels'  , 'South Monroe'      , 'OK'  , '41042')
,(25      , 'Ezra'     , 'Zemlak'    , 'Irving.Pouros'          , 'pass'   , 'salt' , 'Client' , '260 Davis Farm'         , 'Guillermoton'      , 'AR'  , '41042')
,(26      , 'Maiya'    , 'Grady'     , 'Leonor.Sawayn38'        , 'pass'   , 'salt' , 'Client' , '862 Greenfinch Gardens' , 'Thompsonmouth'     , 'SD'  , '41042')
,(27      , 'Jonatan'  , 'Feeney'    , 'Maybelle_Lang92'        , 'pass'   , 'salt' , 'Client' , '692 Henry Side'         , 'South Genevieveton', 'DE'  , '41042')
,(28      , 'Jalon'    , 'Robel'     , 'Felicita1'              , 'pass'   , 'salt' , 'Client' , '530 Allan Celyn'        , 'West Kodymouth'    , 'AZ'  , '41042')
,(29      , 'Einar'    , 'Herzog'    , 'Rusty.Cormier18'        , 'pass'   , 'salt' , 'Client' , '291 Devonshire Street'  , 'South Karliport'   , 'VT'  , '41042')
,(30      , 'Emma' , 'Smith'   , 'Elisabeth.Auer'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(31      , 'Olivia' , 'Jones'   , 'Peccadillo'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(32      , 'Ava' , 'Thompson'   , 'StipendWhiff'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(33      , 'Sophia' , 'Sanders'   , 'Atrichia'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(34      , 'Mia' , 'Baker'   , 'EMainstay'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(35      , 'Charlotte' , 'Halloway'   , 'Telenergy'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(36      , 'Evelyn' , 'King'   , 'Caritative'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(37      , 'Abigail' , 'Ruhm'   , 'Abattoir'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(38      , 'Harper' , 'Morris'   , 'Yowndrift'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(39      , 'Elizabeth' , 'Poff'   , 'Gnosticism'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(40      , 'Emily' , 'Abott'   , 'Distributary'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(41      , 'Sofia' , 'Donner'   , 'Aza1Galago'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(42      , 'Ella' , 'Norris'   , 'Zoonosis'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(43      , 'Scarlett' , 'Ohara'   , 'Luminous'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(44      , 'Steve' , 'Wachs'   , 'XxxastrophZyrian'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(45      , 'James' , 'Peach'   , 'Nullibicity'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(46      , 'John' , 'Knight'   , 'Acantha'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(47      , 'Michael' , 'Jorden'   , 'Eiderdown'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(48      , 'David' , 'Ross'   , 'Fricassee'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(49      , 'William' , 'Stone'   , 'Chimichanga'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(50      , 'Brian' , 'Brooks'   , 'Flapdoodle'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(51      , 'Eric' , 'Walsh'   , 'Loggerhead'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
,(52      , 'Scott' , 'Allen'   , 'Hangdog'         , 'pass'   , 'salt' , 'Client' , '210 Austin Court'       , 'South Karliport'   , 'VT'  , '41042')
;

INSERT INTO trainer (user_id,hourly_rate,rating,is_public,philosophy,biography,certifications_pickle) VALUES
 (1,55,1,true,'Find some exercise that you connect with and make it joyous, not a chore.','I try to help clients achieve a balanced lifestyle that encompasses all dimensions of health & wellness. With an extensive background in coaching, I try to create a training environment that not only motivates but also empowers individuals to continually challenge themselves in a fun and rewarding way.','["American Council on Exercise (ACE)", "National Academy of Sports Medicine (NASM)", "International Sports Sciences Association (ISSA)", "American College of Sports Medicine (ACSM)", "National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"]')
,(2,25,5,true,'Exercising often and eating nourishing meals does not need to be a chore.','There are many reasons why people choose to exercise. Whether you want to improve your sport performance, reduce health risks, or look and feel better I can help you achieve your goals. Using a functional, yet fun approach I’ll help give you an edge – an edge in performance, and edge in health, and an edge in life.', '["International Sports Sciences Association (ISSA)", "National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"]')
,(3,60,2,true,'I individualize lifestyle programs for people to incorporate into their lives!','Our fitness is important and something we should all enjoy. My aim is to create a positive and fun experience for clients, as well as using the best of my knowledge and experience to help clients achieve their goals.', '["National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"]')
,(4,200,4,true,'You only get one body. Invest in it. It lasts longer than an expensive purse.','I use my experience from sports and cooking to help clients achieve the goals they have set for themselves and more. I believe the key to this success is by building a solid foundation in the beginning. I am passionate about using correct form, proper technique, and injury prevention in a fun environment. I believe that we all, regardless of our current conditioning, are able to achieve the goals that we have for ourselves.', '["American Council on Exercise (ACE)", "American College of Sports Medicine (ACSM)", "National Strength and Conditioning Association (NSCA)", "National Federation of Professional Trainers (NFPT)"]')
,(5,25,2,true,'Eat well, sweat often and laugh your butt off. That’s the magic trifecta.','Growing up on a steady diet of kung-fu movies, it seemed inevitable that my first foray, as an adolescent, into the world of health and fitness would be through martial arts. Now, my passion and experiences in fitness have broadened to include weight training, running, yoga, hiking, surfing, and more. At an early age, I was taught that health and well-being of an individual encompasses the mind, body and soul. As a personal trainer, I like to take a fun and educational approach to each workout session. My aim is to equip you with not only the skills, but also the knowledge of how to reach your fitness and health goals.', '["National Federation of Professional Trainers (NFPT)"]')
;


INSERT INTO message (message_id, sender_id, recipient_id, post_date, unread, subject, message) VALUES
 (1,1,2,'1/10/2019',true,'Keep it up', 'Be consistent with everything. Training, diet, sleep and supplement regimen. One cheat day a week, but no more. One leads to two and two leads to three and so on and so forth.')
,(2,1,2,'1/10/2019',false,'You can do it', 'Treat it like your job, be prepared, and when your exercising, every rep and set give your fullest, never slack, Cause your only cheating You. And you can do more than You think you can. Sequence, routine, Goals!')
,(3,1,2,'1/10/2019',true,'Goals', 'When you choose long-term growth instead of short-term gain, you are in alignment with fulfilling your own individual potential for its own sake””instead of trying to achieve results only. Being mindful of your true intentions makes all the difference, inside the gym and in life.')
,(4,2,1,'1/11/2019',true,'Do not give up', 'Keep coming back! Even when you are hating! Your effort will be rewarded! Your not a dog either? Digs are rewarded with food! Food is fuel! Not for being good!')
,(5,2,1,'1/11/2019',false,'Split out your workouts', 'You are better off doing a 45-minute, moderate-intensity strength circuit three times per week than to do a two-hour, high-intensity workout six times a week, and then burning out in three weeks because it’s not sustainable. And remember that it takes time and consistency to build your body, but one workout can put you in a better mood.')
;

-- client list
INSERT INTO client_list (trainer_id, client_id) VALUES
 (1,21)
,(1,22)
,(1,23)
,(2,24)
,(2,25)
,(2,26)
,(3,27)
,(3,28)
,(3,29)
,(4,30)
,(4,31)
,(4,32)
,(4,33)
,(5,34)
,(5,35)
,(5,36)
,(6,37)
,(6,38)
,(6,39)
,(7,40)
,(7,41)
,(7,42)
,(8,43)
,(8,44)
,(8,45)
,(9,46)
,(10,47)
,(11,48)
,(12,49)
,(13,50)
,(14,51)
,(15,52)
;

-- work_out plan
INSERT INTO workout_plan (trainer_id, client_id, days_of_week, title, body) VALUES 
(1, 21, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(1, 21, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(1, 21, 'FFFFFFT', 'Cardio', 'Bike for 45 minutes'),
(1, 21, 'FTFTFTF', 'Marathon Training', '5 miles, 5 miles, 10 miles'),
(1, 22, 'FFTFTFT', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(1, 22, 'FTFTFTF', 'Legs', 'Do 3 sets of 15 squats and 3 sets of 20 lunges'),
(1, 22, 'FFTFTFF', 'Arms and Chest', 'Do 2 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(1, 22, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(1, 22, 'FTFTFTF', 'Marathon Training', '5 miles, 5 miles, 10 miles'),
(1, 23, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(1, 23, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(1, 23, 'FFTFTFT', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(2, 24, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(2, 24, 'FTFTFTF', 'Marathon Training', '5 miles, 5 miles, 10 miles'),
(2, 25, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(2, 25, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(2, 25, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(2, 26, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(2, 26, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(2, 26, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(2, 26, 'FFTFTFT', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(3, 27, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(3, 27, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(3, 27, 'FFTFTFT', 'Marathon Training', 'Run for 1 hour'),
(3, 28, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(3, 28, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(3, 28, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(3, 28, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(3, 29, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(3, 29, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(3, 29, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(4, 30, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(4, 30, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(4, 30, 'FFTFTFT', 'Marathon Training', 'Run for 1 hour'),
(4, 31, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(4, 32, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(4, 32, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(4, 32, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(4, 32, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(4, 33, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(4, 33, 'FFTFTFT', 'Marathon Training', 'Run 7 miles for the first week for each day and 12 miles durring the second week'),
(4, 33, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(4, 33, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(4, 33, 'FFFFFFT', 'Cardio', 'Stairclimber for 45 minutes'),
(5, 34, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(5, 34, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(5, 35, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(5, 35, 'FFTFTFF', 'Boxing', 'Spar for 20 minutes'),
(5, 35, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(5, 36, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(5, 36, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(5, 36, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(5, 36, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(6, 37, 'FFTFTFF', 'Spinning', 'Spin for 30 minutes each workout day'),
(6, 37, 'FFTFTFT', 'Cardio', 'Stairclimber for 45 minutes'),
(6, 37, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(6, 38, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(6, 38, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(6, 39, 'FFTFTFF', 'Boxing', 'Spar for 20 minutes'),
(6, 39, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(6, 39, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(7, 40, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(7, 40, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(7, 40, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(7, 41, 'FFTFTFF', 'Spinning', 'Spin for 30 minutes each workout day'),
(7, 41, 'FFFFFFT', 'Cardio', 'Stairclimber for 45 minutes'),
(7, 42, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(7, 42, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(7, 42, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(8, 43, 'FFTFTFT', 'Boxing', 'Spar for 20 minutes'),
(8, 43, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(8, 43, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(8, 43, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(8, 44, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(8, 44, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(8, 44, 'FFTFTFF', 'Spinning', 'Spin for 30 minutes each workout day'),
(8, 45, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(8, 45, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(8, 45, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(8, 45, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(9, 46, 'FFTFTFT', 'Spinning', 'Spin for 30 minutes each workout day'),
(9, 46, 'FFFFFFT', 'Cardio', 'Stairclimber for 45 minutes'),
(10, 47, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(10, 47, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(10, 47, 'FTFTFTF', 'Marathon Training', 'Run for 1 hour'),
(11, 48, 'FFTFTFF', 'Boxing', 'Spar for 20 minutes'),
(11, 48, 'FFTFTFF', 'Marathon Training', 'Run 5 miles for the first week for each day and 10 miles durring the second week'),
(12, 49, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(12, 49, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(12, 49, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(12, 49, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(13, 50, 'FFTFTFF', 'Spinning', 'Spin for 30 minutes each workout day'),
(14, 51, 'FFTFTFT', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(14, 51, 'FFTFTFF', 'Arms and Chest', 'Do 3 sets of bench, 2 sets of cleans, and 2 sets of 10 pull-ups'),
(14, 51, 'FFFFFFT', 'Cardio', 'Run for 45 minutes'),
(14, 51, 'FTFTFTF', 'Legs', 'Do 5 sets of 10 squats and 5 sets of 20 lunges'),
(15, 52, 'FFTFTFT', 'Spinning', 'Spin for 30 minutes each workout day')
;

-- Fixup Schema
-- ============

-- user_id sequence
select setval('app_user_user_id_seq', (select max(user_id) from app_user));

-- Foreign Key Constraints
ALTER TABLE client
ADD FOREIGN KEY(user_id)
REFERENCES app_user(user_id);

ALTER TABLE trainer
ADD FOREIGN KEY(user_id)
REFERENCES app_user(user_id);

ALTER TABLE client_list
ADD FOREIGN KEY(trainer_id) REFERENCES app_user(user_id),
ADD FOREIGN KEY(client_id)  REFERENCES app_user(user_id);

ALTER TABLE message
ADD FOREIGN KEY(sender_id)    REFERENCES app_user(user_id),
ADD FOREIGN KEY(recipient_id) REFERENCES app_user(user_id);


ALTER TABLE workout_plan
ADD FOREIGN KEY(trainer_id) REFERENCES app_user(user_id),
ADD FOREIGN KEY(client_id)  REFERENCES app_user(user_id);

-- Realistic values
-- ================

-- the password is 'password' for everyone
UPDATE app_user
SET
    username = UPPER(username),
    password = '327BtUzwOFiH7YN3BjySWA==',
    salt     = 'TCtA0l/RfWIfJkIRtEppHOp53FcciS4xSEJOu3z0J8kAOcKZFVQRu7ew4agRozh5Je6IL5Ruqv+gcSS4H1Mp6zPg0EOHQG16DQejzWNeZN3GIdi4E/368H2ze72papiIql8HmHhuDhQ6uS8VreE3xxo6ro19CenQp9ORnXEut3s='
;

-- the first 5 app_user are trainers, the rest are clients
--UPDATE app_user
--SET role = 'Trainer'
--WHERE user_id <= 5;

UPDATE trainer SET is_public = random_boolean();

-- clients
INSERT INTO client (user_id)
SELECT user_id FROM app_user
WHERE user_id > 20;

COMMIT TRANSACTION;