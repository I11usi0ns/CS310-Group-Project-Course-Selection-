from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import logging

# 配置日志记录，便于调试
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# 配置 Selenium WebDriver
options = Options()
# options.add_argument("--headless")  # 如果需要运行无头模式，取消注释此行
options.add_argument("--disable-gpu")
options.add_argument("--window-size=1920,1080")
options.add_experimental_option("excludeSwitches", ["enable-automation"])
options.add_experimental_option("useAutomationExtension", False)

# ChromeDriver 的路径
driver_path = "C:\\Games\\chromedriver-win64\\chromedriver-win64\\chromedriver.exe"
service = Service(driver_path)

# 初始化 WebDriver
driver = webdriver.Chrome(service=service, options=options)

try:
    # 打开目标网站
    logging.info("正在打开目标网站...")
    driver.get("https://dkuhub.dku.edu.cn/psp/CSPRD01/EMPLOYEE/SA/s/WEBLIB_HCX_RE.H_COURSE_LIST.FieldFormula.IScript_Main?")
    
    # 等待初始登录按钮加载并点击
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.ID, "expand-netid")))
    first_button = driver.find_element(By.ID, "expand-netid")
    first_button.click()
    logging.info("点击登录按钮。")

    # 等待用户名和密码输入框加载
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "j_username")))
    username_field = driver.find_element(By.ID, "j_username")
    password_field = driver.find_element(By.ID, "j_password")
    login_button = driver.find_element(By.ID, "Submit")

    time.sleep(1)
    # 输入用户名和密码
    username = "hs408"
    password = "746746jackJACK"
    username_field.send_keys(username)
    password_field.send_keys(password)
    logging.info("输入用户名和密码。")

    # 点击登录
    login_button.click()
    logging.info("登录成功，等待页面加载...")

    # 等待页面加载完成后获取当前 Cookie
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "app")))
    cookies = driver.get_cookies()
    logging.info(f"已提取 Cookie：{cookies}")

    # 重新加载页面并注入 Cookie 确保登录状态
    driver.get("https://dkuhub.dku.edu.cn/psp/CSPRD01/EMPLOYEE/SA/s/WEBLIB_HCX_RE.H_COURSE_LIST.FieldFormula.IScript_Main?")
    for cookie in cookies:
        driver.add_cookie(cookie)

    # 刷新页面并等待动态内容加载
    driver.refresh()
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "app")))
    time.sleep(5)  # 确保页面动态内容加载完成

    # 获取完整页面 HTML
    page_source = driver.execute_script("return document.documentElement.outerHTML;")
    file_path = "logged_in_page.html"
    with open(file_path, "w", encoding="utf-8") as file:
        file.write(page_source)
    logging.info(f"页面 HTML 已保存到本地文件：{file_path}")

except Exception as e:
    logging.error(f"发生错误：{e}")

finally:
    # 关闭 WebDriver
    driver.quit()
