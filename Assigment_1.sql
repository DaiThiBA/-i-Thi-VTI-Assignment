CREATE DATABASE testing_system;

USE testing_system;

CREATE TABLE department(
	department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50)
);

CREATE TABLE `position`(
	position_id INT PRIMARY KEY AUTO_INCREMENT,
    position_name ENUM('Dev', 'Test','Scrum Master', 'PM')
);

CREATE TABLE account(
	account_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255),
    user_name VARCHAR(255),
    full_name VARCHAR(255),
    department_id INT NOT NULL,
    position_id INT NOT NULL,
    create_date DATE
);

CREATE TABLE `group` (
	group_id INT PRIMARY KEY AUTO_INCREMENT,
    group_name VARCHAR(255),
    creator_id INT NOT NULL,
    create_date DATE
);

CREATE TABLE group_account(
	group_id INT NOT NULL,
    account_id INT NOT NULL,
    join_date DATE,
    PRIMARY KEY (group_id,account_id)
);

CREATE TABLE type_question(
	type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name ENUM('Essay', 'Mutiple-Choice')
);

CREATE TABLE category_question(
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR (50)
);

CREATE TABLE question(
	question_id INT AUTO_INCREMENT,
    content TEXT,
    category_id INT NOT NULL,
    type_id INT NOT NULL,
    creator_id INT NOT NULL,
    create_date DATE
);

CREATE TABLE answer(
	answer_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT,
    question_id INT NOT NULL,
    is_correct BOOLEAN
);

CREATE TABLE exam(
	exam_id INT PRIMARY KEY AUTO_INCREMENT,
    `code` VARCHAR(50) NOT NULL,
    title TEXT,
    category_id INT NOT NULL,
    duration INT,
    creator_id INT NOT NULL,
    create_date DATE
);

CREATE TABLE exam_question(
	exam_id INT NOT NULL,
    question_id INT NOT NULL,
    PRIMARY KEY (exam_id, question_id)
);

/*
Vấn đề
position và group trùng với keyword trong mysql
tên table type_question, category_question nên đổi lại
Mô tả đề: Table 10 exam.categoryId định danh của chủ đề thi có nghĩa là gì?
thời gian thi không có đơn vị
*/
