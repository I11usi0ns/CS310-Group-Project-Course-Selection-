DELIMITER $$

DROP PROCEDURE IF EXISTS TimeConflict;

CREATE PROCEDURE TimeConflict(student_id VARCHAR(20), cur_semester_cursor VARCHAR(10), cur_session_id_cursor VARCHAR(4))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE cur_course_id VARCHAR(20);
    DECLARE cur_title VARCHAR(100);
    DECLARE cur_start_time TIME;
    DECLARE cur_end_time TIME;
    DECLARE cur_units_cursor INT;
    DECLARE time_conflict BOOLEAN DEFAULT FALSE; -- initialize time_conflict to FALSE

    -- get all the course information
    DECLARE course_cursor CURSOR FOR
        SELECT course_id, title, start_time, end_time, units
        FROM SortedCourses
        WHERE semester = cur_semester_cursor;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN course_cursor;

    -- iterate over courses
    read_loop: LOOP
        FETCH course_cursor INTO cur_course_id, cur_title, cur_start_time, cur_end_time, cur_units_cursor;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- set time_conflict to false
        SET time_conflict = FALSE;

        -- check time conflict 
        IF EXISTS (
            SELECT 1
            FROM Plan
            JOIN Courses ON Plan.course_id = SortedCourses.course_id
            WHERE Plan.student_id = student_id
            AND Plan.semester = cur_semester_cursor
            AND Plan.session_id = cur_session_id_cursor
            AND (
                -- check if it's on the same day
                (SortedCourses.days LIKE CONCAT('%', SUBSTRING(cur_semester_cursor, 1, 2), '%') 
                OR SortedCourses.days LIKE CONCAT('%', SUBSTRING(cur_semester_cursor, 3, 4), '%')
                OR SortedCourses.days LIKE CONCAT('%', SUBSTRING(cur_semester_cursor, 5, 6), '%')
                OR SortedCourses.days LIKE CONCAT('%', SUBSTRING(cur_semester_cursor, 7, 8), '%'))
                AND 
                -- check if the time slots overlap
                NOT (SortedCourses.end_time <= cur_start_time OR cur_end_time <= SortedCourses.start_time)
            )
        ) THEN
            -- if there is a conflict, set time_conflict to TRUE
            SET time_conflict = TRUE;
        END IF;

        -- insert course into Plan if there's no time conflict
        IF time_conflict = FALSE 
        THEN
            INSERT INTO Plan (student_id, course_id, title, semester, session_id, units)
            VALUES (student_id, cur_course_id, cur_title, cur_semester_cursor, cur_session_id_cursor, cur_units_cursor);
        ELSE
            -- skip the current course if there's time conflict
            ITERATE read_loop;
        END IF;

    END LOOP;

    CLOSE course_cursor;
END$$

DELIMITER ;
