-- 在程序开始时创建表
USE seLECtion;
DELIMITER $$

-- 删除已存在的表（如果有的话）
DROP TABLE IF EXISTS ranking;
DROP TABLE IF EXISTS vvi;
DROP TABLE IF EXISTS list1;
DROP TABLE IF EXISTS part;
DROP TABLE IF EXISTS temp;
DROP TABLE IF EXISTS temp_data;
DROP TABLE IF EXISTS choices1;
DROP TABLE IF EXISTS choices2;
DROP TABLE IF EXISTS pair;
DROP TABLE IF EXISTS choices;
DROP TABLE IF EXISTS pre1;


CREATE TABLE VVI(
	fir VARCHAR(20),
    sec VARCHAR(20),
    thi VARCHAR(20)
);
CREATE TABLE list1(
		course_id varchar(20),
	 type_id varchar(4), -- LEC/REC/LAB
     title varchar(20),
     semester varchar(10),
     session_id varchar(4),
     days varchar(12),
     start_time TIME,
     end_time TIME,
     status_number varchar(10),
	 instructor varchar(200),
     units numeric(2,1) check(units >= 0 and units <= 4)
);
	

CREATE TABLE pre1(
	id_1 varchar(20),
    id_2 varchar(20),
    id_or int
);

-- 创建普通表
CREATE TABLE ranking(
    fir VARCHAR(20),
    sec VARCHAR(20),
    thi VARCHAR(20)
);

CREATE TABLE part(
    fir1 VARCHAR(20),
    sec1 VARCHAR(20),
    fir2 VARCHAR(20),
    sec2 VARCHAR(20),
    fir3 VARCHAR(20),
    sec3 VARCHAR(20)
);

CREATE TABLE temp (
    course_id VARCHAR(20),
    PRIMARY KEY (course_id)
);

CREATE TABLE temp_data(
    course_id VARCHAR(20),
    title VARCHAR(20),
    start_time TIME,
    end_time TIME,
    days VARCHAR(20),
    units INT
);

CREATE TABLE choices1 (
    id INT,
    course_id VARCHAR(20),
    title VARCHAR(20)
);

CREATE TABLE choices2 (
    id INT,
    course_id VARCHAR(20),
    title VARCHAR(20)
);

CREATE TABLE pair (
    id1 VARCHAR(20),
    id2 VARCHAR(20)
);

CREATE TABLE choices (
    id1 INT,
    id2 INT
);


CALL func1('FALL2024','%MATH%');

-- 修改存储过程 check1
DROP PROCEDURE IF EXISTS check1;
CREATE PROCEDURE check1(IN idd INT)
BEGIN
    -- 所有变量声明
    DECLARE course_id VARCHAR(20);
    DECLARE title VARCHAR(20);
    DECLARE start_time TIME;
    DECLARE end_time TIME;
    DECLARE days VARCHAR(20);
    DECLARE judge INT DEFAULT TRUE;
    DECLARE x INT;
    DECLARE done INT DEFAULT FALSE;
    
    -- 游标声明
    DECLARE cur CURSOR FOR 
        SELECT course_id, title, start_time, end_time, days
        FROM temp_data;
    
    -- 处理程序声明
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET judge = FALSE;
        ROLLBACK;
    END;

    -- 存储过程主体
    TRUNCATE TABLE temp_data;
    
    START TRANSACTION;

    SELECT SUM(units) INTO x FROM temp_data;
    IF x > 10 THEN 
        SET judge = FALSE; 
    END IF;
    
	IF EXISTS (SELECT * FROM courses_to_be_taken WHERE semester = 'fall2024' AND session_id = '7w1')
    THEN SET judge = FALSE;
    END IF;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO course_id, title, start_time, end_time, days;
        IF done THEN
            LEAVE read_loop;
        END IF;
		TRUNCATE TABLE pre1;
		INSERT INTO pre1 (id_1,id_2,id_or)
			SELECT id_1,id_2,id_or
            FROM pre_requisite
            WHERE id_2 = title AND id_1 IN (SELECT courses_taken.title FROM courses_taken);

        IF EXISTS (
			SELECT *
            FROM pre_requisite
            WHERE id_2 = title AND id_or NOT IN (SELECT pre1.id_or FROM pre1)
        ) THEN
            SET judge = FALSE;
        END IF;

        IF EXISTS (
            SELECT id_1 
            FROM anti_requisite 
            WHERE id_2 = title
        ) THEN
            SET judge = FALSE;
        END IF;

        IF EXISTS (
            SELECT * 
            FROM courses 
            WHERE courses.course_id IN (SELECT course_id FROM temp)
              AND ((courses.start_time BETWEEN start_time AND end_time)
                OR (courses.end_time BETWEEN start_time AND end_time))
              AND (
                (FIND_IN_SET('Mo', days) > 0 AND FIND_IN_SET('Mo', courses.days) > 0)
                OR (FIND_IN_SET('Tu', days) > 0 AND FIND_IN_SET('Tu', courses.days) > 0)
                OR (FIND_IN_SET('We', days) > 0 AND FIND_IN_SET('We', courses.days) > 0)
                OR (FIND_IN_SET('Th', days) > 0 AND FIND_IN_SET('Th', courses.days) > 0)
                OR (FIND_IN_SET('Fr', days) > 0 AND FIND_IN_SET('Fr', courses.days) > 0)
              )
        ) THEN
            SET judge = FALSE;
        END IF;
    END LOOP;

    CLOSE cur;

    IF judge = TRUE THEN
        INSERT INTO choices1 (id, course_id, title)
        SELECT idd, course_id, title FROM temp;
    END IF;

    COMMIT;
