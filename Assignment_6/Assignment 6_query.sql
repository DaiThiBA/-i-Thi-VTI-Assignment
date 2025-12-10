USE testing_system;
/*=============================================================
Viết procedure, them các account chưa có trong group nào vào 1 group được truyền vào từ input
Nếu tất cả account đã ở trong group thì thông báo message “Tất cả account đã đc tham gia vào group”
=============================================================*/

/*=============================================================
 Question 1:
 Tạo store cho phép người dùng nhập vào tên phòng ban 
 và in ra tất cả các account thuộc phòng ban đó.
=============================================================*/
DROP PROCEDURE IF EXISTS sp_find_account_by_department;
DELIMITER $$
CREATE PROCEDURE sp_find_account_by_department(IN dept_name VARCHAR(50) ) 
BEGIN
	SELECT * 
    FROM `account`
    WHERE department_id IN (
		SELECT department_id 
        FROM department
        WHERE lower(department_name) = lower(dept_name)
    );
END $$
DELIMITER ;
-- CALL sp_find_account_by_department('Engineering');

/*=============================================================
 Question 2:
 Tạo store để in ra số lượng account trong mỗi group.
=============================================================*/

DROP PROCEDURE IF EXISTS sp_number_of_group_account;

DELIMITER $$
CREATE PROCEDURE sp_number_of_group_account ()
BEGIN
	SELECT g.group_id, g.group_name ,COUNT(ga.account_id) as number_of_account
	FROM group_account ga
	RIGHT JOIN `group` g
		ON ga.group_id = g.group_id
	GROUP BY group_id
    ORDER BY g.group_id;
END $$
DELIMITER ;

-- CALL sp_number_of_group_account();

/*=============================================================
 Question 3:
 Tạo store để thống kê mỗi type question có bao nhiêu 
 question được tạo trong tháng hiện tại.
=============================================================*/ 
DELIMITER $$

CREATE PROCEDURE sp_count_question_by_type_in_current_month()
BEGIN
    SELECT 
        t.type_id,
        t.type_name,
        COUNT(q.question_id) AS total_question
    FROM type_question t
    LEFT JOIN question q 
           ON q.type_id = t.type_id
          AND MONTH(q.create_date) = MONTH(CCURDATE())
          AND YEAR(q.create_date)  = YEAR(CURDATE())
    GROUP BY t.type_id, t.type_name;
END $$

DELIMITER ;


/*=============================================================
 Question 4:
 Tạo store để trả ra ID của type question có nhiều câu hỏi nhất.
=============================================================*/
DROP PROCEDURE IF EXISTS sp_get_most_type_question_id_used
DELIMITER $$
CREATE PROCEDURE sp_get_most_type_question_id_used ()
BEGIN 
	WITH cte_count_question_by_type as (
		SELECT COUNT(question_id ) as count_question
		FROM question 
		GROUP BY type_id 
	),
		cte_get_most_type_question_id_used as (
		SELECT type_id
		FROM question
		GROUP BY type_id
		HAVING COUNT(question_id) = (
			SELECT MAX(count_question) FROM cte_count_question_by_type
		)
	)
	SELECT type_id
	FROM cte_get_most_type_question_id_used;
END $$
DELIMITER ;

-- CALL sp_get_most_type_question_id_used();

/*=============================================================
 Question 5:
 Sử dụng store ở Question 4 để tìm ra tên của type question.
=============================================================*/
CALL sp_get_most_type_question_id_used();

/*=============================================================
 Question 6:
 Viết store nhập vào 1 chuỗi, và trả về:
   - group có tên chứa chuỗi đó
   - hoặc user có username chứa chuỗi đó
=============================================================*/

DELIMITER $$
CREATE PROCEDURE sp_find_name_by_group_or_user ( 
	IN search_taget VARCHAR(10),
    IN keyword VARCHAR(50)
) 
BEGIN 
	IF lower(search_taget) = 'user' THEN
		SELECT *
		FROM `account`
		WHERE lower(user_name) LIKE CONCAT('%', lower(keyword),'%');
    ELSEIF lower(search_taget) = 'group' THEN
		SELECT *
		FROM `group`
		WHERE lower(group_name) LIKE CONCAT('%', lower(keyword),'%');
	ELSE 
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'first parameter must be user or group';
    END IF;
END $$
DELIMITER ;
SELECT * FROM account;

-- call sp_find_name_by_group_or_user('user', 'f');
-- call sp_find_name_by_group_or_user('group', 'Devs');
-- call sp_find_name_by_group_or_user('gggg', 'Devs');

