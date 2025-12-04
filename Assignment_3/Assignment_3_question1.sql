USE testing_system;

INSERT INTO department (department_name)
VALUES
('Engineering'),
('Quality Assurance'),
('Human Resources'),
('Product Management'),
('Scrum Office'),
('Marketing'),
('Finance'),
('IT Support'),
('Security'),
('Mobile Development'),
('Sale');

INSERT INTO `position` (position_name)
VALUES
('Dev'),
('Test'),
('Scrum Master'),
('PM');

INSERT INTO account (email, user_name, full_name, department_id, position_id, create_date)
VALUES
('alice@example.com', 'alice', 'Alice Nguyen', 1, 1, '2024-01-10'),
('bob@example.com', 'bob', 'Bob Tran', 2, 2, '2024-01-12'),
('charlie@example.com', 'charlie', 'Charlie Le', 3, 3, '2024-02-01'),
('david@example.com', 'david', 'David Do', 1, 1, '2024-02-15'),
('emma@example.com', 'darci', 'Darci Do', 4, 4, '2024-03-01'),
('frank@example.com', 'frank', 'Frank Vu', 2, 1, '2024-03-10'),
('grace@example.com', 'grace', 'Grace Hoang', 6, 2, '2024-03-15'),
('henry@example.com', 'henry', 'Henry Bui', 7, 1, '2024-03-20'),
('ivy@example.com', 'ivy', 'Ivy Phan', 2, 2, '2024-03-21'),
('jack@example.com', 'jack', 'Jack Lam', 9, 3, '2024-03-22');

INSERT INTO `group` (group_name, creator_id, create_date)
VALUES
('Backend Devs', 1, '2019-03-10'),
('Frontend Devs', 4, '2024-03-12'),
('Testing Team', 2, '2024-03-15'),
('Product Owners', 5, '2024-03-20'),
('Scrum Team A', 3, '2024-03-22'),
('DevOps Squad', 6, '2024-03-25'),
('Mobile Gang', 10, '2024-03-26'),
('QA Automation', 7, '2024-03-27'),
('Security Core', 9, '2024-03-28'),
('Support Heroes', 8, '2024-03-29');

INSERT INTO group_account (group_id, account_id, join_date)
VALUES
(1, 1, '2024-03-11'),
(1, 4, '2024-03-12'),
(2, 1, '2024-03-13'),
(3, 2, '2024-03-16'),
(5, 3, '2024-03-23'),
(6, 6, '2024-03-25'),
(7, 10, '2024-03-26'),
(8, 7, '2024-03-27'),
(9, 9, '2024-03-28'),
(10, 8, '2024-03-29');

INSERT INTO type_question (type_name)
VALUES
('Essay'),
('Multiple-Choice');

INSERT INTO category_question (category_name)
VALUES
('Java'),
('SQL'),
('Scrum'),
('Testing'),
('DevOps'),
('Networking'),
('Security'),
('Frontend'),
('Backend'),
('Mobile');

INSERT INTO question (content, category_id, type_id, creator_id, create_date)
VALUES
('What is Java Virtual Machine?', 1, 1, 1, '2024-04-01'),
('What is Primary Key?', 2, 2, 2, '2024-04-02'),
('Explain Scrum roles.', 3, 1, 3, '2024-04-03'),
('What is Unit Testing?', 4, 2, 4, '2024-04-04'),
('What is CI/CD?', 5, 2, 5, '2024-04-05'),
('Define TCP/IP model.', 6, 1, 6, '2024-04-06'),
('What is SQL Injection?', 7, 2, 7, '2024-04-07'),
('Explain React Virtual DOM.', 8, 1, 8, '2024-04-08'),
('What is REST API?', 9, 2, 9, '2024-04-09'),
('What is Android Activity?', 10, 1, 10, '2024-04-10');

INSERT INTO answer (content, question_id, is_correct)
VALUES
-- Question 1: JVM
('It is the engine that runs Java bytecode.', 1, TRUE),
('It is a database management system.', 1, FALSE),
('It is a Java text editor.', 1, FALSE),
('It is a hardware CPU for running Java.', 1, FALSE),

-- Question 2: Primary Key
('It uniquely identifies each record.', 2, TRUE),
('It allows duplicate values.', 2, FALSE),
('It is used only for sorting.', 2, FALSE),

-- Question 3: Scrum roles
('Scrum has 3 roles: PO, SM, Dev Team.', 3, TRUE),
('Scrum uses only one role: Project Manager.', 3, FALSE),
('Scrum has 5 roles including Tester and Designer.', 3, FALSE),

-- Question 4: Unit Testing
('A test that checks individual units of code.', 4, TRUE),
('A test of the entire system end-to-end.', 4, FALSE),
('A performance stress test.', 4, FALSE),

-- Question 5: CI/CD
('CI/CD automates build and deployment.', 5, TRUE),
('CI/CD is a type of database.', 5, FALSE),
('CI/CD is a frontend framework.', 5, FALSE),

-- Question 6: TCP/IP Model
('It is a networking reference model.', 6, TRUE),
('It is a Java library for networking.', 6, FALSE),
('It is a hardware router model.', 6, FALSE),

-- Question 7: SQL Injection
('A type of security attack.', 7, TRUE),
('A valid SQL syntax rule.', 7, FALSE),
('A data backup method.', 7, FALSE),
('A way to speed up queries.', 7, FALSE),

-- Question 8: React Virtual DOM
('A lightweight representation of DOM.', 8, TRUE),
('A type of backend database.', 8, FALSE),
('A CSS preprocessor.', 8, FALSE),

-- Question 9: REST API
('It is an architectural style.', 9, TRUE),
('It is a desktop application.', 9, FALSE),
('It is a type of MySQL table.', 9, FALSE),
('It is a programming language.', 9, FALSE),

-- Question 10: Android Activity
('It is a single screen in Android.', 10, TRUE),
('It is an Android database.', 10, FALSE),
('It is a network communication protocol.', 10, FALSE),
('It is a Java compiler.', 10, FALSE);

INSERT INTO exam (code, title, category_id, duration, creator_id, create_date)
VALUES
('EX-JAVA-01', 'Java Basics Quiz', 1, 45, 1, '2019-12-19'),
('EX-SQL-01', 'SQL Fundamentals Test', 2, 45, 2, '2024-05-02'),
('EX-SCRUM-01', 'Scrum Knowledge Check', 3, 20, 3, '2024-05-03'),
('EX-TEST-01', 'Testing Concepts Exam', 4, 75, 4, '2019-12-19'),
('EX-DEVOPS-01', 'CI/CD Exam', 5, 60, 5, '2019-12-19'),
('EX-NET-01', 'Networking Basics', 6, 25, 6, '2024-05-06'),
('EX-SEC-01', 'Security Essentials', 7, 75, 7, '2024-05-07'),
('EX-FRONT-01', 'Frontend Test', 8, 30, 8, '2024-05-08'),
('EX-BACK-01', 'Backend Exam', 9, 40, 9, '2024-05-09'),
('EX-MOB-01', 'Mobile Development Exam', 10, 20, 10, '2024-05-10');

INSERT INTO exam_question (exam_id, question_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