END$$

-- 修改存储过程 check2
DROP PROCEDURE IF EXISTS check2;
CREATE PROCEDURE check2(IN idd INT)
BEGIN
    -- 所有变量声明
    DECLARE course_id VARCHAR(20);
    DECLARE title VARCHAR(20);
    DECLARE start_time TIME;
    DECLARE end_time TIME;
    DECLARE days VARCHAR(20);
    DECLARE judge INT DEFAULT TRUE;
    DECLARE x INT;
    DECLARE done INT DEFAULT FALSE;
    
    -- 游标声明
    DECLARE cur CURSOR FOR 
        SELECT course_id, title, start_time, end_time, days
        FROM temp_data;
    
    -- 处理程序声明
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET judge = FALSE;
        ROLLBACK;
    END;

    -- 存储过程主体
    TRUNCATE TABLE temp_data;
    
    START TRANSACTION;

    SELECT SUM(units) INTO x FROM temp_data;
    IF x > 10 THEN 
        SET judge = FALSE; 
    END IF;

	IF EXISTS (SELECT * FROM courses_to_be_taken WHERE semester = 'fall2024' AND session_id = '7w2')
    THEN SET judge = FALSE;
    END IF;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO course_id, title, start_time, end_time, days;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF EXISTS (
            SELECT id_1 
            FROM anti_requisite 
            WHERE id_2 = title
        ) THEN
            SET judge = FALSE;
        END IF;

        IF EXISTS (
            SELECT * 
            FROM courses 
            WHERE courses.course_id IN (SELECT course_id FROM temp)
              AND ((courses.start_time BETWEEN start_time AND end_time)
                OR (courses.end_time BETWEEN start_time AND end_time))
              AND (
                (FIND_IN_SET('Mo', days) > 0 AND FIND_IN_SET('Mo', courses.days) > 0)
                OR (FIND_IN_SET('Tu', days) > 0 AND FIND_IN_SET('Tu', courses.days) > 0)
                OR (FIND_IN_SET('We', days) > 0 AND FIND_IN_SET('We', courses.days) > 0)
                OR (FIND_IN_SET('Th', days) > 0 AND FIND_IN_SET('Th', courses.days) > 0)
                OR (FIND_IN_SET('Fr', days) > 0 AND FIND_IN_SET('Fr', courses.days) > 0)
              )
        ) THEN
            SET judge = FALSE;
        END IF;
    END LOOP;

    CLOSE cur;

    IF judge = TRUE THEN
        INSERT INTO choices2 (id, course_id, title)
        SELECT idd, course_id, title FROM temp;
    END IF;

    COMMIT;
END$$