/*=============================================================
 Question 7:
 Viết store nhập vào fullName, email rồi tự động gán:
   - username = phần trước ký tự @ của email
   - positionID = developer (default)
   - departmentID = phòng chờ (default)
 Sau đó in ra kết quả tạo thành công.
=============================================================*/

DELIMITER $$
CREATE PROCEDURE sp_insert_account_by_name_and_email (
    IN p_fullName   VARCHAR(255),
    IN p_email      VARCHAR(255)
)
BEGIN
    DECLARE v_username VARCHAR(100);
    DECLARE v_position_id INT;
    DECLARE v_department_id INT;

    -- 1. Tách username từ email
    SET v_username = SUBSTRING_INDEX(p_email, '@', 1);


	-- 2. LẤY / TẠO POSITION 'Developer'

    SELECT position_id INTO v_position_id
    FROM `position`
    WHERE LOWER(position_name) = 'developer'
    LIMIT 1;

    -- Nếu chưa có thì tạo mới
    IF v_position_id IS NULL THEN
        INSERT INTO `position` (position_name)
        VALUES ('Developer');

        SELECT position_id INTO v_position_id
        FROM `position`
        WHERE LOWER(position_name) = 'developer'
        LIMIT 1;
    END IF;

	-- 3. LẤY / TẠO DEPARTMENT 'Phòng chờ'
    
    SELECT department_id INTO v_department_id
    FROM department
    WHERE LOWER(department_name) = 'phòng chờ'
    LIMIT 1;

    -- Nếu chưa có thì tạo mới
    IF v_department_id IS NULL THEN
        INSERT INTO department (department_name)
        VALUES ('Phòng chờ');

        SELECT department_id INTO v_department_id
        FROM department
        WHERE LOWER(department_name) = 'phòng chờ'
        LIMIT 1;
    END IF;

    INSERT INTO `account`(email,
        username,
        full_name,
        department_id,
        position_id,
        create_date
    )
    VALUES (
        p_email,
        v_username,
        p_fullName,
        v_department_id,
        v_position_id,
        CURDATE()
    );

    /*===========================================================
        5. Output message
    ===========================================================*/
    SELECT CONCAT('Tạo account thành công: ', v_username) AS message;

END $$

DELIMITER ;

/*=============================================================
 Question 8:
 Viết store nhập vào 'Essay' hoặc 'Multiple-Choice' 
 để thống kê câu hỏi thuộc loại đó có content dài nhất.
=============================================================*/

CREATE PROCEDURE sp_get_longest_content_by_type (
	IN in_type_name ENUM('Essay', 'Multiple-Choice')
)
BEGIN
	WITH cte_longest_content_character AS (
		SELECT * 
        FROM question
        WHERE CHAR_LENGTH(content) = (
			SELECT CHAR_LENGTH(content) as length_list
            FROM question
            WHERE type_id = (
				SELECT type_id 
				FROM 
				WHERE type_name = in_type_name
            )
        ) 
    )
END

/*=============================================================
 Question 9:
 Viết store cho phép người dùng xóa exam dựa vào examID.
=============================================================*/
DELIMITER $$
CREATE PROCEDURE sp_delete_exam_by_id (
	IN in_exam_id INT
)
BEGIN 
	DELETE 
	FROM exam_question
	WHERE exam_id = in_exam_id;
	DELETE 
	FROM exam
	WHERE exam_id = in_exam_id;
END $$
DELIMITER ;

-- CALL sp_delete_exam_by_id(1);

/*=============================================================
 Question 10:
 Tìm các exam được tạo từ 3 năm trước và xóa chúng 
 (sử dụng store của Question 9).
 Sau đó in ra số lượng record bị xóa trong các table liên quan.
=============================================================*/
DELIMITER $$
CREATE PROCEDURE sp_delete_old_exam()
BEGIN 
	DECLARE v_exam_id INT;
	DECLARE v_count_exam INT;
    DECLARE v_count_exam_question INT;
    DECLARE done INT DEFAULT FALSE;
    
    -- Cursor để duyệt từng exam
    DECLARE cur CURSOR FOR 
        SELECT exam_id FROM tmp_old_exam;
	
    -- Notfound set done = true
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Tạo temporary table lưu exam cần xoá
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_old_exam AS
    SELECT exam_id
    FROM exam
    WHERE YEAR(CURDATE()) - YEAR(create_date) > 3;

	-- Đếm exam_question liên quan
    SELECT COUNT(*) INTO v_count_exam_question
    FROM exam_question
    WHERE exam_id IN (SELECT exam_id FROM tmp_old_exam);

    -- Đếm số exam sẽ bị xoá
    SELECT COUNT(*) INTO v_count_exam
    FROM tmp_old_exam;
	
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_exam_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- CALL store Question 9
        CALL sp_delete_exam_by_id(v_exam_id);

    END LOOP;

    CLOSE cur;
    
    SELECT v_count_exam AS deleted_exam,
           v_count_exam_question AS deleted_exam_question;

    -- Xóa bảng tạm
    DROP TEMPORARY TABLE IF EXISTS tmp_old_exam;
