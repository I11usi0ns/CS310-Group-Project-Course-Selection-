import tkinter as tk
from tkinter import ttk, messagebox
import mysql.connector

# Set up the main window with reduced width
root = tk.Tk()
root.title("Course Selection System")
root.geometry("800x900")  # Adjust the width here to make the window smaller

# Create Canvas and Scrollbars
canvas = tk.Canvas(root)
canvas.pack(side="left", fill="both", expand=True)

# Set up vertical and horizontal scrollbars
v_scrollbar = ttk.Scrollbar(root, orient=tk.VERTICAL, command=canvas.yview)
v_scrollbar.pack(side="right", fill="y")

h_scrollbar = ttk.Scrollbar(root, orient=tk.HORIZONTAL, command=canvas.xview)
h_scrollbar.pack(side="bottom", fill="x")

canvas.configure(yscrollcommand=v_scrollbar.set, xscrollcommand=h_scrollbar.set)

# Create a frame for all input controls
frame_input = tk.Frame(canvas)
canvas.create_window((0, 0), window=frame_input, anchor="nw")

# Bind the <Configure> event to ensure the scrollable region updates with the content
frame_input.bind(
    "<Configure>",
    lambda event, canvas=canvas: canvas.configure(scrollregion=canvas.bbox("all"))
)

# NetID input box
label_netid = tk.Label(frame_input, text="NetID:")
label_netid.grid(row=0, column=0, sticky="w", padx=10, pady=5)
entry_netid = tk.Entry(frame_input, width=24)
entry_netid.grid(row=1, column=0, pady=5, padx=10, sticky="ew")

# Range of class
def get_class():
    return [1, 2, 3, 4]

# Class dropdown
label_class = tk.Label(frame_input, text="Class:")
label_class.grid(row=2, column=0, sticky="w", padx=10, pady=5)
class_menu = ttk.Combobox(frame_input, values=get_class(), width=24)
class_menu.grid(row=3, column=0, pady=5, padx=10, sticky="ew")

# Range of Semester
def get_semester():
    return ["Fall", "Spring"]

# Semester dropdown
label_semester = tk.Label(frame_input, text="Semester you are in:")
label_semester.grid(row=4, column=0, sticky="w", padx=10, pady=5)
semester_menu = ttk.Combobox(frame_input, values=get_semester(), width=24)
semester_menu.grid(row=5, column=0, pady=5, padx=10, sticky="ew")

# Range of majors
def get_major():
    return [
        "Arts and Media/Arts", "Arts and Media/Media",
        "Applied Mathematics and Computational Sciences/Computer Science", "Applied Mathematics and Computational Sciences/Mathematics",
        "Behavioral Science/Psychology", "Behavioral Science/Neuroscience",
        "Computation and Design/Computer Science", "Computation and Design/Digital Media",
        "Computation and Design/Social Policy", "Cultures and Movements/Cultural Anthropology",
        "Cultures and Movements/Religious Studies", "Cultures and Movements/Sociology",
        "Cultures and Movements/World History", "Data Science",
        "Environmental Science/Biogeochemistry", "Environmental Science/Biology", "Environmental Science/Chemistry",
        "Environmental Science/Public Policy", "Ethics and Leadership/Philosophy",
        "Ethics and Leadership/Public Policy",
        "Global China Studies/Chinese History", "Global China Studies/Political Science",
        "Global China Studies/Religious Studies",
        "Global Cultural Studies/Creative Writing and Translation", "Global Cultural Studies/World History",
        "Global Cultural Studies/World Literature",
        "Global Health/Biology", "Global Health/Public Policy",
        "Institutions and Governance/Economics", "Institutions and Governance/Political Science",
        "Institutions and Governance/Public Policy",
        "Materials Science/Chemistry", "Materials Science/Physics",
        "Molecular Bioscience/Biogeochemistry", "Molecular Bioscience/Biophysics",
        "Molecular Bioscience/Cell and Molecular Biology", "Molecular Bioscience/Genetics and Genomics",
        "Political Economy/Economics", "Political Economy/Political Science",
        "Political Economy/Public Policy",
        "US Studies/American History", "US Studies/American Literature", "US Studies/Political Science",
        "US Studies/Public Policy"
    ]

# Major dropdown
label_major = tk.Label(frame_input, text="Major:")
label_major.grid(row=6, column=0, sticky="w", padx=10, pady=5)
major_menu = ttk.Combobox(frame_input, values=get_major(), width=24)
major_menu.grid(row=7, column=0, pady=5, padx=10, sticky="ew")