-- 修改存储过程 listing1
DROP PROCEDURE IF EXISTS listing1;
CREATE PROCEDURE listing1(IN section VARCHAR(20))
BEGIN
    -- 所有变量声明
    DECLARE count INT DEFAULT 0;
    DECLARE c1 VARCHAR(20);
    DECLARE c2 VARCHAR(20);
    DECLARE c3 VARCHAR(20);
    DECLARE temp_fir VARCHAR(20);
    DECLARE temp_sec VARCHAR(20);
    DECLARE temp_thi VARCHAR(20);

    -- 存储过程主体
    TRUNCATE TABLE ranking;
    TRUNCATE TABLE part;

    INSERT INTO ranking(fir, sec, thi) 
    SELECT A.course_id, B.course_id, C.course_id
    FROM list1 AS A, list1 AS B, list1 AS C
    WHERE A.course_id != B.course_id AND C.course_id != B.course_id AND C.course_id != A.course_id
    AND A.type_id = 'LEC' AND B.type_id = 'LEC' AND C.type_id = 'LEC';

    INSERT INTO ranking(fir, sec) 
    SELECT A.course_id, B.course_id
    FROM list1 AS A, list1 AS B
    WHERE A.course_id != B.course_id
    AND A.type_id = 'LEC' AND B.type_id = 'LEC';
    
    INSERT INTO vvi SELECT * FROM ranking;

    WHILE EXISTS (SELECT * FROM ranking) DO
        SELECT fir, sec, thi INTO temp_fir, temp_sec, temp_thi FROM ranking LIMIT 1;
        SELECT title INTO c1 FROM list1 WHERE list1.course_id = temp_fir;
        SELECT title INTO c2 FROM list1 WHERE list1.course_id = temp_sec;
        SELECT title INTO c3 FROM list1 WHERE list1.course_id = temp_thi;

        INSERT INTO part(fir1, sec1, fir2, sec2, fir3, sec3)
        SELECT A.course_id, B.course_id, C.course_id, D.course_id, E.course_id, F.course_id
        FROM list1 AS A, list1 AS B, list1 AS C, list1 AS D, list1 AS E, list1 AS F
        WHERE A.title = c1 AND A.type_id = 'REC' AND B.type_id = 'LAB' AND B.title = c1 AND
              C.title = c2 AND C.type_id = 'REC' AND D.type_id = 'LAB' AND D.title = c2 AND
              E.title = c3 AND E.type_id = 'REC' AND F.type_id = 'LAB' AND F.title = c3;

        WHILE EXISTS (SELECT * FROM part) DO
            TRUNCATE TABLE temp;
            INSERT INTO temp(course_id) VALUES (temp_fir), (temp_sec), (temp_thi);
            INSERT INTO temp(course_id) SELECT fir1 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT sec1 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT sec2 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT fir2 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT sec3 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT fir3 FROM part LIMIT 1;

            DELETE FROM part LIMIT 1;
            SET count = count + 1;
            TRUNCATE TABLE temp_data;
		INSERT INTO temp_data
		SELECT course_id, title, start_time, end_time, days, units 
		FROM list1
		WHERE list1.course_id IN (SELECT temp.course_id FROM temp);
            CALL check1(count);
        END WHILE;

        DELETE FROM ranking LIMIT 1;
    END WHILE;

    TRUNCATE TABLE temp;
    TRUNCATE TABLE part;
    TRUNCATE TABLE ranking;
END$$
-- 修改存储过程 listing2
DROP PROCEDURE IF EXISTS listing2;
CREATE PROCEDURE listing2(IN section VARCHAR(20))
BEGIN
    -- 所有变量声明
    DECLARE count INT DEFAULT 0;
    DECLARE c1 VARCHAR(20);
    DECLARE c2 VARCHAR(20);
    DECLARE c3 VARCHAR(20);
    DECLARE temp_fir VARCHAR(20);
    DECLARE temp_sec VARCHAR(20);
    DECLARE temp_thi VARCHAR(20);

    -- 存储过程主体
    TRUNCATE TABLE ranking;
    TRUNCATE TABLE part;

    INSERT INTO ranking(fir, sec, thi) 
    SELECT A.course_id, B.course_id, C.course_id
    FROM list1 AS A, list1 AS B, list1 AS C
    WHERE A.course_id != B.course_id AND C.course_id != B.course_id AND C.course_id != A.course_id;

    INSERT INTO ranking(fir, sec) 
    SELECT A.course_id, B.course_id
    FROM list1 AS A, list1 AS B
    WHERE A.course_id != B.course_id;

    WHILE EXISTS (SELECT * FROM ranking) DO
        SELECT fir, sec, thi INTO temp_fir, temp_sec, temp_thi FROM ranking LIMIT 1;
        SELECT title INTO c1 FROM list1 WHERE list1.course_id = temp_fir;
        SELECT title INTO c2 FROM list1 WHERE list1.course_id = temp_sec;
        SELECT title INTO c3 FROM list1 WHERE list1.course_id = temp_thi;

        INSERT INTO part(fir1, sec1, fir2, sec2, fir3, sec3)
        SELECT A.course_id, B.course_id, C.course_id, D.course_id, E.course_id, F.course_id
        FROM list1 AS A, list1 AS B, list1 AS C, list1 AS D, list1 AS E, list1 AS F
        WHERE A.title = c1 AND A.type_id = 'REC' AND B.type_id = 'LAB' AND B.title = c1 AND
              C.title = c2 AND C.type_id = 'REC' AND D.type_id = 'LAB' AND D.title = c2 AND
              E.title = c3 AND E.type_id = 'REC' AND F.type_id = 'LAB' AND F.title = c3;

        WHILE EXISTS (SELECT * FROM part) DO
            TRUNCATE TABLE temp;
            INSERT INTO temp(course_id) VALUES (temp_fir), (temp_sec), (temp_thi);
            INSERT INTO temp(course_id) SELECT fir1 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT sec1 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT sec2 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT fir2 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT sec3 FROM part LIMIT 1;
            INSERT INTO temp(course_id) SELECT fir3 FROM part LIMIT 1;

            DELETE FROM part LIMIT 1;
            SET count = count + 1;
            TRUNCATE TABLE temp_data;
    INSERT INTO temp_data
    SELECT course_id, title, start_time, end_time, days, units 
    FROM list1
    WHERE list1.course_id IN (SELECT temp.course_id FROM temp);
            CALL check2(count);
        END WHILE;

        DELETE FROM ranking LIMIT 1;
    END WHILE;

    TRUNCATE TABLE temp;
    TRUNCATE TABLE part;
    TRUNCATE TABLE ranking;
