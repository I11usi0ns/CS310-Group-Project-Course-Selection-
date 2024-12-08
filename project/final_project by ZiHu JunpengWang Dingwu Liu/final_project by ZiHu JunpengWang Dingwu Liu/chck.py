import pandas as pd
import itertools
import re
import csv

# 定义课程类
class Course:
    def __init__(self, course_name, course_id, units, times, category, level):
        self.course_name = course_name
        self.course_id = course_id
        self.units = units  # 学分
        self.times = times  # 课程时间，多个时间段
        self.category = category  # 课程类别
        self.level = level  # 课程级别

# 处理跨时段的课程
def split_time_blocks(start_time, end_time):
    time_blocks = []
    for slot_start, slot_end in time_slots:
        if start_time < slot_end and end_time > slot_start:
            time_blocks.append((slot_start, slot_end))
    return time_blocks

# 解析和处理时间段，生成处理后的时间块
def adjust_time_blocks_for_search(df):
    df['Processed Times'] = df.apply(lambda row: [f"{row['Days']} {row['Start time']}-{row['End time']}"], axis=1)
    return df

# 定义预设的时间段
time_slots = [
    (8.3, 9.45), (10.0, 11.25), (11.75, 13.0), 
    (13.25, 14.3), (14.45, 16.0), (16.15, 17.3), 
    (18.0, 19.25), (19.5, 20.75)
]

# 处理课程数据的函数
def process_course_times(df):
    df['Time Blocks'] = df.apply(lambda row: split_time_blocks(row['Start time'], row['End time']), axis=1)
    df = adjust_time_blocks_for_search(df)
    return df

# 提取课程类别和级别的函数，支持不同长度的缩写
def extract_category_and_level(title):
    category_match = re.match(r'[A-Za-z]+', title)
    if category_match:
        category = category_match.group(0)
    else:
        category = ""

    level_match = re.search(r'\d+', title)
    if level_match:
        level = level_match.group(0)
        level = str(int(level) // 100 * 100)
    else:
        level = '0'

    return category, level

# 创建课程对象列表
def create_course_db(df):
    course_db = []
    for _, row in df.iterrows():
        category, level = extract_category_and_level(row['Title'])
        course_db.append(Course(
            row['Title'],
            row['Section'],
            row['Unit'],
            row['Processed Times'],
            category,
            level
        ))
    return course_db

# 合并 LAB 和 REC
def combine_courses(df):
    combined_courses = []
    columns = df.columns
    current_combination = []
    current_main_course = None

    for _, row in df.iterrows():
        section = row['Section']
        if "LEC" in section or "SEM" in section:
            # 如果已有主课程，保存之前的组合
            if current_main_course is not None:
                combined_courses.append(current_main_course)
                current_combination = []

            current_main_course = row.copy()
            current_combination.append(row)

        elif "LAB" in section or "REC" in section:
            if current_main_course is not None:
                # 更新学分和时间段
                current_main_course['Unit'] += row['Unit']
                current_main_course['Processed Times'] += row['Processed Times']

    # 将最后一个主课程保存
    if current_main_course is not None:
        combined_courses.append(current_main_course)

    # 转换为 DataFrame，确保列名匹配
    combined_courses_df = pd.DataFrame(combined_courses, columns=columns)

    return combined_courses_df

# 检查时间冲突
def has_time_conflict(course1, course2):
    for time_slot1 in course1.times:
        for time_slot2 in course2.times:
            if time_slot1 == time_slot2:
                return True
    return False

# 搜索符合条件的课程并生成所有组合方案
def search_course_combinations(mandatory_courses, category_requirements, course_db, avoid_time):
    selected_courses = [course for course in course_db if course.course_name in mandatory_courses]
    print(f"Mandatory courses: {[course.course_name for course in selected_courses]}")

    grouped_courses = {category: [] for category in category_requirements}

    for course in course_db:
        if course.category in category_requirements and course.level == category_requirements[course.category]:
            grouped_courses[course.category].append(course)

    for category, courses in grouped_courses.items():
        print(f"{category} course group: {[course.course_name for course in courses]}")

    if grouped_courses:
        all_combinations = list(itertools.product(*grouped_courses.values()))
        print(f"Number of combinations generated: {len(all_combinations)}")
    else:
        all_combinations = [[]]

    valid_combinations = []
    for combination in all_combinations:
        full_combination = selected_courses + list(combination)
        if not any(has_time_conflict(course1, course2) for course1, course2 in itertools.combinations(full_combination, 2)):
            valid_combinations.append(full_combination)

    print(f"Number of valid combinations: {len(valid_combinations)}")
    return valid_combinations

# 获取用户输入
def get_user_input():
    mandatory_courses = input("请输入必须上的课程ID（用逗号分隔）: ").split(',')

    category_requirements = {}
    while True:
        category = input("请输入课程类别（如 ECON 或 PHIL），输入 'done' 结束: ")
        if category.lower() == 'done':
            break
        level = input(f"请输入 {category} 类别所需的课程级别（如 '200' 或 '300'）: ")
        category_requirements[category] = level

    grade = input("请输入学生的年级：")

    avoid_time = input("请输入要避免的时间段选项（1-5）：")

    return mandatory_courses, category_requirements, grade, avoid_time

# 打印每个组合方案并写入CSV文件
def print_combinations_to_csv(combinations, grade, avoid_time):
    if not combinations:
        print("没有符合要求的方案。")
    else:
        # 打开CSV文件准备写入
        with open('C:\\Users\\33329\\Desktop\\STAS102\\final\\course all\\all\\combine.csv', 'w', newline='', encoding='utf-8') as csvfile:
            csv_writer = csv.writer(csvfile)
            # 写入表头
            csv_writer.writerow(['Student Number', 'Grade', 'Total Units', 'Avoided Time Slot', 'Selected Course 1', 'Selected Course 2', 'Selected Course 3', 'Success'])

            for i, combination in enumerate(combinations, 1):
                total_units = sum(course.units for course in combination)
                courses = [f"{course.course_name} ({course.course_id})" for course in combination]
                while len(courses) < 3:  # 保证有3个课程
                    courses.append("")

                # 写入CSV文件中的一行
                csv_writer.writerow([i, grade, total_units, avoid_time] + courses + [1])  # 1表示成功

# 主程序
def main():
    file_path = "C:\\Users\\33329\\Desktop\\STAS102\\final\\course all\\all\\final_courses.csv"
    courses_df = pd.read_csv(file_path)

    print(courses_df.columns)  # 调试输出列名

    processed_df = process_course_times(courses_df)

    combined_courses_df = combine_courses(processed_df)  # 修复：返回DataFrame
    course_db = create_course_db(combined_courses_df)

    mandatory_courses, category_requirements, grade, avoid_time = get_user_input()

    combinations = search_course_combinations(mandatory_courses, category_requirements, course_db, avoid_time)

    print_combinations_to_csv(combinations, grade, avoid_time)

if __name__ == "__main__":
    main()
