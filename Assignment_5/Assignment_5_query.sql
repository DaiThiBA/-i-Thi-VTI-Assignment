USE testing_system;

-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
CREATE VIEW sale_employee AS
(
	SELECT *
    FROM `account`
    WHERE department_id  = (
		SELECT department_id
        FROM department
        WHERE lower(department_name) = 'sale'
    )
);

-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
CREATE VIEW view_Account_Join_MaxGroup AS (
	-- B3. Lấy thông tin account
	SELECT *
    FROM `account`
    WHERE account_id IN (
    -- B2. Tìm account_id có nhóm tham gia = kỉ lục (max)
    SELECT DISTINCT account_id 
    FROM group_account
	GROUP BY account_id
    HAVING COUNT(group_id) = (
    --  B1: Tìm kỉ lục số group tham gia của 1 account
		SELECT COUNT(group_id)
		FROM group_account
		GROUP BY account_id
		ORDER BY COUNT(group_id) DESC
		limit 1 )
    )
);

-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ
--             được coi là quá dài) và xóa nó đi
CREATE VIEW vw_question_content_toolong AS (
		SELECT * 
        FROM question
        WHERE CHAR_LENGTH(content) > 300
);
DROP VIEW vw_question_content_toolong;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
CREATE VIEW view_department_max_employee as (
	WITH 
		cte_count_employee_number AS (
			SELECT COUNT(a.account_id) AS emp_count
			FROM account a
			INNER JOIN department d ON d.department_id = a.department_id
			GROUP BY d.department_id
		),
		cte_max_employee_number AS (
			SELECT MAX(emp_count) AS max_emp
			FROM cte_count_employee_number
		)
	SELECT d.department_id, d.department_name, COUNT(a.account_id) AS number_of_employee
	FROM account a
	INNER JOIN department d ON d.department_id = a.department_id
	GROUP BY d.department_id, d.department_name
	HAVING COUNT(a.account_id) = (
		SELECT max_emp FROM cte_max_employee_number -- Đặt tên trường đã dùng hàm tổng hợp (count) trước khi query
	)
);

-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo.
CREATE VIEW view_questions_by_nguyen_users as (
	WITH cte_lastname_nguyen as
	(
		SELECT account_id  
		FROM `account`
		WHERE lower(full_name) LIKE 'nguyen%'
	)
	SELECT * 
	FROM question 
	WHERE creator_id IN (
		SELECT account_id 
		FROM cte_lastname_nguyen
	)
);

SELECT * FROM view_questions_by_nguyen_users
















