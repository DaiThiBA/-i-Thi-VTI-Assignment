USE testing_system;

INSERT INTO department (department_name)
VALUES
('Engineering'),
('Quality Assurance'),
('Human Resources'),
('Product Management'),
('Scrum Office');

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
('david@example.com', 'david', 'David Pham', 1, 1, '2024-02-15'),
('emma@example.com', 'emma', 'Emma Do', 4, 4, '2024-03-01');

INSERT INTO `group` (group_name, creator_id, create_date)
VALUES
('Backend Devs', 1, '2024-03-10'),
('Frontend Devs', 4, '2024-03-12'),
('Testing Team', 2, '2024-03-15'),
('Product Owners', 5, '2024-03-20'),
('Scrum Team A', 3, '2024-03-22');

INSERT INTO group_account (group_id, account_id, join_date)
VALUES
(1, 1, '2024-03-11'),
(1, 4, '2024-03-12'),
(2, 1, '2024-03-13'),
(3, 2, '2024-03-16'),
(5, 3, '2024-03-23');

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
('DevOps');

INSERT INTO question (content, category_id, type_id, creator_id, create_date)
VALUES
('What is Java Virtual Machine?', 1, 1, 1, '2024-04-01'),
('What is Primary Key?', 2, 2, 2, '2024-04-02'),
('Explain Scrum roles.', 3, 1, 3, '2024-04-03'),
('What is Unit Testing?', 4, 2, 4, '2024-04-04'),
('What is CI/CD?', 5, 2, 5, '2024-04-05');

INSERT INTO answer (content, question_id, is_correct)
VALUES
('It is the engine that runs Java bytecode.', 1, TRUE),
('It stores data uniquely.', 2, TRUE),
('Scrum has 3 roles: PO, SM, Dev Team.', 3, TRUE),
('A test that checks individual units of code.', 4, TRUE),
('CI/CD automates build and deployment.', 5, TRUE);

INSERT INTO exam (code, title, category_id, duration, creator_id, create_date)
VALUES
('EX-JAVA-01', 'Java Basics Quiz', 1, 30, 1, '2024-05-01'),
('EX-SQL-01', 'SQL Fundamentals Test', 2, 45, 2, '2024-05-02'),
('EX-SCRUM-01', 'Scrum Knowledge Check', 3, 20, 3, '2024-05-03'),
('EX-TEST-01', 'Testing Concepts Exam', 4, 40, 4, '2024-05-04'),
('EX-DEVOPS-01', 'CI/CD Exam', 5, 30, 5, '2024-05-05');

INSERT INTO exam_question (exam_id, question_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);