END $$
DELIMITER ;

/*=============================================================
 Question 11:
 Viết store cho phép người dùng xóa phòng ban dựa vào tên phòng ban.
 Các account thuộc phòng ban đó sẽ chuyển sang phòng ban "chờ việc".
=============================================================*/
DELIMITER $$
CREATE PROCEDURE sp_delete_department_by_name (
	IN in_department_name VARCHAR(50)
)
BEGIN
	DECLARE v_waiting_dept_id INT;
    DECLARE v_department_id INT;
    
    -- Tìm id của chờ việc nếu đã có
    SELECT department_id
    INTO v_waiting_dept_id
    FROM department
    WHERE LOWER(department_name) = 'chờ việc'
    LIMIT 1;
    
    -- tạo record 'chờ việc' nếu chưa có
    IF v_waiting_dept_id IS NULL THEN
		INSERT INTO department (department_name)
        VALUES ('chờ việc');
    
		SELECT department_id
		INTO v_waiting_dept_id
        FROM department
		WHERE LOWER(department_name) = 'chờ việc'
		LIMIT 1;
    END IF;
    
    -- lấy id của department muốn xoá
    SELECT department_id
    INTO v_department_id
    FROM department
    WHERE LOWER(department_name) = lower(in_department_name)
    LIMIT 1;

	UPDATE `account`
    SET department_id = v_waiting_dept_id
    WHERE department_id = v_department_id;
    
    DELETE
    FROM department
    WHERE department_id = v_department_id;
END $$

DELIMITER ;

/*=============================================================
 Question 12:
 Viết store in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay.
=============================================================*/
DELIMITER $$
CREATE procedure sp_count_question_created_this_year()
BEGIN
SELECT 
    m.month_number,
    COUNT(q.question_id) AS total_questions
FROM 
    (SELECT 1 AS month_number UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 
     UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 
     UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12) m
LEFT JOIN question q
    ON m.month_number = MONTH(q.create_date)
    AND YEAR(q.create_date) = YEAR(CURDATE())
GROUP BY m.month_number
ORDER BY m.month_number;
END $$
DELIMITER ;

/*=============================================================
 Question 13:
 Viết store in ra số lượng câu hỏi của từng tháng trong 6 tháng gần đây.
 Nếu tháng nào không có dữ liệu thì in:
   "Không có câu hỏi nào trong tháng".
=============================================================*/

DELIMITER $$

CREATE PROCEDURE sp_question_last_6_months()
BEGIN
    -- Tạo danh sách 6 tháng gần nhất (tháng hiện tại và 5 tháng trước đó)
    WITH last6 AS (
        SELECT 
            MONTH(DATE_SUB(CURDATE(), INTERVAL 0 MONTH)) AS m,
            YEAR(DATE_SUB(CURDATE(), INTERVAL 0 MONTH)) AS y
        UNION
        SELECT MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)),
               YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
        UNION
        SELECT MONTH(DATE_SUB(CURDATE(), INTERVAL 2 MONTH)),
               YEAR(DATE_SUB(CURDATE(), INTERVAL 2 MONTH))
        UNION
        SELECT MONTH(DATE_SUB(CURDATE(), INTERVAL 3 MONTH)),
               YEAR(DATE_SUB(CURDATE(), INTERVAL 3 MONTH))
        UNION
        SELECT MONTH(DATE_SUB(CURDATE(), INTERVAL 4 MONTH)),
               YEAR(DATE_SUB(CURDATE(), INTERVAL 4 MONTH))
        UNION
        SELECT MONTH(DATE_SUB(CURDATE(), INTERVAL 5 MONTH)),
               YEAR(DATE_SUB(CURDATE(), INTERVAL 5 MONTH))
    )

    SELECT 
        CONCAT(l.m, '-', l.y) AS month_label,
        CASE 
            WHEN COUNT(q.question_id) = 0 
                THEN 'Không có câu hỏi nào trong tháng'
            ELSE CONCAT(COUNT(q.question_id), ' câu hỏi')
        END AS result
    FROM last6 l
    LEFT JOIN question q 
        ON MONTH(q.create_date) = l.m
       AND YEAR(q.create_date) = l.y
    GROUP BY l.m, l.y
    ORDER BY l.y DESC, l.m DESC;
END $$

DELIMITER ;




