# Courses taken input box
label_courses_taken = tk.Label(frame_input, text="Courses Taken (separate with commas, e.g., COMPSCI 101,MATH 105):")
label_courses_taken.grid(row=8, column=0, sticky="w", padx=10, pady=5)
entry_courses_taken = tk.Entry(frame_input, width=24)
entry_courses_taken.grid(row=9, column=0, pady=5, padx=10, sticky="ew")

# Target Courses Label
label_target_courses = tk.Label(frame_input, text="Target Courses:")
label_target_courses.grid(row=10, column=0, sticky="w", padx=10, pady=5)

# Specified Course Label
label_target_courses_0 = tk.Label(frame_input, text="Specified Courses(separate with commas, e.g., Fall2024-1021,Spring2025-1033):")
label_target_courses_0.grid(row=11, column=0, sticky="w", padx=10, pady=5)

# Specified Course input box
target_courses_0 = tk.Entry(frame_input, width=24)
target_courses_0.grid(row=12, column=0, pady=5, padx=10, sticky="ew")

# Unspecified Course Label
label_target_courses_1 = tk.Label(frame_input, text="Unspecified Courses:")
label_target_courses_1.grid(row=13, column=0, sticky="w", padx=10, pady=5)

# Unspecified Course
label_target_courses_2 = tk.Label(frame_input, text="Course(e.g., COMPSCI 201)  Semester(optional, e.g., Fall2024)  Session(optional, fill in 7W1 or 7W2)")
label_target_courses_2.grid(row=14, column=0, sticky="w", padx=10, pady=5)

# Create a frame to hold the target course input fields
frame_target_courses = tk.Frame(frame_input)
frame_target_courses.grid(row=15, column=0, padx=5, pady=1)

# Initialize the target_courses_entries list
target_courses_entries = []

# Create the first target course row
def create_target_course_row():
    frame_row = tk.Frame(frame_target_courses)

    # Course input fields
    course_entry = tk.Entry(frame_row, width=18)
    semester_entry = tk.Entry(frame_row, width=18)
    session_entry = tk.Entry(frame_row, width=18)

    # Layout the input fields
    course_entry.grid(row=0, column=0, padx=5, pady=0.5, sticky="nsew")
    semester_entry.grid(row=0, column=1, padx=5, pady=0.5, sticky="nsew")
    session_entry.grid(row=0, column=2, padx=5, pady=0.5, sticky="nsew")

    # Add button to add a new row
    add_button = tk.Button(frame_row, text="+", command=lambda: add_target_course_row(frame_row))
    add_button.grid(row=0, column=3, padx=5)

    # Add the row to the target courses container
    frame_row.grid(row=len(frame_target_courses.winfo_children()), column=0, pady=5)

    # Add to entries list
    target_courses_entries.append((course_entry, semester_entry, session_entry))

# Function to add a new target course row
def add_target_course_row(existing_frame):
    create_target_course_row()

# Create the first target course row
create_target_course_row()

# Subject Label
label_subject = tk.Label(frame_input, text="Target subject:")
label_subject.grid(row=16, column=0, sticky="w", padx=10, pady=5)

# Subject Instruction Label
label_subject_instruction = tk.Label(frame_input, text="fill in one subject you want to take, e.g., COMPSCI)")
label_subject_instruction.grid(row=17, column=0, sticky="w", padx=10, pady=5)

# Subject Entry
subject_menu = tk.Entry(frame_input, width=24)
subject_menu.grid(row=18, column=0, pady=5, padx=10, sticky="ew")

