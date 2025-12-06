DROP DATABASE IF EXISTS testing_system;
CREATE DATABASE testing_system;

USE testing_system;

CREATE TABLE department(
	department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE `position`(
	position_id INT PRIMARY KEY AUTO_INCREMENT,
    position_name ENUM('Dev', 'Test','Scrum Master', 'PM')
);

CREATE TABLE `account`(
	account_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    user_name VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    department_id INT NOT NULL,
    position_id INT NOT NULL,
    create_date DATE NOT NULL,
    FOREIGN KEY (department_id) REFERENCES department(department_id),
	FOREIGN KEY (position_id) REFERENCES `position`(position_id)
);

CREATE TABLE `group` (
	group_id INT PRIMARY KEY AUTO_INCREMENT,
    group_name VARCHAR(255) NOT NULL,
    creator_id INT NOT NULL,
    create_date DATE NOT NULL
);

CREATE TABLE group_account(
	group_id INT NOT NULL,
    account_id INT NOT NULL,
    join_date DATE NOT NULL,
    PRIMARY KEY (group_id,account_id),
    FOREIGN KEY (account_id) REFERENCES `account`(account_id),
    FOREIGN KEY (group_id) REFERENCES `group`(group_id)
);

CREATE TABLE type_question(
	type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name ENUM('Essay', 'Multiple-Choice')
);

CREATE TABLE category_question(
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR (50) NOT NULL
);

CREATE TABLE question(
	question_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    category_id INT NOT NULL,
    type_id INT NOT NULL,
    creator_id INT NOT NULL,
    create_date DATE NOT NULL,
    FOREIGN KEY (type_id) REFERENCES type_question(type_id) , 
    FOREIGN KEY (category_id) REFERENCES category_question (category_id) , 
    FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

CREATE TABLE answer(
	answer_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    question_id INT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    FOREIGN KEY (question_id) REFERENCES question (question_id)
);

CREATE TABLE exam(
	exam_id INT PRIMARY KEY AUTO_INCREMENT,
    `code` VARCHAR(50) NOT NULL,
    title TEXT NOT NULL,
    category_id INT NOT NULL,
    duration INT NOT NULL,
    creator_id INT NOT NULL,
    create_date DATE NOT NULL,
    FOREIGN KEY (category_id) REFERENCES  category_question (category_id) , 
    FOREIGN KEY (creator_id) REFERENCES `account`(account_id)
);

CREATE TABLE exam_question(
	exam_id INT NOT NULL,
    question_id INT NOT NULL,
    PRIMARY KEY (exam_id, question_id),
	FOREIGN KEY (exam_id) REFERENCES  exam(exam_id) , 
    FOREIGN KEY (question_id) REFERENCES question(question_id)
);






