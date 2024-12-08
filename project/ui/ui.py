import tkinter as tk
from tkinter import messagebox, ttk
import mysql.connector  # 使用 MySQL 连接器

# 连接到 MySQL 数据库
def get_data_from_db(query, params=None):
    try:
        # 连接到 SELECTION 数据库
        conn = mysql.connector.connect(
            host='localhost',          # MySQL 服务器地址
            user='root',      # 替换为你的 MySQL 用户名
            password='1234',  # 替换为你的 MySQL 密码
            database='SELECTION'         # 数据库名称
        )
        cursor = conn.cursor()
        cursor.execute(query, params if params else ())
        result = cursor.fetchall()
        conn.close()
        return result
    except mysql.connector.Error as err:
        messagebox.showerror("数据库错误", f"查询数据库时出错: {str(err)}")
        return []

# 固定的专业选项
def get_majors():
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

# 固定的科目选项
def get_subjects():
    return [
        "Arts (ARTS)", "Arts and Humanities (ARHU)", "Behavior Science (BEHAVSCI)", "Biology (BIOL)", "Capstone (CAPSTONE)", "Chemistry (CHEM)",
        "Chinese (CHINESE)", "Chinese Society and Culture (CHSC)", "Computer Design (COMPDSGN)", "Computer Science (COMPSCI)", "Cultural Anthropology (CULANTH)",
        "Cultures and Movements (CULMOVE)", "Economics (ECON)", "English (ENGLISH)", "English for Academic Purposes (EAP)", "Environment (ENVIR)", 
        "Ethics and Leadership (ETHLDR)", "French (FRENCH)", "German (GERMAN)", "Global China Studies (GCHINA)", "Global Challenges (GLOCHALL)", 
        "Global Cultural Studies (GCULS)", "Global Health (GLHLTH)", "History (HIST)", "Independent Study (INDSTU)", "Information Science (INFOSCI)", 
        "Institutions and Governance (INSTGOV)", "Integrated Science (INTGSCI)", "Italian (ITALIAN)", "Japanese (JAPANESE)", "Korean (KOREAN)", "Latin (LATIN)", "Literature (LIT)", 
        "Material Science (MATSCI)", "Mathematics (MATH)", "Media (MEDIA)", "Media and Arts (MEDIART)", "Military Science (MILITSCI)", "Music (MUSIC)", "Neuroscience (NEUROSCI)", 
        "Philosophy (PHIL)", "Physics (PHYS)", "Physical Education (PHYSEDU)", "Political Economy (POLECON)", "Political Science (POLSCI)", "Psychology (PSYCH)", 
        "Public Policy (PUBPOL)", "Research Independent Study (RINDSTU)", "Religious Studies (RELIG)", "Social Science (SOSC)", "Sociology (SOCIOL)", "Spanish (SPANISH)", 
        "Statistics (STATS)", "US Studies (USTUD)", "Written and Oral Communication (WOC)"
    ]

# 获取已修课程列表
def get_courses_taken(netid):
    query = """
    SELECT c.title
    FROM Courses_taken ct
    JOIN Courses c ON ct.course_id = c.course_id
    WHERE ct.student_id = %s
    """
    courses = get_data_from_db(query, (netid,))
    return [course[0] for course in courses]

# 获取可用目标课程列表（排除已修课程）
def available_target_courses(netid):
    query = """
    SELECT title FROM Courses_info
    WHERE title NOT IN 
    (SELECT c.title 
    FROM Courses_taken ct 
    JOIN Courses c ON ct.course_id = c.course_id 
    WHERE ct.student_id = %s)
    """
    courses = get_data_from_db(query, (netid,))
    return [course[0] for course in courses]


# 更新目标课程下拉框，只显示未修课程
def update_target_courses(netid):
    target_courses = available_target_courses(netid)  # 获取未修课程
    target_courses_listbox.delete(0, tk.END)  # 清空现有内容
    for course in target_courses:
        target_courses_listbox.insert(tk.END, course)  # 将每个目标课程插入 Listbox
    target_courses_listbox.select_set(0)  # 默认选中第一个课程


# 更新已修课程框框
def update_courses_taken():
    netid = entry_netid.get()
    if netid:
        courses_taken = get_courses_taken(netid)
        courses_taken_listbox.delete(0, tk.END)  # 清空现有内容
        for course in courses_taken:
            courses_taken_listbox.insert(tk.END, course)  # 将每个已修课程插入 Listbox
        # 更新目标课程下拉框
        update_target_courses(netid)
    else:
        messagebox.showwarning("输入错误", "请先输入学号 (NetID)!")

