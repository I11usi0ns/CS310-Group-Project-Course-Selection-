DROP ProCedure if exists GeneratePlanWithTopoSort;
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
    DECLARE cur_course_id VARCHAR(20);
    DECLARE cur_title VARCHAR(20);
    DECLARE cur_semester_cursor VARCHAR(10);
    DECLARE cur_session_id_cursor VARCHAR(4);
    DECLARE cur_units_cursor numeric(4,1);
    DECLARE iteration_count INT DEFAULT 0; 
    DECLARE max_iterations INT;           
	DECLARE course_cursor CURSOR FOR
        SELECT title, course_id, semester, session_id, units
        FROM SortedCourses
        WHERE title NOT IN (SELECT DISTINCT title FROM Plan WHERE student_id = student_id);

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SET max_year = current_year + (4 - student_year);
    DROP TEMPORARY TABLE IF EXISTS TempCourses;

    CREATE TEMPORARY TABLE TempCourses AS
    SELECT c.course_id, c.title, c.semester, c.session_id, c.units
    FROM Courses c
    JOIN Courses_requirements r ON c.title = r.title
    Where c.units > 0 AND c.title NOT IN ('ETHLDR 201', 'GCHINA 101', 'GLOCHALL 201',
                      'EAP 101A', 'EAP 101B', 'EAP 102A', 'EAP 102B',
                      'CAPSTONE 495', 'CAPSTONE 496'); 
	-- mainly consider the major courses first;
    DROP TEMPORARY TABLE IF EXISTS PreGraph;
    CREATE TEMPORARY TABLE PreGraph AS
    SELECT p.id_first AS prerequisite, p.id_second AS dependent
    FROM Pre_requisite p
    WHERE EXISTS (
        SELECT 1 FROM TempCourses WHERE title = p.id_first OR title = p.id_second
    );
    -- Indegree
    
	DROP TEMPORARY TABLE IF EXISTS InDegree;
    CREATE TEMPORARY TABLE InDegree AS
    SELECT title, 0 AS degree
    FROM TempCourses;

    UPDATE InDegree
    SET degree = (
        SELECT COUNT(*)
        FROM PreGraph
        WHERE PreGraph.dependent = InDegree.title
    );

    DROP TEMPORARY TABLE IF EXISTS Queue;
    CREATE TEMPORARY TABLE Queue AS
    SELECT title
    FROM InDegree
    WHERE degree = 0;

    DROP TEMPORARY TABLE IF EXISTS SortedCourses;

    CREATE TEMPORARY TABLE SortedCourses AS
    SELECT * FROM TempCourses WHERE 1=0;
    -- empty but with same structure
    -- topo
	SELECT COUNT(*) * 2 INTO max_iterations FROM TempCourses;
	WHILE_LOOP: WHILE EXISTS (SELECT 1 FROM Queue) DO
		SET iteration_count = iteration_count + 1;
		IF iteration_count > max_iterations THEN
			LEAVE WHILE_LOOP; 
		END IF;

		SET @course = (SELECT title FROM Queue LIMIT 1);
		DELETE FROM Queue WHERE title = @course;
        
		INSERT INTO SortedCourses
		SELECT * FROM TempCourses WHERE title = @course;

		UPDATE InDegree
		SET degree = degree - 1
		WHERE title IN (SELECT dependent FROM PreGraph WHERE prerequisite = @course);

		CREATE TEMPORARY TABLE TempQueue AS
		SELECT title
		FROM InDegree
		WHERE degree = 0
		  AND title NOT IN (SELECT title FROM Queue)
		  AND title NOT IN (SELECT title FROM SortedCourses);
          
		INSERT INTO Queue
		SELECT title
		FROM TempQueue;

		DROP TEMPORARY TABLE TempQueue;
	END WHILE WHILE_LOOP;

    -- final plan dicision
	-- SELECT * FROM SortedCourses; 
    IF semester_part = 1 THEN
        SET cur_semester = 'Fall2024';
    ELSE
        SET cur_semester = 'Spring2025';
    END IF;
    SET max_year = 2024 + (5 - student_year);

    OPEN course_cursor;
    read_loop: LOOP
        FETCH course_cursor INTO cur_title, cur_course_id, cur_semester_cursor, cur_session_id_cursor, cur_units_cursor;
        IF done THEN
            LEAVE read_loop;
        END IF;
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
            IF NOT EXISTS (
                SELECT 1
                FROM courses_taken
                WHERE title = cur_title
            ) THEN
                IF NOT EXISTS (
                    SELECT 1
                    FROM Anti_requisite ar
                    JOIN Plan p ON p.title = ar.id_2
                    WHERE ar.id_1 = cur_title
                ) THEN
                    SELECT SUM(units) INTO current_units
                    FROM Plan
                    WHERE student_id = student_id
                      AND semester = cur_semester_cursor
                      AND session_id = cur_session_id_cursor;

                    IF (CAST(SUBSTRING(cur_semester_cursor, -4) AS UNSIGNED) <= max_year) AND (CAST(SUBSTRING(cur_semester_cursor, -4) AS UNSIGNED) >= min_year) THEN
                        IF current_units IS NULL OR current_units + cur_units_cursor <= 10 THEN
                            INSERT INTO Plan (student_id, course_id, title, semester, session_id, units)
                            VALUES (student_id, cur_course_id, cur_title, cur_semester_cursor, cur_session_id_cursor, cur_units_cursor);
                            SET current_units = current_units + cur_units_cursor;
                        ELSE
                            ITERATE read_loop;
                        END IF;
                    END IF;
                ELSE
                    ITERATE read_loop;
                END IF;
            END IF;
        END IF;
    END LOOP;
    CLOSE course_cursor;

    DROP TEMPORARY TABLE TempCourses;
    DROP TEMPORARY TABLE PreGraph;
    DROP TEMPORARY TABLE InDegree;
    DROP TEMPORARY TABLE Queue;
    DROP TEMPORARY TABLE SortedCourses;

END$$

DELIMITER ;