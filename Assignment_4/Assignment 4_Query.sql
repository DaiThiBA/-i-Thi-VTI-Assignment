USE testing_system;

-- 1. Join.
-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT * 
FROM `account` a
INNER JOIN department d
	ON a.department_id = d.department_id;
    
-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT *
FROM  `account`
WHERE create_date >  '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT *
FROM `account` a
INNER JOIN `position` p
	on a.position_id = p.position_id
WHERE lower(position_name) = 'dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT d.department_id, COUNT(a.account_id) as number_of_employee
FROM `account` a
INNER JOIN department d
    ON d.department_id = a.department_id
GROUP BY d.department_id
HAVING COUNT(a.account_id) >= 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT q.question_id, COUNT(exam_id)
FROM question q
INNER JOIN exam_question exq
	ON q.question_id = exq.question_id
GROUP BY q.question_id;

-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT ct.category_id, category_name, COUNT(q.question_id) as number_of_question
FROM category_question ct
INNER JOIN question q
	ON ct.category_id = q.category_id
GROUP BY category_id, category_name
ORDER BY category_id;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT q.question_id,  q.content, COUNT(exq.exam_id) as number_of_used
FROM question q
INNER JOIN exam_question exq
	ON q.question_id  = exq.question_id 
GROUP BY  q.question_id,  q.content; 

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT q.question_id, q.content, COUNT(a.answer_id) as number_of_answer
FROM question q
INNER JOIN answer a
	ON q.question_id = a.question_id
GROUP BY q.question_id, content
HAVING COUNT(a.answer_id) = (
	SELECT COUNT(answer_id)
    FROM answer
    GROUP BY question_id
    ORDER BY COUNT(a.answer_id) DESC
    LIMIT 1
);
-- Question 9: Thống kê số lượng account trong mỗi group  `group` join (group_account)  
SELECT g.group_id, group_name, COUNT(ga.account_id) as number_of_account
FROM `group` g
INNER JOIN group_account ga
	ON g.group_id = ga.group_id
GROUP BY  g.group_id, group_name
ORDER BY g.group_id;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT a.position_id, p.position_name, COUNT(account_id) as number_of_employee
FROM account a
INNER JOIN `position` p
	ON a.position_id = p.position_id
GROUP BY position_id, p.position_name
HAVING COUNT(account_id) = (
	SELECT COUNT(account_id)
	FROM account
	GROUP BY position_id
	ORDER BY COUNT(account_id)
	LIMIT 1
);

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT d.department_id, d.department_name, p.position_name, COUNT(account_id) as number_of_employee
FROM account a
INNER JOIN department d
	ON a.department_id = d.department_id
INNER JOIN `position` p
	ON a.position_id = p.position_id
GROUP BY d.department_id, d.department_name, p.position_name
ORDER BY d.department_id;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question(q.content), loại câu hỏi (q.type_id) type_question.type_name, ai là người tạo ra câu hỏi (creator_id), câu trả lời là gì (answer.content), …
SELECT q.content as question_content , tq.type_name, acc.user_name as creator_name , a.content as answer_content
FROM question q
INNER JOIN type_question tq
	ON q.type_id = tq.type_id
INNER JOIN account acc
	ON acc.account_id = q.creator_id
INNER JOIN answer a
	ON a.question_id = q.question_id;

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm (question, Type
SELECT tq.type_id, type_name, COUNT(q.question_id) as number_of_question
FROM type_question tq
INNER JOIN question q
	ON tq.type_id = q.type_id
GROUP BY tq.type_id, type_name;

-- Question 14:Lấy ra group không có account nào
SELECT DISTINCT (g.group_id) , g.group_name
FROM `group` g
LEFT JOIN group_account ga
	ON g.group_id = ga.group_id
WHERE g.group_id NOT IN (
	SELECT DISTINCT group_id
    FROM group_account
);

-- Question 15: Lấy ra group không có account nào (Bị Trùng câu 15)

-- Question 16: Lấy ra question không có answer nào.
SELECT DISTINCT (q.question_id ) , q.content 
FROM question q
LEFT JOIN answer a
	ON q.question_id = a.question_id
WHERE q.question_id NOT IN (
	SELECT DISTINCT question_id 
    FROM answer
);
-- 2. Union.
		-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
SELECT *
FROM `account`
WHERE department_id = 1;
-- b) Lấy các account thuộc nhóm thứ 2
SELECT *
FROM `account`
WHERE department_id = 2;

-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT *
FROM `account`
WHERE department_id = 1
UNION
SELECT *
FROM `account`
WHERE department_id = 2;
    
-- Question 18:
	-- a) Lấy các group có lớn hơn 5 thành viên
SELECT *
FROM `group`
WHERE group_id IN (
	SELECT group_id
    FROM group_account
    GROUP BY group_id
    HAVING COUNT(account_id) > 5
);

-- b) Lấy các group có nhỏ hơn 7 thành viên
SELECT *
FROM `group`
WHERE group_id IN (
	SELECT group_id
    FROM group_account
    GROUP BY group_id
    HAVING COUNT(account_id) > 7
);
	-- c) Ghép 2 kết quả từ câu a) và câu b).
SELECT *
FROM `group`
WHERE group_id IN (
	SELECT group_id
    FROM group_account
    GROUP BY group_id
    HAVING COUNT(account_id) > 5
)
UNION ALL
SELECT *
FROM `group`
WHERE group_id IN (
	SELECT group_id
    FROM group_account
    GROUP BY group_id
    HAVING COUNT(account_id) > 7
);