# 查询并显示符合条件的课程
def show_results():
    # 获取用户输入
    netid = entry_netid.get()
    major = major_menu.get()
    target_courses = target_courses_listbox.curselection()  # 获取选中的目标课程
    target_subjects = listbox_target_subject.curselection()  # 获取选中的目标科目

    # 将选中的目标课程转换为可用的列表
    selected_target_courses = [target_courses_listbox.get(i) for i in target_courses]
    # 将选中的科目转换为可用的列表
    selected_subjects = [listbox_target_subject.get(i) for i in target_subjects]

    # 如果没有选择 NetID 或目标课程，则提示用户输入
    if not netid or not selected_target_courses:
        messagebox.showwarning("输入错误", "请先输入学号 (NetID) 和选择目标课程!")
        return
'''

    # 查询数据库获取符合条件的课程
    query = """
    SELECT c.course_id, c.title, c.instructor, c.units, c.semester
    FROM Courses c
    JOIN Courses_requirements cr ON c.course_id = cr.course_id
    JOIN Requirements r ON cr.requirement_id = r.requirement_id
    WHERE c.course_id NOT IN (SELECT course_id FROM Courses_taken WHERE student_id = %s)
    AND cr.major = %s
    AND cr.subject_id IN (%s)
    """
    # 将科目列表拼接成查询语句的参数
    subject_placeholders = ', '.join(['%s'] * len(selected_subjects))
    query = query % subject_placeholders

    # 获取数据
    courses = get_data_from_db(query, (netid, major, *selected_subjects))

    # 清空显示结果区
    result_text.delete(1.0, tk.END)

    if not courses:
        result_text.insert(tk.END, "没有符合条件的课程。\n")
    else:
        result_text.insert(tk.END, "符合条件的课程：\n")
        for course in courses:
            result_text.insert(tk.END, f"课程ID: {course[0]}, 课程名: {course[1]}, "
                                      f"授课教师: {course[2]}, 学分: {course[3]}, 学期: {course[4]}\n")

'''
    
# 设置主窗口
root = tk.Tk()
root.title("课程筛选系统")

# 设置窗口大小
root.geometry("600x600")

# 输入框区域
frame_input = tk.Frame(root)
frame_input.pack(padx=10, pady=10)

# NetID 输入框
label_netid = tk.Label(frame_input, text="学号 (NetID):")
label_netid.grid(row=0, column=0, sticky="w", pady=5)
entry_netid = tk.Entry(frame_input, width=30)
entry_netid.grid(row=0, column=1, pady=5)

# 专业下拉框
label_major = tk.Label(frame_input, text="专业 (Major):")
label_major.grid(row=1, column=0, sticky="w", pady=5)
major_menu = ttk.Combobox(frame_input, values=get_majors(), width=27)
major_menu.grid(row=1, column=1, pady=5)

# 已修课程框框
label_courses_taken = tk.Label(frame_input, text="已修课程 (Courses Taken):")
label_courses_taken.grid(row=2, column=0, sticky="w", pady=5)
courses_taken_listbox = tk.Listbox(frame_input, width=30, height=5, selectmode=tk.SINGLE)
courses_taken_listbox.grid(row=2, column=1, pady=5)

# 目标课程多选框
label_target_courses = tk.Label(frame_input, text="目标课程 (Target Courses):")
label_target_courses.grid(row=3, column=0, sticky="w", pady=5)
target_courses_listbox = tk.Listbox(frame_input, width=30, height=5, selectmode=tk.MULTIPLE)
target_courses_listbox.grid(row=3, column=1, pady=5)

# 目标科目多选框
label_target_subject = tk.Label(frame_input, text="目标科目 (Target Subjects):")
label_target_subject.grid(row=4, column=0, sticky="w", pady=5)

# 使用 Listbox 允许多选
listbox_target_subject = tk.Listbox(frame_input, selectmode=tk.MULTIPLE, height=5)
for subject in get_subjects():
    listbox_target_subject.insert(tk.END, subject)
listbox_target_subject.grid(row=4, column=1, pady=5)

# 更新已修课程框框按钮
button_update_courses = tk.Button(root, text="更新已修课程", command=update_courses_taken)
button_update_courses.pack(pady=10)

# 查询按钮
button_confirm = tk.Button(root, text="确认", command=show_results)
button_confirm.pack(pady=10)

# 结果显示区域
frame_result = tk.Frame(root)
frame_result.pack(padx=10, pady=10)

label_result = tk.Label(frame_result, text="筛选结果：")
label_result.pack()

result_text = tk.Text(frame_result, width=60, height=15)
result_text.pack()

# 运行主循环
root.mainloop()
