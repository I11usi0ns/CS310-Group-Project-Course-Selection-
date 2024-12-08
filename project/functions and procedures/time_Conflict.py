class TimeTable:
    def __init__(self):
        # 初始化一个1000长度的时间线数组,每个元素都是0
        self.time_line = ['' for _ in range(100)]
    
    def add_course(self, start_time, end_time,days):
        # 添加课程时间,将对应时间段标记为1
        
        start_time = start_time / 900
        end_time = end_time / 900
        for i in range(start_time, end_time):
            if 'Mo' not in self.time_line[i] and 'Mo' in days:
                self.time_line[i].append('Mo')
            if 'Tu' not in self.time_line[i] and 'Tu' in days:
                self.time_line[i].append('Tu')
            if 'We' not in self.time_line[i] and 'We' in days:
                self.time_line[i].append('We')
            if 'Th' not in self.time_line[i] and 'Th' in days:
                self.time_line[i].append('Th')
            
    def has_conflict(self, start_time, end_time,days):
        start_time = start_time / 900
        end_time = end_time / 900
        for i in range(start_time, end_time):
            if (('Mo' in self.time_line[i] and 'Mo' in days) or
                ('Tu' in self.time_line[i] and 'Tu' in days) or
                ('We' in self.time_line[i] and 'We' in days) or
                ('Th' in self.time_line[i] and 'Th' in days)):
                return True
        return False
        
    def clear(self):
        # 清空时间线
        self.time_line = [0 for _ in range(1000)]

def time_Check(course_list):
    time_line = [[0 for _ in range(100)] for _ in range(4)]
    for course in course_list:
        start_time = course['start_time'] / 900
        end_time = course['end_time'] / 900
        days = course['days']
        if 'Mo' in days:
            time_line[0][start_time] = 1
            time_line[0][end_time + 1] = -1
        if 'Tu' in days:
            time_line[1][start_time] = 1
            time_line[1][end_time + 1] = -1
        if 'We' in days:
            time_line[2][start_time] = 1
            time_line[2][end_time + 1] = -1
        if 'Th' in days:
            time_line[3][start_time] = 1
            time_line[3][end_time + 1] = -1
    for i in range(4) :
        for j in range(100):
            time_line[i][j] += time_line[i][j - 1]
            if (time_line[i][j] > 1):
                return False
    return True