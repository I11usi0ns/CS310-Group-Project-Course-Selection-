drop database SELECTION;
create database SELECTION;
use SELECTION;

create table Courses_info
 (   title varchar(20),
     type_id varchar(4), -- lec/rec/lab
     units numeric(2,1) check(units >= 0 and units <= 4),
     primary key(title)
    );
    
create table Courses
 (	 course_id int,
     instructor varchar(25),
     title varchar(20),
     semester varchar(10),
     session_id int,
     days varchar(12),
     start_time TIME,
     end_time TIME,
     status_id varchar(10),
     primary key (course_id),
     foreign key (title) references Courses_info(title)
     on delete cascade
    );  
    
create table Pre_requisite
	(id_first varchar(20), -- The prerequisite course
     id_second varchar(20), -- The course that requires a prerequisite
     id_or int,
     primary key (id_or),
     foreign key (id_second) references Courses_info(title)
		on delete cascade,
	foreign key (id_first) references Courses_info(title)
		on delete cascade
	);

create table Anti_requisite
	(id_1 varchar(20),
     id_2 varchar(20),
     primary key (id_1,id_2),
     foreign key (id_1) references Courses_info(title)
		on delete cascade,
	foreign key (id_2) references Courses_info(title)
		on delete cascade
	);
    
create table Requirements
	(requirement_id int,
     units_needed numeric(4,1),
     requirement_type varchar(20),
     major varchar(64),
     subject_id varchar(15),
     primary key (requirement_id)
	);
    
-- Courses_requirement refers to the requirement a course belongs to
create table Courses_requirements
	(title varchar(20),
     requirement_id int,
     primary key (title,requirement_id),
     foreign key (title) references Courses(title)
		on delete cascade,
     foreign key (requirement_id) references Requirements(requirement_id)
		on delete cascade
	);
    
create table Students
	(id varchar(8),
     major varchar(64),
     subject_id varchar(15),
     primary key (id)
	);

create table Courses_taken 
	(course_id int,
     student_id varchar(8),
     primary key (course_id,student_id),
     foreign key (course_id) references Courses(course_id)
		on delete cascade,
	 foreign key (student_id) references Students(id)
		on delete cascade
	);

create table Courses_to_be_taken
	(student_id varchar(8),
     course_id int,
     semester varchar(10),
     session_id int,
     primary key (student_id, course_id),
     foreign key (course_id) references Courses(course_id)
		on delete cascade,
	 foreign key (student_id) references Students(id)
		on delete cascade
	);
    
create table Plan
	(student_id varchar(8),
     course_id int,
     primary key (student_id,course_id),
     foreign key (course_id) references Courses(course_id)
		on delete cascade,
	 foreign key (student_id) references Students(id)
		on delete cascade
	);