END$$

-- 修改存储过程 func1
DROP PROCEDURE IF EXISTS func1;
CREATE PROCEDURE func1(IN semester VARCHAR(20), IN major VARCHAR(20))
BEGIN
    -- 所有变量声明
    DECLARE i INT;
    DECLARE j INT;
    DECLARE judge INT DEFAULT TRUE;
    DECLARE done INT DEFAULT FALSE;
    
    -- 处理程序声明
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET judge = FALSE;
        ROLLBACK;
    END;

    -- 存储过程主体
    START TRANSACTION;
    
    TRUNCATE TABLE list1;
    
    INSERT INTO list1
    SELECT *
    FROM courses
    WHERE courses.title NOT IN (SELECT title FROM courses_taken)
    AND courses.semester = semester AND courses.title LIKE major;
    
    -- 调用子存储过程Columns
    TRUNCATE TABLE choices;
    CALL listing1('7W1');
    CALL listing2('7W2');

    -- 获取最大ID值
    SELECT MAX(id) INTO i FROM choices1;

    WHILE i > 0 DO
        SELECT MAX(id) INTO j FROM choices2;

        WHILE j > 0 DO
            SET judge = TRUE;
            TRUNCATE TABLE pair;

            -- 检查同一课程
            INSERT INTO pair (id1, id2)
            SELECT choices1.title, choices2.title
            FROM choices1, choices2
            WHERE choices1.id = i AND choices2.id = j;

            IF EXISTS (SELECT * FROM pair WHERE id1 = id2) THEN 
                SET judge = FALSE; 
            END IF;

            -- 检查互斥课程
            IF EXISTS (
                SELECT * 
                FROM pair 
                JOIN anti_requisite 
                ON pair.id1 = anti_requisite.id_1 AND pair.id2 = anti_requisite.id_2
            ) THEN 
                SET judge = FALSE; 
            END IF;

            -- 检查先修要求
            TRUNCATE TABLE pair;
            TRUNCATE TABLE pre1;
            INSERT INTO pair (id1, id2)
            SELECT courses_taken.title, choices2.title
            FROM courses_taken, choices2
            WHERE choices2.id = j;

			INSERT INTO pre1 (id_1,id_2,id_or)
			SELECT id_1,id_2,id_or
            FROM pre_requisite
            WHERE pre_requisite.id_2 IN (SELECT id2 FROM pair)
                  AND pre_requisite.id_1 NOT IN (SELECT id1 FROM pair);

            IF EXISTS (
                SELECT * 
                FROM pre_requisite 
                WHERE pre_requisite.id_2 IN (SELECT id2 FROM pair)
                  AND pre_requisite.id_or NOT IN (SELECT id_or FROM pre1)
            ) THEN 
                SET judge = FALSE; 
            END IF;

            -- 检查必修课程
            IF EXISTS (
                SELECT *
                FROM courses_to_be_taken, choices1
                WHERE courses_to_be_taken.title NOT IN (SELECT id1 FROM pair) 
                AND courses_to_be_taken.title NOT IN (SELECT id2 FROM pair)
            ) THEN 
                SET judge = FALSE; 
            END IF;

            -- 如果所有检查都通过，插入选择结果
            IF judge = TRUE THEN
                INSERT INTO choices (id1, id2) VALUES (i, j);
            END IF;

            SET j = j - 1;
        END WHILE;

        SET i = i - 1;
    END WHILE;

    COMMIT;
END$$


-- 在程序末尾删除所有表
DELIMITER $$

    DROP TABLE IF EXISTS ranking;
    DROP TABLE IF EXISTS part;
    DROP TABLE IF EXISTS temp;
    DROP TABLE IF EXISTS temp_data;
    DROP TABLE IF EXISTS choices1;
    DROP TABLE IF EXISTS choices2;
    DROP TABLE IF EXISTS pair;
DROP TABLE IF EXISTS list1;
DROP TABLE IF EXISTS pre1;

DELIMITER ;

-- 在完成所有操作后调用cleanup
