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
    foil VARCHAR (4), 
    sabre VARCHAR (4), 
    epee VARCHAR (4), 
    gender_api VARCHAR(7),
    PRIMARY KEY (fencer_number));
    
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
	fencer_number BIGINT,
	first_name VARCHAR (50),
	last_name VARCHAR (50),
	rank_type VARCHAR (7),
	rank_season	VARCHAR (9),
    rank_position INT,
    rank_points INT,	
    season_age INT,
	fencer_age_division VARCHAR(7),
    FOREIGN KEY (fencer_number) REFERENCES fencer(fencer_number)
);

LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/rank_df_update_171216.csv'
	INTO TABLE ranking
	fields terminated BY ","
	lines terminated BY "\r\n";
    
SELECT * FROM ranking LIMIT 10;

-- Results table
DROP TABLE results;

CREATE TABLE results (
	fencer_number BIGINT,
    first_name VARCHAR (50),
    last_name VARCHAR (50),
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
    FOREIGN KEY (fencer_number) REFERENCES fencer(fencer_number)
);

LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/results_df_update_171216.csv'
	INTO TABLE results
	fields terminated BY ","
	lines terminated BY "\r\n"
    (fencer_number, first_name, last_name, results_date,
     results_type, results_place, city, country, results_rank,
     @age, @fencer_age_division, comp_type, comp_level, comp_weapon) 
       SET age = IF(@age = '', NULL, @age), 
           fencer_age_division = IF(@fencer_age_division = '', NULL, @afencer_age_division); 
           
SELECT * FROM results LIMIT 10;

-- Opponents table

DROP TABLE opponents;

CREATE TABLE opponents (
	fencer_number BIGINT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    opponent_name VARCHAR(50),
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
	fencer_number BIGINT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(50),
    comp_date DATE,
    comp_type VARCHAR(5),
    comp_level VARCHAR(1),
    comp_weapon VARCHAR(1),
    opponent_name VARCHAR(50),
    opponent_number BIGINT,
    fencer_score INT,
    opponent_score INT,
    FOREIGN KEY (fencer_number) REFERENCES fencer(fencer_number),
    FOREIGN KEY (opponent_number) REFERENCES fencer(fencer_number)
);

LOAD DATA LOCAL infile 'C:/Users/cdaniel/fie-fencing-data/Updates/bouts_df_update_171216.csv'
	INTO TABLE bouts
	fields terminated BY ","
	lines terminated BY "\n"
	(fencer_number, first_name, last_name, @city,
     @comp_date, @comp_type, comp_level, comp_weapon, opponent_name,
     Opponent_number, fencer_score, opponent_score) 
       SET city = IF(@city = '', NULL, @city),
		   comp_date = IF(@comp_date = '', NULL, @comp_date), 
           comp_type = IF(@comp_type = '', NULL, @comp_type);
    

