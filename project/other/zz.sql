USE selection;
SET SESSION max_sp_recursion_depth = 100;

DELIMITER $$

DROP VIEW IF EXISTS list1;

CREATE temporary table list1 AS 
SELECT * 
FROM courses
WHERE courses.semester = 'Fall2024'
  AND find_in_set('COMPSCI',courses.title) > 0
  AND courses.type_id = 'lec' 
  AND courses.title NOT IN (
    SELECT courses_taken.title
    FROM courses_taken
);

DROP TABLE IF EXISTS ranking;
    CREATE TEMPORARY TABLE ranking(
		fir varchar(20),
        sec varchar(20),
        thi varchar(20)
    );
    DROP TABLE IF EXISTS part;
    CREATE TEMPORARY TABLE part(
		fir1 varchar(20),
        sec1 varchar(20),
        fir2 varchar(20),
        sec2 varchar(20),
        fir3 varchar(20),
        sec3 varchar(20)
    );

-- 更新表，为新列赋值递增整数
UPDATE list1 SET idd = (@rownum := @rownum + 1) ORDER BY course_id;

DROP TEMPORARY TABLE IF EXISTS temp;

CREATE TEMPORARY TABLE temp (
    course_id VARCHAR(20),
    PRIMARY KEY (course_id)  -- 修正了大小写
);


  DROP TEMPORARY TABLE IF EXISTS temp_data;
  CREATE TEMPORARY TABLE temp_data(
	course_id varchar(20),
    title varchar(20),
    start_time TIME,
    end_time TIME,
    days, varchar(20),
    units int
  );

drop procedure if exists listing1;

-- 将函数修改为存储过程，并移除 RETURN 语句

CREATE PROCEDURE listing1(IN section VARCHAR(20))
BEGIN
    DECLARE count INT DEFAULT 0;
	DECLARE c1 varchar(20);
    DECLARE c3 varchar(20);
    DECLARE c2 varchar(20);
	
	INSERT INTO ranking(fir,sec,thi) (
		SELECT A.course_id,B.course_id,C.course_id
        FROM courses AS A, courses AS B, courses AS C
        WHERE A.course_id != B.course_id,C.course_id != B.course_id,C.course_id != A.course_id);
     
	INSERT INTO ranking(fir,sec) (
		SELECT A.course_id,B.course_id
        FROM courses AS A, courses AS B
        WHERE A.course_id != B.course_id);   
    while exists (select * from ranking) DO
        
        SELECT title into c1 from list1 WHERE list1.course_id = (SELECT fir from ranking limit 1);
        
        SELECT title into c2 from list1 WHERE list1.course_id = (SELECT sec from ranking limit 1);
        	
        SELECT title into c3 from list1 WHERE list1.course_id = (SELECT thi from ranking limit 1);
        
        INSERT INTO part(fir1,sec1,fir2,sec2,fir3,sec3)
        SELECT A.course_id,B.course_id,C.course_id,D.course_id,E.course_id,F.course_id
        FROM list1 as A, list1 as B,list1 as C,list1 as D,list1 as E,list1 as F
        WHERE A.title = c1 AND A.type_id = 'rec' AND B.type_id = 'lab' AND B.title = c1 AND
        C.title = c2 AND C.type_id = 'rec' AND D.type_id = 'lab' AND D.title = c2 AND
        E.title = c3 AND E.type_id = 'rec' AND F.type_id = 'lab' AND F.title = c3;
        
        WHILE EXISTS (SELECT * FROM part) DO
			delete from temp;
			INSERT INTO temp(course_id) (SELECT fir FROM ranking limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec FROM ranking limit 1);
        
			INSERT INTO temp(course_id) (SELECT thi FROM ranking limit 1);
        
			INSERT INTO temp(course_id) (SELECT fir1 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec1 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec2 FROM part limit 1);
			
            INSERT INTO temp(course_id) (SELECT fir2 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec3 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT fir3 FROM part limit 1);
            
			delete from part limit 1;
            SET count = count + 1;
            CALL check1(count);
        END WHILE;
        
		delete from ranking limit 1;
    END WHILE;
    delete from temp;
    delete from part;
    delete from ranking;
