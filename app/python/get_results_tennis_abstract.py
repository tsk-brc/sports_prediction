import time

from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

url_path = "https://tennisabstract.com/reports/wtaRankings.html"

# FireFox Optionsの設定
options = Options()
# ヘッドレスモードを有効にする
options.headless = True
# Firefoxのバイナリパスを指定する
options.binary_location = "/Applications/Firefox.app/Contents/MacOS/firefox"
# WebDriverを起動する
driver = webdriver.Firefox(options=options)
# ドライバが設定されるまでの待機時間(秒)
driver.implicitly_wait(10)
driver.get(url_path)

# 1秒待機
time.sleep(1)
# ページ上のすべての要素が読み込まれるまで10秒待機
wait = WebDriverWait(driver, 10)
wait.until(EC.presence_of_all_elements_located((By.TAG_NAME, "body")))

# SeleniumでページのHTMLを取得
html = driver.page_source
soup = BeautifulSoup(html, "html.parser")

# リンクを取得
links = soup.find_all("a", href=True)

# 各リンクにアクセスしてデータを取得
for link in links:
    url = link["href"]
    # URLが適切であることを確認
    if "https://www.tennisabstract.com/cgi-bin" in url:
        # TODO: データの取得処理を実装
        print(f"Accessing {url}")
        try:
            # 1秒待機
            time.sleep(1)
        except Exception as e:
            print(f"Failed to access {url}: {str(e)}")

# Chrome Driverを終了する
driver.close()
driver.quit()

print("データの取得が完了しました。")
