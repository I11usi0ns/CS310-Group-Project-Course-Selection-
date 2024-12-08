import MySQLdb
from MySQLdb import Error

def funct(major,semester,subject):
    try:
        connection = MySQLdb.connect(
            host='localhost',
            port=3306,
            db='selection',
            user='root',
            passwd='746746jack'
        )

        cursor = connection.cursor()
        
        cursor.execute("SELECT DATABASE()")
        record = cursor.fetchone()
        cursor.execute("SHOW COLUMNS FROM courses")
        columns = [column[0] for column in cursor.fetchall()]
        cursor.execute('''
                    SELECT * FROM courses 
                    WHERE courses.title NOT IN (SELECT title FROM courses_taken)
                    AND (courses.title LIKE %s or courses.title LIKE %s 
                    or (courses.title, courses.semester) in (select title, semester from courses_to_be_taken)
                    or courses.course_id in (select course_id from courses_to_be_taken))
                    AND courses.semester = %s
                    ''', (major,subject,semester))
        
        courses_list = []
        for row in cursor.fetchall():
            course_dict = dict(zip(columns, row))
            courses_list.append(course_dict)

        course_dict = {}
        for course in courses_list:
            course_dict[course['course_id']] = course

        graph_in = {}
        graph_out = {}
        graph_in_degree = {}

        for course in courses_list:
            graph_in[course['title']] = []
            graph_out[course['title']] = []
            graph_in_degree[course['title']] = 0
        
        sett = set()

        for course in courses_list:
            if graph_in_degree[course['title']] == 0:
                sett.add(course['course_id'])
        
       
        cursor.execute("SHOW COLUMNS FROM pre_requisite") 
        pre_columns = [column[0] for column in cursor.fetchall()]

        
        cursor.execute("SELECT * FROM pre_requisite")
        
        pre_requisite = []
        for row in cursor.fetchall():
            pre_dict = dict(zip(pre_columns, row))
            pre_requisite.append(pre_dict)

        # for row in pre_requisite:
        #     graph_in[row['id_second']].append(row['id_first'])
        #     graph_in_degree[row['id_second']] += 1
        #     graph_out[row['id_first']].append(row['id_second'])

        conflict = {}

        
        cursor.execute("SHOW COLUMNS FROM anti_requisite")
        anti_columns = [column[0] for column in cursor.fetchall()]

        
        cursor.execute("SELECT * FROM anti_requisite")
        anti_requisite = []
        for row in cursor.fetchall():
            anti_dict = dict(zip(anti_columns, row))
            anti_requisite.append(anti_dict)
        #for row in anti_requisite:
            #conflict[row['id_2']].append(row['id_1'])

        
        cursor.execute("SHOW COLUMNS FROM courses_to_be_taken")
        courses_to_be_taken_columns = [column[0] for column in cursor.fetchall()]
        cursor.execute("SELECT * FROM courses_to_be_taken")
        courses_to_be_taken = []
        for row in cursor.fetchall():
            courses_dict = dict(zip(courses_to_be_taken_columns, row))
            courses_to_be_taken.append(courses_dict)
        choice1 = []
        choice2 = []
        storage = []
        course_list2 = []
        course_list3 = []
        for course in courses_list:
            if course['type_id'] == 'REC':
                course_list2.append(course)
            elif course['type_id'] == 'LAB':
                course_list3.append(course)
        def check(filter_list,session):
            judge = True
            for course in filter_list:
                for course2 in filter_list[filter_list.index(course)+1:]:
                    if course['title'] == course2['title'] and course['units'] > 0 and course2['units'] > 0:
                        return
                    if not any(day in ['Mo','Tu','We','Th'] for day in [d for d in [course['days'], course2['days']] if all(x not in d for x in ['Mo','Tu','We','Th'])]):
                        continue
                    if course['start_time'] <= course2['end_time'] and course2['start_time'] <= course['end_time']:
                        return
                    
            
            for course1 in courses_to_be_taken:
                if course1['semester'] == semester and course1['session_id'] == session:
                    judge = False
                for course2 in filter_list:
                    if course1['semester'] == semester and course1['session_id'] == session and course2['title'] == course1['title']:
                        judge = True
                    if course1['course_id'] == course2['course_id']:
                        judge = True
            if judge == True:
                unique_courses = []
                seen_titles = set()
                for course in filter_list:
                    if course['title'] not in seen_titles:
                        unique_courses.append(course)
                        seen_titles.add(course['title'])
                storage.append(unique_courses)
            return
        # def list_courses2(filter_list,units,session):
        #     if units == 10 or units == 8 or units == 6:
        #         check(filter_list,session)
        #         return
        #     if units > 10:
        #         return
        #     for course_id in sett:
        #         if course_dict[course_id]['units'] > 0 and course_dict[course_id]['session_id'] == session:
        #             judge = True
        #             sett.remove(course_id)
        #             for courses in graph_in[course_dict[course_id]['title']]:
        #                 graph_in_degree[courses] -= 1
        #                 if graph_in_degree[courses] == 0:
        #                     sett.add(course_dict[courses])
        #             for course2 in conflict[course['course_id']]:
        #                 if course2 in sett:
        #                     sett.remove(course2)
        #             for course2 in course_list2:
        #                 if course_dict[course_id]['title'] == course2['title'] and course_dict[course_id]['instructor'] == course2['instructor']:
        #                     for course3 in course_list3:
        #                         if course_dict[course_id]['title'] == course3['title'] and course_dict[course_id]['instructor'] == course3['instructor']:
        #                             list_courses2(filter_list+[course_dict[course_id],course2,course3],units+course_dict[course_id]['units'],session)
        #                             judge = False
        #                     if judge == True:
        #                         list_courses2(filter_list + [course,course2],units+course['units'],session)
        #                         judge = False 
        #             if judge == True:
        #                 for course3 in course_list3:
        #                     if course['title'] == course3['title'] and course['instructor'] == course3['instructor']:
        #                         list_courses2(filter_list+[course,course3],units+course['units'],session)
        #                         judge = False
        #             if judge == True:
        #                 list_courses2(filter_list + [course],units+course['units'],session)
        #     return

        def list_courses(filter_list,unit,session):
            if unit == 10 or unit == 8 or unit == 6:
                check(filter_list,session)
                return
            elif unit > 10:
                return
            if filter_list and filter_list[-1]['units'] == 2:
                return
            for course in courses_list:
                if course['units'] > 0 and course['session_id'] == session:
                    judge = True
                    for course2 in course_list2:
                        if course['title'] == course2['title'] and course['instructor'] == course2['instructor']:
                            for course3 in course_list3:
                                if course['title'] == course3['title'] and course['instructor'] == course3['instructor']:
                                    list_courses(filter_list+[course,course2,course3],unit+course['units'],session)
                                    judge = False
                            if judge == True:
                                list_courses(filter_list + [course,course2],unit+course['units'],session)
                                judge = False 
                    if judge == True:
                        for course3 in course_list3:
                            if course['title'] == course3['title'] and course['instructor'] == course3['instructor']:
                                list_courses(filter_list+[course,course3],unit+course['units'],session)
                                judge = False
                    if judge == True:
                        list_courses(filter_list + [course],unit+course['units'],session)            
            return 
        plan1 = []
        plan2 = []
        
        cursor.execute("SELECT * FROM courses_taken")
        course_columns = [desc[0] for desc in cursor.description]
        courses_taken = set()
        for row in cursor.fetchall():
            course_dict = dict(zip(course_columns, row))
            courses_taken.add(course_dict['title'])
        def func1():
            storage.clear()
            list_courses([],0,'7W1')
            choice1 = storage.copy()
            storage.clear()
            list_courses([],0,'7W2')
            choice2 = storage.copy()
            pre_requisite.sort(key=lambda x: x['id_or'])
            for filter_list1 in choice1:
                courses_taken1 = courses_taken.copy()
                for course1 in filter_list1:
                    courses_taken1.add(course1['title'])
                judge = True
                for course1 in filter_list1:
                    judge_or = False
                    
                    for row in pre_requisite:
                        
                        if course1['title'] == row['id_second'] and row['id_first'] in courses_taken:
                            judge_or = True
                        elif course1['title'] != row['id_second']:
                            judge_or = True
                        if pre_requisite.index(row) == len(pre_requisite)-1 or row['id_or'] != pre_requisite[pre_requisite.index(row)+1]['id_or']:
                            if judge_or == False:
                                judge = False
                                break
                            judge_or = False
                    for row in anti_requisite:
                        if course1['title'] == row['id_2'] and row['id_1'] in courses_taken1:
                            judge = False
                if judge == False:
                    continue
                for filter_list2 in choice2:
                    judge = True
                    judge2 = True
                    for course11 in filter_list1:
                        for course2 in filter_list2:
                            if course11['title'] == course2['title']:
                                judge2 = False
                    if not judge2:
                        continue
                    
                    courses_taken2 = courses_taken1.copy()
                    for coursse in filter_list2:
                        courses_taken2.add(coursse['title'])
                    for course2 in filter_list2:
                        judge_or = False
                        if judge == False:
                            break
                        for row in pre_requisite:
                            if course2['title'] == row['id_second'] and row['id_first'] in courses_taken1:
                                judge_or = True    
                            elif course2['title'] != row['id_second']:
                                judge_or = True
                            if pre_requisite.index(row) == len(pre_requisite)-1 or row['id_or'] != pre_requisite[pre_requisite.index(row)+1]['id_or']:
                                if judge_or == False:
                                    judge = False
                                    break
                                judge_or = False
                        for row in anti_requisite:
                            if course2['title'] == row['id_2'] and row['id_1'] in courses_taken2:
                                judge = False
                    if judge == True:
                        plan1.append(filter_list1)
                        plan2.append(filter_list2)
            return plan1[:1],plan2[:1]
        func1()                                           

        for course in plan1[0]:
            print(course['title'],end=' ')
        print() 
        for course in plan2[0]:
            print(course['title'],end=' ')

    except Error as e:
        print(f"error connecting to database: {e}")

    finally:
        if 'connection' in locals():
            cursor.close()
            connection.close()
            print("MySQL connection closed")
    return plan1[0],plan2[0]