END$$
drop table if exists choices1;

CREATE TEMPORARY TABLE choices1 (
    id INT,
    course_id VARCHAR(20),
    title VARCHAR(20)
);

drop procedure if exists check1;
-- 将函数修改为存储过程，并移除 RETURN 语句

CREATE PROCEDURE check1(IN idd INT)
BEGIN
    DECLARE course_id VARCHAR(20);
    DECLARE title VARCHAR(20);
    DECLARE start_time TIME;
    DECLARE end_time TIME;
    DECLARE days VARCHAR(20);
    DECLARE judge INT DEFAULT TRUE;
    INSERT INTO temp_data
    SELECT course_id, title,start_time,end_time,days,units FROM list1
    WHERE list1.course_id in (select temp.course_id from temp);
	
    IF (SELECT SUM(units) FROM temp_data) > 10 then set judge = false; end if;
    
    WHILE EXISTS (SELECT 1 FROM temp_data) DO
        SELECT course_id, title, start_time,end_time,days
        INTO course_id, title,start_time,end_time,days
        FROM temp_data
        LIMIT 1;

        -- 删除已处理的记录
        DELETE FROM temp_data WHERE temp_data.course_id = course_id;

        IF EXISTS (
            SELECT id_1 
            FROM pre_requisite 
            WHERE id_2 = title 
              AND id_1 NOT IN (SELECT courses_taken.title FROM courses_taken)
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
    END while;

    IF judge = TRUE THEN
        INSERT INTO choices1 (id, course_id, title)
        SELECT idd, course_id, title FROM temp;
    END IF;
END$$

-- 继续按照相同的方式修改 listing2 和 check2 存储过程

drop table if exists choices2;

-- 创建其他必要的表和过程
CREATE TEMPORARY TABLE choices2 (
    id INT,
    course_id VARCHAR(20),
    title VARCHAR(20)
);


drop procedure if exists listing2;

CREATE PROCEDURE listing2(IN section VARCHAR(20))
BEGIN
    DECLARE count INT DEFAULT 0;
	DECLARE c1 varchar(20);
    DECLARE c3 varchar(20);
    DECLARE c2 varchar(20);
	
	INSERT INTO ranking(fir,sec,thi) (
		SELECT A.course_id,B.course_id,C.course_id
        FROM courses AS A, courses AS B, courses AS C
        WHERE A.course_id != B.course_id,C.course_id != B.course_id,C.course_id != A.course_id);
     
	INSERT INTO ranking(fir,sec) (
		SELECT A.course_id,B.course_id
        FROM courses AS A, courses AS B
        WHERE A.course_id != B.course_id);   
    while exists (select * from ranking) DO
        
       SELECT title into c1 from list1 WHERE list1.course_id = (SELECT fir from ranking limit 1);
        
        SELECT title into c2 from list1 WHERE list1.course_id = (SELECT sec from ranking limit 1);
        	
        SELECT title into c3 from list1 WHERE list1.course_id = (SELECT thi from ranking limit 1);
        
        INSERT INTO part(fir1,sec1,fir2,sec2,fir3,sec3)
        SELECT A.course_id,B.course_id,C.course_id,D.course_id,E.course_id,F.course_id
        FROM list1 as A, list1 as B,list1 as C,list1 as D,list1 as E,list1 as F
        WHERE A.title = c1 AND A.type_id = 'rec' AND B.type_id = 'lab' AND B.title = c1 AND
        C.title = c2 AND C.type_id = 'rec' AND D.type_id = 'lab' AND D.title = c2 AND
        E.title = c3 AND E.type_id = 'rec' AND F.type_id = 'lab' AND F.title = c3;
        
        WHILE EXISTS (SELECT * FROM part) DO
			delete from temp;
			INSERT INTO temp(course_id) (SELECT fir FROM ranking limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec FROM ranking limit 1);
        
			INSERT INTO temp(course_id) (SELECT thi FROM ranking limit 1);
        
			INSERT INTO temp(course_id) (SELECT fir1 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec1 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec2 FROM part limit 1);
			
            INSERT INTO temp(course_id) (SELECT fir2 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT sec3 FROM part limit 1);
        
			INSERT INTO temp(course_id) (SELECT fir3 FROM part limit 1);
            
			delete from part limit 1;
            SET count = count + 1;
            CALL check2(count);
        END WHILE;
        
		delete from ranking limit 1;
    END WHILE;
    delete from temp;
    delete from part;
    delete from ranking;
END$$

drop procedure if exists check2;

CREATE PROCEDURE check2(IN idd INT)
BEGIN
	DECLARE course_id VARCHAR(20);
    DECLARE title VARCHAR(20);
    DECLARE start_time TIME;
    DECLARE end_time TIME;
    DECLARE days VARCHAR(20);
    DECLARE judge INT DEFAULT TRUE;
    INSERT INTO temp_data
	SELECT course_id, title,start_time,end_time,days,units FROM list1
    WHERE list1.course_id in (select temp.course_id from temp);
	
    IF (SELECT SUM(units) FROM temp_data) > 10 then set judge = false; end if;

    WHILE EXISTS (SELECT 1 FROM temp_data) DO
        SELECT course_id, title, start_time,end_time,days
        INTO course_id, title,start_time,end_time,days
        FROM temp_data
        LIMIT 1;

        -- 删除已处理的记录
        DELETE FROM temp_data WHERE temp_data.course_id = course_id;

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
    END while;

    IF judge = TRUE THEN
        INSERT INTO choices2 (id, course_id, title)
        SELECT idd, course_id, title FROM temp;
    END IF;


END$$

drop table if exists choices;

CREATE TEMPORARY TABLE choices (
    id1 INT,
    id2 INT
);

drop procedure if exists func1;

            DROP TEMPORARY TABLE IF EXISTS pair;  -- 添加了删除临时表的语句

            CREATE TEMPORARY TABLE pair (
                id1 VARCHAR(20),
                id2 VARCHAR(20)
            );

CREATE PROCEDURE func1(IN semester VARCHAR(20))
BEGIN
    CALL listing1('7W1');
    CALL listing2('7W2');

    DECLARE i INT;
    DECLARE j INT;
    DECLARE judge INT DEFAULT TRUE;

    SELECT MAX(id) INTO i FROM choices1;

    WHILE i > 0 DO
        SELECT MAX(id) INTO j FROM choices2;

        WHILE j > 0 DO
			set judge = true;
            delete from pair;

            INSERT INTO pair (id1, id2)
            SELECT choices1.title, choices2.title
            FROM choices1, choices2
            WHERE choices1.id = i AND choices2.id = j;

            IF EXISTS (SELECT * FROM pair WHERE id1 = id2) THEN SET judge = FALSE; END IF;
            IF EXISTS (
                SELECT * 
                FROM pair 
                JOIN anti_requisite 
                ON pair.id1 = anti_requisite.id_1 AND pair.id2 = anti_requisite.id_2
            ) THEN SET judge = FALSE; END IF;

            INSERT INTO pair (id1, id2)
            SELECT courses_taken.title, choices2.title
            FROM courses_taken, choices2
            WHERE choices2.id = j;

            IF EXISTS (
                SELECT * 
                FROM pre_requisite 
                WHERE pre_requisite.id_2 IN (SELECT id2 FROM pair)
                  AND pre_requisite.id_1 NOT IN (SELECT id1 FROM pair)
            ) THEN SET judge = FALSE; END IF;
            SET j = j - 1;
            
		IF EXISTS (
			SELECT *
            FROM courses_to_be_taken,choices1
            where courses_to_be_taken.title not in (select id1 from pair) 
            and courses_to_be_taken.title not in (select id2 from pair)
        ) 
        then judge = false;
        END IF;
        IF judge = TRUE THEN
            INSERT INTO choices (id1, id2) VALUES (i, j);  -- 添加了 VALUES 子句
        END IF;
        END WHILE;
        set i = i - 1;
    END WHILE;
END $$

drop table if exists list1;

DELIMITER ;
