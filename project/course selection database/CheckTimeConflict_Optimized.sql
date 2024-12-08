-- Schedule: Stores available time point of classes in a week
--           and whether the time point is occupied. 

DROP TABLE IF EXISTS Schedule;
CREATE TABLE Schedule (
    day_of_week VARCHAR(2),  -- Mo, Tu, We, Th
    time_point TIME,         
    occupied BOOLEAN DEFAULT 0,  -- 0: unoccupied, 1: occupied
    PRIMARY KEY (day_of_week, time_point)
);

-- SortedCourses：Information of courses that has been sorted
-- 				  in previous process.

DROP TABLE IF EXISTS SortedCourses;
CREATE TABLE IF NOT EXISTS SortedCourses (
    course_id VARCHAR(20),     
    title VARCHAR(100),        
    semester VARCHAR(10),      
    session_id VARCHAR(4),    
    days VARCHAR(12),          -- (e.g., MoTuWeTh)
    start_time TIME,
    end_time TIME,        
    PRIMARY KEY (course_id)
);

-- PlanA: Stores the selection result of time conflict check.

DROP TABLE IF EXISTS PlanA;
CREATE TABLE IF NOT EXISTS PlanA (
    student_id VARCHAR(20),    
    course_id VARCHAR(20),     
    title VARCHAR(100),        
    semester VARCHAR(10),      
    session_id VARCHAR(4),     
    days VARCHAR(12),          -- (e.g., MoTuWeTh)
    start_time TIME,         
    end_time TIME,         
    PRIMARY KEY (student_id, course_id, semester, session_id)
);

DELIMITER $$

-- Procedure GenerateSchedule: generate available time point
-- 							   of classes in a week.

DROP PROCEDURE IF EXISTS GenerateSchedule;
CREATE PROCEDURE GenerateSchedule()
BEGIN
    DECLARE start_time TIME DEFAULT '08:30:00';
    DECLARE end_time TIME DEFAULT '20:30:00';
    DECLARE current_time_point TIME;

    -- initialize current_time_point 
    SET current_time_point = start_time;

    -- iterate time points and insert them into Schedule
    WHILE current_time_point <= end_time DO
        INSERT INTO Schedule (day_of_week, time_point)
        VALUES
            ('Mo', current_time_point),  
            ('Tu', current_time_point),  
            ('We', current_time_point),  
            ('Th', current_time_point);  

        -- set current_time_point to 15 minutes later
        SET current_time_point = ADDTIME(current_time_point, '00:15:00');
    END WHILE;
END
$$

DELIMITER ;

CALL GenerateSchedule();

DELIMITER $$

-- Procedure CheckTimeConflict: Check time conflict of courses and insert valid courses.

DROP PROCEDURE IF EXISTS CheckTimeConflict;
CREATE PROCEDURE CheckTimeConflict()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cur_course_id VARCHAR(20); 
    DECLARE cur_title VARCHAR(100); 
    DECLARE cur_semester VARCHAR(10); 
    DECLARE cur_session_id VARCHAR(4); 
    DECLARE cur_days VARCHAR(12);  -- e.g., MoTuWeTh
    DECLARE cur_start_time TIME; 
    DECLARE cur_end_time TIME; 
    DECLARE current_time_point TIME; 
    DECLARE conflict BOOLEAN; 

    -- cursor course_cursor: get course information in SortedCourses
    DECLARE course_cursor CURSOR FOR
        SELECT course_id, title, semester, session_id, days, start_time, end_time
        FROM SortedCourses;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN course_cursor;

    -- iterate over courses in SortedCourses and check time conflict
    read_loop: LOOP
        FETCH course_cursor INTO cur_course_id, cur_title, cur_semester, cur_session_id, cur_days, cur_start_time, cur_end_time;

        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET conflict = 0; -- initializing: no conflict
		SET current_time_point = cur_start_time; -- initialize current_time_point to the start time of current course

        -- iterate over Mo, Tu, We, Th
        -- Check the time point which is same as current time point being checked. If this time point is already occupied,
        -- then there's time conflict.
        WHILE current_time_point < cur_end_time DO
			-- Mo
            IF FIND_IN_SET('Mo', cur_days) > 0 THEN
                IF EXISTS (
                    SELECT 1
                    FROM Schedule
                    WHERE day_of_week = 'Mo'
                    AND time_point = current_time_point
                    AND occupied = 1
                ) THEN
                    SET conflict = TRUE;
                END IF;
            END IF;

			-- Tu
            IF FIND_IN_SET('Tu', cur_days) > 0 THEN
                IF EXISTS (
                    SELECT 1
                    FROM Schedule
                    WHERE day_of_week = 'Tu'
                    AND time_point = current_time_point
                    AND occupied = 1
                ) THEN
                    SET conflict = TRUE;
                END IF;
            END IF;
	
			-- We
            IF FIND_IN_SET('We', cur_days) > 0 THEN
                IF EXISTS (
                    SELECT 1
                    FROM Schedule
                    WHERE day_of_week = 'We'
                    AND time_point = current_time_point
                    AND occupied = 1
                ) THEN
                    SET conflict = TRUE;
                END IF;
            END IF;

			-- Th
            IF FIND_IN_SET('Th', cur_days) > 0 THEN
                IF EXISTS (
                    SELECT 1
                    FROM Schedule
                    WHERE day_of_week = 'Th'
                    AND time_point = current_time_point
                    AND occupied = 1
                ) THEN
                    SET conflict = TRUE;
                END IF;
            END IF;

            -- If time conflict exists, start checking next course.
            IF conflict THEN
                ITERATE read_loop;  
            END IF;

            -- If current time point is valid, check next time point.
            SET current_time_point = ADDTIME(current_time_point, '00:15:00');
        END WHILE;

        -- If there's no time conflict, then insert the course to PlanA.
        INSERT INTO PlanA (course_id, title, semester, session_id, days, start_time, end_time)
        VALUES (cur_course_id, cur_title, cur_semester, cur_session_id, cur_days, cur_start_time, cur_end_time);

        -- If the course is valid, update Schedule, set the time points in its time slot occupied.
        SET current_time_point = cur_start_time;
        WHILE current_time_point <= cur_end_time DO
            IF FIND_IN_SET('Mo', cur_days) > 0 THEN
                UPDATE Schedule
                SET occupied = 1
                WHERE day_of_week = 'Mo' AND time_point = current_time_point;
            END IF;

            IF FIND_IN_SET('Tu', cur_days) > 0 THEN
                UPDATE Schedule
                SET occupied = 1
                WHERE day_of_week = 'Tu' AND time_point = current_time_point;
            END IF;

            IF FIND_IN_SET('We', cur_days) > 0 THEN
                UPDATE Schedule
                SET occupied = 1
                WHERE day_of_week = 'We' AND time_point = current_time_point;
            END IF;

            IF FIND_IN_SET('Th', cur_days) > 0 THEN
                UPDATE Schedule
                SET occupied = 1
                WHERE day_of_week = 'Th' AND time_point = current_time_point;
            END IF;

            SET current_time_point = ADDTIME(current_time_point, '00:15:00');
        END WHILE;

    END LOOP;

    CLOSE course_cursor;
END$$

DELIMITER ;

CALL CheckTimeConflict();
