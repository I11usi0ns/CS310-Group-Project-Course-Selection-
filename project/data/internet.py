from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time
import logging

# 配置日志记录，便于调试
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# 配置 Selenium WebDriver
options = Options()
# options.add_argument("--headless")  # 如果需要运行无头模式，取消注释此行
options.add_argument("--disable-gpu")
options.add_argument("--window-size=1920,1080")

# ChromeDriver 的路径
driver_path = "C:\\Games\\chromedriver-win64\\chromedriver-win64\\chromedriver.exe"
service = Service(driver_path)

# 初始化 WebDriver
driver = webdriver.Chrome(service=service, options=options)

try:
    # 打开目标网站
    logging.info("正在打开目标网站...")
    driver.get("https://dkuhub.dku.edu.cn/psp/CSPRD01/EMPLOYEE/SA/s/WEBLIB_HCX_RE.H_COURSE_LIST.FieldFormula.IScript_Main?")
    
    # 确认页面加载
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, "expand-netid")))
    logging.info("页面加载成功，定位到初始按钮。")

    # 点击登录按钮
    first_button = WebDriverWait(driver, 10).until(EC.element_to_be_clickable((By.ID, "expand-netid")))
    first_button.click()
    logging.info("成功点击登录按钮。")

    time.sleep(1)

    # 等待并输入用户名和密码
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "j_username")))
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "j_password")))

    username_field = driver.find_element(By.ID, "j_username")
    password_field = driver.find_element(By.ID, "j_password")
    login_button = driver.find_element(By.ID, "Submit")  # 假设登录按钮的 ID 是 "Submit"

    username = "hs408"
    password = "746746jackJACK"

    username_field.send_keys(username)
    logging.info("用户名输入完成。")
    password_field.send_keys(password)
    logging.info("密码输入完成。")
    login_button.click()
    logging.info("点击登录按钮。")

    # 等待登录后页面加载完成
    logging.info("等待课程页面加载...")
        # Wait for the course list to load
    course_list = WebDriverWait(driver, 20).until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, "li.cx-MuiGrid-root.cx-MuiGrid-item"))
    )

    # Extract course codes
    for course in course_list:
        try:
            course_code_element = course.find_element(By.CSS_SELECTOR, "p.cx-MuiTypography-body1 span[aria-hidden='false']")
            print(f"Course Code: {course_code_element.text}")
        except Exception as e:
            print(f"Failed to retrieve course code: {e}")

except Exception as e:
    print(f"An error occurred: {e}")

finally:
    # Close WebDriver
    driver.quit()