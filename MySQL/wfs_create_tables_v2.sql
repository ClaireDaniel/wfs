-- Control categorical variable tables

-- Gender
CREATE TABLE gender_categories(
	gender_code VARCHAR(1),
    gender_label VARCHAR(6)
);

INSERT INTO gender_categories VALUES ('M', 'Male');
INSERT INTO gender_categories VALUES ('F', 'Female');

-- Age division
CREATE TABLE age_division_categories(
	age_div_code VARCHAR(3),
    age_div_label VARCHAR(1)
);

INSERT INTO age_division_categories VALUES ('C', 'Cadet');
INSERT INTO age_division_categories VALUES ('J', 'Junior');
INSERT INTO age_division_categories VALUES ('U23', 'Under 23');
INSERT INTO age_division_categories VALUES ('S', 'Senior');
INSERT INTO age_division_categories VALUES ('V', 'Veteran');

-- Comp type
CREATE TABLE comp_type_categories(
	comp_type_code VARCHAR(3),
    comp_type_label VARCHAR (25)
);

INSERT INTO comp_type_categories VALUES ('NF', 'Non official');
INSERT INTO comp_type_categories VALUES ('CHZ', 'Zone Championships' );
INSERT INTO comp_type_categories VALUES ('GP', 'Grand Prix');
INSERT INTO comp_type_categories VALUES ('SA', 'Sattelite');
INSERT INTO comp_type_categories VALUES ('CHM', 'World CHampionships');
INSERT INTO comp_type_categories VALUES ('A', 'World Cup');
INSERT INTO comp_type_categories VALUES ('JO', 'Olympic Games');
INSERT INTO comp_type_categories VALUES ('OF', 'Official');

-- Weapon type
CREATE TABLE weapon_categories(
	weapon_code VARCHAR(1),
    weapon_label VARCHAR(5)
);

INSERT INTO weapon_categories VALUES ('F', 'Foil');
INSERT INTO weapon_categories VALUES ('S', 'Sabre');
INSERT INTO weapon_categories VALUES ('E', 'Epee');


-- Fencer table
DROP TABLE fencer;

CREATE TABLE fencer (
    fencer_number BIGINT, 
    extract_date DATE,
    first_name VARCHAR (50), 
    last_name VARCHAR (50), 
    country VARCHAR (50), 
    age INT,
    birth_date DATE, 
    ranking_current INT, 
    hand VARCHAR (5), 
    foil BOOL, 
    sabre BOOL, 
    epee BOOL, 
    gender_api VARCHAR(1),
    PRIMARY KEY (fencer_number),
    FOREIGN KEY (gender_api) REFERENCES gender_categories(gender_code));
    
LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/fencer_df_update_171216.csv'
	INTO TABLE fencer
	fields terminated BY ","
	lines terminated BY "\r\n"
	(fencer_number, extract_date, first_name, last_name,
     @country, @age, @birth_date, @ranking_current, @hand,
     @foil, @epee, @sabre, @gender_api) 
       SET country = IF(@country = '', NULL, @country), 
           age = IF(@age = '', NULL, @age), 
           birth_date = IF(@birth_date = '', NULL, @birth_date), 
           ranking_current = IF(@ranking_current = '', NULL, @ranking_current),
           hand = IF(@hand = '', NULL, @hand),
           foil = IF(@foil = '', NULL, @foil),
           sabre = IF(@sabre = '', NULL, @sabre),
           epee = IF(@epee = '', NULL, @epee),
           gender_api = IF(@gender_api = '', NULL, @gender_api);
    
select * from fencer limit 10;

-- Rank table
DROP TABLE ranking;

CREATE TABLE ranking(
	ranking_id INT,
	fencer_number BIGINT,
	rank_type VARCHAR (7),
	rank_season	VARCHAR (9),
    rank_position INT,
    rank_points INT,	
    season_age INT,
	fencer_age_division VARCHAR(7),
    FOREIGN KEY (fencer_number) REFERENCES fencer(fencer_number),
    FOREIGN KEY (rank_type) REFERENCES age_division_categories(age_div_code),
    FOREIGN KEY (fencer_age_division) REFERENCES age_division_categories(age_div_code)
);

LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/rank_df_update_171216.csv'
	INTO TABLE ranking
	fields terminated BY ","
	lines terminated BY "\r\n";
    
SELECT * FROM ranking LIMIT 10;

-- Results table
DROP TABLE results;

CREATE TABLE results (
	results_id INT,
	fencer_number BIGINT,
    results_date DATE,
    results_type VARCHAR (50),
    results_place VARCHAR (50),
    city VARCHAR (50),	
    country	VARCHAR (50),
    results_rank INT,	
    age INT,
    fencer_age_division	VARCHAR(10),
    comp_type VARCHAR(5),	
    comp_level VARCHAR (1),
    comp_weapon VARCHAR (1),
    FOREIGN KEY (fencer_number) REFERENCES fencer(fencer_number),
    FOREIGN KEY (results_type) REFERENCES comp_type_categories(comp_type_label),
    FOREIGN KEY (fencer_age_division) REFERENCES age_division_categories(age_div_code),
    FOREIGN KEY (comp_type) REFERENCES  comp_type_categories(comp_type_code),
    FOREIGN KEY (comp_level) REFERENCES age_division_categories(age_div_code),
    FOREIGN KEY (comp_weapon) REFERENCES weapon_categories(weapon_code)
);

LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/results_df_update_171216.csv'
	INTO TABLE results
	fields terminated BY ","
	lines terminated BY "\r\n"
    (results_id, fencer_number, results_date,
     results_type, results_place, city, country, results_rank,
     @age, @fencer_age_division, comp_type, comp_level, comp_weapon) 
       SET age = IF(@age = '', NULL, @age), 
           fencer_age_division = IF(@fencer_age_division = '', NULL, @afencer_age_division); 
           
SELECT * FROM results LIMIT 10;

-- Opponents table

DROP TABLE opponents;

CREATE TABLE opponents (
	opponents_id INT,
	fencer_number BIGINT,
    opponent_number BIGINT,
    opponent_country VARCHAR (50),
    victories INT,
    defeats INT,
    FOREIGN KEY (fencer_number) REFERENCES fencer(fencer_number),
    FOREIGN KEY (opponent_number) REFERENCES fencer(fencer_number)
);

LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/opponents_df_update_171216.csv'
	INTO TABLE opponents
	fields terminated BY ","
	lines terminated BY "\r\n";
    
SELECT * FROM opponents LIMIT 10;

-- Bouts table

DROP TABLE bouts;

CREATE TABLE bouts (
	bouts_id INT,
	fencer_number BIGINT,
    city VARCHAR(50),
    comp_date DATE,
    comp_type VARCHAR(5),
    comp_level VARCHAR(1),
    comp_weapon VARCHAR(1),
    opponent_number BIGINT,
    fencer_score INT,
    opponent_score INT,
    FOREIGN KEY (fencer_number) REFERENCES fencer(fencer_number),
    FOREIGN KEY (opponent_number) REFERENCES fencer(fencer_number),
	FOREIGN KEY (comp_type) REFERENCES  comp_type_categories(comp_type_code),
    FOREIGN KEY (comp_level) REFERENCES age_division_categories(age_div_code),
    FOREIGN KEY (comp_weapon) REFERENCES weapon_categories(weapon_code)
);

LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/bouts_df_update_171216.csv'
	INTO TABLE bouts
	fields terminated BY ","
	lines terminated BY "\n"
	(bouts_id, fencer_number, @city,
     @comp_date, @comp_type, comp_level, comp_weapon, opponent_name,
     Opponent_number, fencer_score, opponent_score) 
       SET city = IF(@city = '', NULL, @city),
		   comp_date = IF(@comp_date = '', NULL, @comp_date), 
           comp_type = IF(@comp_type = '', NULL, @comp_type);