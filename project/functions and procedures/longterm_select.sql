drop ProCedure if exists GeneratePlanWithTopoSort;
SET SQL_SAFE_UPDATES = 0;
use selection;
DELIMITER $$

CREATE PROCEDURE GeneratePlanWithTopoSort(
    IN student_id VARCHAR(20),
    IN student_year INT,
    IN semester_part INT
)
BEGIN
    DECLARE current_year INT DEFAULT 2024;
    DECLARE max_year INT;
    DECLARE min_year INT;
    DECLARE cur_units numeric(4,1) DEFAULT 0;
    DECLARE cur_session VARCHAR(4) DEFAULT '7W1';
    DECLARE cur_semester VARCHAR(10) DEFAULT 'Fall2024';
    DECLARE done INT DEFAULT 0;
    DECLARE current_units NUMERIC(4,1);
    
    -- 游标相关变量
    DECLARE cur_course_id VARCHAR(20);
    DECLARE cur_title VARCHAR(20);
    DECLARE cur_semester_cursor VARCHAR(10);
    DECLARE cur_session_id_cursor VARCHAR(4);
    DECLARE cur_units_cursor numeric(4,1);
	

    DECLARE iteration_count INT DEFAULT 0; -- 定义计数器
    DECLARE max_iterations INT;           -- 最大迭代次数

    -- 定义游标
	DECLARE course_cursor CURSOR FOR
        SELECT title, course_id, semester, session_id, units
        FROM SortedCourses
        WHERE title NOT IN (SELECT DISTINCT title FROM Plan WHERE student_id = student_id);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    

    
    -- 到这里还没有问题 
	-- 测试语句 看看有没有中止
    SET max_year = current_year + (4 - student_year);

    -- 排除
    DROP TEMPORARY TABLE IF EXISTS TempCourses;

    CREATE TEMPORARY TABLE TempCourses AS
    SELECT c.course_id, c.title, c.semester, c.session_id, c.units
    FROM Courses c
    JOIN Courses_requirements r ON c.title = r.title
    Where c.units > 0 AND c.title NOT IN ('ETHLDR 201', 'GCHINA 101', 'GLOCHALL 201',
                      'EAP 101A', 'EAP 101B', 'EAP 102A', 'EAP 102B',
                      'CAPSTONE 495', 'CAPSTONE 496'); -- 排除指定课程;
 --   LEFT JOIN Courses_taken ct ON c.course_id = ct.course_id
   -- WHERE ct.course_id IS NULL
     -- AND SUBSTRING(c.semester, 5, 4) BETWEEN current_year AND max_year
      -- AND (semester_part = 1 OR c.semester LIKE 'Spring%');

-- SELECT title from Tempcourses;

    DROP TEMPORARY TABLE IF EXISTS PreGraph;
    -- pre
    CREATE TEMPORARY TABLE PreGraph AS
    SELECT p.id_first AS prerequisite, p.id_second AS dependent
    FROM Pre_requisite p
    WHERE EXISTS (
        SELECT 1 FROM TempCourses WHERE title = p.id_first OR title = p.id_second
    );

	DROP TEMPORARY TABLE IF EXISTS InDegree;
    -- 入度
    CREATE TEMPORARY TABLE InDegree AS
    SELECT title, 0 AS degree
    FROM TempCourses;

    UPDATE InDegree
    SET degree = (
        SELECT COUNT(*)
        FROM PreGraph
        WHERE PreGraph.dependent = InDegree.title
    );

    -- set top
    DROP TEMPORARY TABLE IF EXISTS Queue;
    
    CREATE TEMPORARY TABLE Queue AS
    SELECT title
    FROM InDegree
    WHERE degree = 0;

    DROP TEMPORARY TABLE IF EXISTS SortedCourses;

    CREATE TEMPORARY TABLE SortedCourses AS
    SELECT * FROM TempCourses WHERE 1=0;

    -- 到这里还可以跑出来



-- 初始化最大迭代次数，根据 TempCourses 表中的课程数量设置合理值
SELECT COUNT(*) * 2 INTO max_iterations FROM TempCourses;



