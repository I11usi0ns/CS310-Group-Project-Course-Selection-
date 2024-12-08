use SELECTION;

-- SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE 'C:/Users/gigggjjffd/Desktop/work/school stuffs/homeworks/CS310/project/courses_info1.csv'
INTO TABLE Courses_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(title);

LOAD DATA INFILE 'C:/Users/gigggjjffd/Desktop/work/school stuffs/homeworks/CS310/project/updated_courses.csv'
INTO TABLE Courses
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(course_id, type_id, title, semester, session_id, days, start_time, end_time, status_number, instructor, units);


-- SET FOREIGN_KEY_CHECKS = 1;
