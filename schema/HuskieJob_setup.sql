DROP DATABASE IF EXISTS HuskiesJob;
CREATE DATABASE HuskiesJob;
USE HuskiesJob;

-- USERS
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(100) NOT NULL,
  major VARCHAR(45) NOT NULL,
  class_year INT,
  gpa DECIMAL(3,2),
  location_preference VARCHAR(100),
  has_car BOOLEAN,
  job_preference_primary VARCHAR(45),
  job_preference_secondary VARCHAR(45),
  created_at DATETIME
);

-- COMPANY
DROP TABLE IF EXISTS Company;
CREATE TABLE Company (
  company_id INT PRIMARY KEY AUTO_INCREMENT,
  company_name VARCHAR(100) NOT NULL,
  industry VARCHAR(45),
  company_size VARCHAR(20),
  headquarters VARCHAR(100),
  website VARCHAR(150),
  rating DECIMAL(2,1)
);

-- POSITION
DROP TABLE IF EXISTS Positions;
CREATE TABLE Positions (
  position_id INT PRIMARY KEY AUTO_INCREMENT,
  company_id INT NOT NULL,
  title VARCHAR(100) NOT NULL,
  job_category VARCHAR(45),
  required_major VARCHAR(45),
  location VARCHAR(100),
  work_mode VARCHAR(20),
  salary_min INT,
  salary_max INT,
  job_type VARCHAR(20),
  term VARCHAR(20),
  description TEXT,
  required_experience VARCHAR(100),
  posted_date DATE,
  application_deadline DATE,
  start_date DATE,
  FOREIGN KEY (company_id) REFERENCES Company(company_id)
);

-- APPLICATION
DROP TABLE IF EXISTS Application;
CREATE TABLE Application (
  application_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  position_id INT NOT NULL,
  application_date DATE,
  status VARCHAR(20),
  notes TEXT,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (position_id) REFERENCES Positions(position_id)
);

-- SKILLS
DROP TABLE IF EXISTS Skills;
CREATE TABLE Skills (
  skill_id INT PRIMARY KEY AUTO_INCREMENT,
  skill_name VARCHAR(45) NOT NULL
);

-- POSITION SKILL
DROP TABLE IF EXISTS Position_Skill;
CREATE TABLE Position_Skill (
  position_id INT NOT NULL,
  skill_id INT NOT NULL,
  FOREIGN KEY (position_id) REFERENCES Positions(position_id),
  FOREIGN KEY (skill_id) REFERENCES Skills(skill_id)
);

-- USER SKILL
DROP TABLE IF EXISTS User_Skill;
CREATE TABLE User_Skill (
  user_id INT NOT NULL,
  skill_id INT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (skill_id) REFERENCES Skills(skill_id)
);