# Function to query the database and insert data
def query_results():
    netid = entry_netid.get()
    major = major_menu.get()
    grade = class_menu.get()
    subject_id = subject_menu.get()
    courses_taken = entry_courses_taken.get()
    target_courses_0_list = target_courses_0.get().split(",")
    semester = 1
    if semester_menu.get() == 'Spring' :
        semester = 2
    # Connect to MySQL database
    try:
        db_connection = mysql.connector.connect(
            host='localhost',
            port=3306,
            db='selection',
            user='root',
            passwd='746746jack'
        )
        cursor = db_connection.cursor()
        
        # Step 1: Insert the student's information into the Students table
        insert_student_query = """
        INSERT INTO Students (id, major, subject_id)
        VALUES (%s, %s, %s)
        ON DUPLICATE KEY UPDATE major = %s;
        """
        cursor.execute(insert_student_query, (netid, major, subject_id))
        
        # Step 2: Insert the student's taken courses into Courses_taken table
        if courses_taken:
            courses_taken_list = courses_taken.split(",")  # Assuming input is comma-separated
            for course in courses_taken_list:
                insert_courses_taken_query = """
                INSERT INTO Courses_taken (title, student_id)
                VALUES (%s, %s);
                """
                cursor.execute(insert_courses_taken_query, (course, netid))

        # Step 3: Insert specified courses
        for course_id in target_courses_0_list:
            
            # Get course title from database
            get_title_query = """
            SELECT title, semester, session_id FROM Courses WHERE course_id = %s;
            """
            cursor.execute(get_title_query, (course_id,))
            result = cursor.fetchone()
            
            if result:
                title = result[0]
                semester = result[1]
                session_id = result[2]

                # Insert into Courses_to_be_taken with course details
                insert_courses_query = """
                INSERT INTO Courses_to_be_taken (student_id, title, semester, session_id)
                VALUES (%s, %s, %s, %s);
                """
                cursor.execute(insert_courses_query, (netid, title, semester, session_id))
                db_connection.commit()  # Commit each insertion

            else:
                print(f"Course with ID {course_id} not found.")

        # Step 4: Insert unspecified courses
        for course_entry, semester_entry, session_entry in target_courses_entries:
            title = course_entry.get()
            semester = semester_entry.get()
            session = session_entry.get()

            if not title or not semester or not session:
                continue  # Skip empty fields

            insert_courses_unspecified_query = """
            INSERT INTO Courses_to_be_taken (student_id, title, semester, session_id)
            VALUES (%s, %s, %s, %s);
            """
            cursor.execute(insert_courses_unspecified_query, (netid, title, semester, session))
            

        db_connection.commit()
        messagebox.showinfo("Success", "Student information and courses have been successfully updated!")

        
        # 运行longterm_select.sql脚本
        with open('longterm_select.sql', 'r') as sql_file:
            sql_script = sql_file.read()
            # 执行SQL脚本中的每条语句
            for statement in sql_script.split(';'):
                if statement.strip():
                    cursor.execute(statement)
            db_connection.commit()
        cursor.execute('''
            Call GeneratePlanWithTopoSort('12345678', %d, %d)
        ''',(grade,semester))
        
        # 清空 Text 小部件的内容（避免在已有内容上继续添加）
        result_text.delete(1.0, tk.END)
        
        # Step : show long term results
        result_text.insert(tk.END, "Long Term Plan:\n")
        long_term_plan_query = """
            select course_id, title, semester, session_id, units
            from Plan
            where student_id=%s
        """
        cursor.execute(long_term_plan_query, netid)
        long_term_plan=cursor.fetchall()

        # 将查询结果插入到 result_text 文本框中
        for row in long_term_plan:
            # 格式化数据并插入到文本框
            result_text.insert(tk.END, f"Course ID: {row[0]}, Title: {row[1]},"
                                        f"Semester: {row[2]}, Session ID: {row[3]}, Units: {row[4]}\n")

        
        """
        for course_id, semester, units in result:
            if semester.startswith("Spring"):
                next_semester = f"Fall{int(semester[5:])}"
            elif semester.startswith("Fall"):
                next_semester = f"Spring{int(semester[4:]) + 1}"

            if next_semester == get_next_semester():
                next_semester_courses.append((course_id, next_semester, units))
            else:
                future_semester_courses.append((course_id, next_semester, units))

        # Step : Display results in the Text widget
        result_text.delete(1.0, tk.END)  # Clear the current text
        result_text.insert(tk.END, "Next Semester Courses:\n")
        for course_id, semester, units in next_semester_courses:
            result_text.insert(tk.END, f"Course ID: {course_id}, Semester: {semester}, Units: {units}\n")

        result_text.insert(tk.END, "\nFuture Semester Courses:\n")
        for course_id, semester, units in future_semester_courses:
            result_text.insert(tk.END, f"Course ID: {course_id}, Semester: {semester}, Units: {units}\n")
        """

    except mysql.connector.Error as err:
        messagebox.showerror("Error", f"Error: {err}")

    finally:
        # Close the database connection
        cursor.close()
        db_connection.close()

"""
# Function to determine the next semester based on the current semester
def get_next_semester():
    # Get the current semester (assuming it's in Fall or Spring format like Fall2024, Spring2025)
    current_semester = semester_menu.get()  # This can be dynamically set based on current date
    if current_semester.startswith("Fall"):
        next_semester = f"Spring{int(current_semester[4:]) + 1}"
    elif current_semester.startswith("Spring"):
        next_semester = f"Fall{int(current_semester[5:])}"
    return next_semester
"""

# Create the query button
button = tk.Button(frame_input, text="Query", command=query_results)
button.grid(row=19, column=0, pady=10)

# Create a Text widget to display the results
result_text = tk.Text(frame_input, width=60, height=20)
result_text.grid(row=20, column=0, pady=10)

# Run the main loop
root.mainloop()