WHILE_LOOP: WHILE EXISTS (SELECT 1 FROM Queue) DO
    -- 中止条件检查
    SET iteration_count = iteration_count + 1;

    -- 记录迭代次数和 Queue 大小
    INSERT INTO DebugLog (log_message)
    VALUES (CONCAT('Iteration: ', iteration_count, ', Queue size: ', (SELECT COUNT(*) FROM Queue)));

    -- 如果达到最大迭代次数，则退出循环
    IF iteration_count > max_iterations THEN
        INSERT INTO DebugLog (log_message)
        VALUES ('Max iterations reached, exiting WHILE loop.');
        LEAVE WHILE_LOOP; -- 退出 WHILE 循环
    END IF;

    -- 从 Queue 中取出一个课程
    SET @course = (SELECT title FROM Queue LIMIT 1);
    DELETE FROM Queue WHERE title = @course;

    -- 将课程插入到 SortedCourses 表
    INSERT INTO SortedCourses
    SELECT * FROM TempCourses WHERE title = @course;

    -- 更新 InDegree 的入度
    UPDATE InDegree
    SET degree = degree - 1
    WHERE title IN (SELECT dependent FROM PreGraph WHERE prerequisite = @course);

    -- 将新的入度为 0 的课程加入 Queue
    CREATE TEMPORARY TABLE TempQueue AS
    SELECT title
    FROM InDegree
    WHERE degree = 0
      AND title NOT IN (SELECT title FROM Queue)
      AND title NOT IN (SELECT title FROM SortedCourses);

    -- 检查 TempQueue 的内容
    INSERT INTO DebugLog (log_message)
    VALUES (CONCAT('TempQueue size: ', (SELECT COUNT(*) FROM TempQueue)));

    -- 插入新的课程到 Queue
    INSERT INTO Queue
    SELECT title
    FROM TempQueue;

    -- 删除临时表
    DROP TEMPORARY TABLE TempQueue;
END WHILE WHILE_LOOP;
    -- 分配




	SELECT * FROM SortedCourses; 
    -- ， 还需要解决course taken的问题
    -- 并且需要满足所有选择的课程的时间小于最大年限
 -- 起始学期和最大年份
    IF semester_part = 1 THEN
        SET cur_semester = 'Fall2024';
    ELSE
        SET cur_semester = 'Spring2025';
    END IF;
    SET max_year = 2024 + (5 - student_year);

-- 打印出提取的年份
    

    -- 打开游标
    OPEN course_cursor;

    read_loop: LOOP
        FETCH course_cursor INTO cur_title, cur_course_id, cur_semester_cursor, cur_session_id_cursor, cur_units_cursor;
        IF done THEN
            LEAVE read_loop;
        END IF;
        -- 确保同一标题的课程不重复选择
        -- 先检查 Plan 表，确保当前 title 没有被选择
        SET max_year = 2024 + (5 - student_year);
        SET min_year = 2024;
		IF cur_semester_cursor LIKE 'Fall%' THEN
            SET max_year = max_year - 1;
        END IF;
		IF (cur_semester_cursor LIKE 'Fall%') AND (semester_part = 2) THEN
            SET min_year = min_year + 1;
        END IF;
        
        IF NOT EXISTS (
            SELECT 1
            FROM Plan
            WHERE title = cur_title
        ) THEN
            -- 然后检查 course_taken 表，确保该学生没有选过相同 title 的课程
            IF NOT EXISTS (
                SELECT 1
                FROM courses_taken
                WHERE title = cur_title
            ) THEN
                -- 检查 Anti_requisite 表，确保没有反向先修关系
                IF NOT EXISTS (
                    SELECT 1
                    FROM Anti_requisite ar
                    JOIN Plan p ON p.title = ar.id_2
                    WHERE ar.id_1 = cur_title
                ) THEN
                    -- 检查当前学期分数限制
                    SELECT SUM(units) INTO current_units
                    FROM Plan
                    WHERE student_id = student_id
                      AND semester = cur_semester_cursor
                      AND session_id = cur_session_id_cursor;

                    -- 确保课程不超过最大年份
                    IF (CAST(SUBSTRING(cur_semester_cursor, -4) AS UNSIGNED) <= max_year) AND (CAST(SUBSTRING(cur_semester_cursor, -4) AS UNSIGNED) >= min_year) THEN
                        -- 如果当前 session 总学分小于等于 10，则插入课程到 Plan 表
                        IF current_units IS NULL OR current_units + cur_units_cursor <= 10 THEN
                            INSERT INTO Plan (student_id, course_id, title, semester, session_id, units)
                            VALUES (student_id, cur_course_id, cur_title, cur_semester_cursor, cur_session_id_cursor, cur_units_cursor);

                            -- 更新当前学期的分数
                            SET current_units = current_units + cur_units_cursor;
                        ELSE
                            -- 继续遍历下一个 Session
                            ITERATE read_loop;
                        END IF;
                    END IF;
                ELSE
                    -- 如果存在反向先修关系，跳过插入
                    ITERATE read_loop;
                END IF;
            END IF;
        END IF;
    END LOOP;

    -- 关闭游标
    CLOSE course_cursor;



    DROP TEMPORARY TABLE TempCourses;
    DROP TEMPORARY TABLE PreGraph;
    DROP TEMPORARY TABLE InDegree;
    DROP TEMPORARY TABLE Queue;
    DROP TEMPORARY TABLE SortedCourses;

END$$

DELIMITER ;