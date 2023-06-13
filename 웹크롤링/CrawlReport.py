from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
import requests
import sys
import io
import time
import random
import pickle
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.select import Select
import csv
import pandas as pd
from difflib import SequenceMatcher
import os

# 현재 실행 파일의 경로를 가져옵니다
current_file_path = os.path.abspath(__file__)
# 현재 실행 파일의 디렉토리 경로를 가져옵니다
current_directory = os.path.dirname(current_file_path)
# 작업 폴더를 현재 실행 파일의 디렉토리로 변경합니다
os.chdir(current_directory)
DATABASE_FRAME = {
    "SUSTAIN_REPORT":[
        "Sustain_report_id",
        "Year",#지속가능경영보고서 발행 연도
        "Company",# 발행 기업
        "Download_link",# 지속가능경영보고서를 다운로드 받을 수 있는 링크
    ],
}

def initializeWebDriver():
    #웹드라이버 초기화
    global driver
    driver = webdriver.Chrome()
    driver.set_window_size(958, 919)

def openDataOfLinkAndCompany():
    """pickle모듈을 사용해 저장한 딕셔너리
    (구조는 키가 "link", 값이 "회사명")
    를 가져와서 완벽한 url로 반환해주는 함수
    """
    try:
        f = open("cache/LinkAndCompany.pkl", "rb")
        global linkAndCompany
        linkAndCompany = pickle.load(f)
        f.close()
    except:
        print("먼저 CrawlReport.py를 실행시켜서, cache폴더 안에 CompanyAndLink.pkl파일이 생기게 해주세요!")
        exit(1)

def clickReportButton():
    button = driver.find_element(By.CLASS_NAME, "c")
    year = button.text.split()[-1]
    button.click()
    return year

def getMostSimilarForTarget(strings, target):
    #strings는 문자열의 리스트인데, 그중에서 target 유사도가 높은 문자열을 반환
    if len(strings) == 1:
        return strings[0]
    answer_bytes = bytes(target, 'utf-8')
    answer_bytes_list = list(answer_bytes)
    results = {}
    for string in strings:
        string_bytes = bytes(string.lower(), 'utf-8')
        results[string] = SequenceMatcher(None, answer_bytes_list, string_bytes).ratio()
    return max(results,key=results.get)

def getLeastSimilarForTarget(strings, target):
    #strings는 문자열의 리스트인데, 그중에서 target 유사도가 낮은 문자열을 반환
    if len(strings) == 1:
        return strings[0]
    answer_bytes = bytes(target, 'utf-8')
    answer_bytes_list = list(answer_bytes)
    results = {}
    for string in strings:
        string_bytes = bytes(string.lower(), 'utf-8')
        results[string] = SequenceMatcher(None, answer_bytes_list, string_bytes).ratio()
    return min(results,key=results.get)

def getOneCompany(url):
    driver.get(url)
    driver.implicitly_wait(8)
    #기업상세페이지 열림
    try:
        year = clickReportButton()
    except:
        return (-1, None)
    #보고서페이지열림 단, 새창으로 열린다.
    driver.switch_to.window(driver.window_handles[-1])
    driver.implicitly_wait(8)
    time.sleep(3)
    dropdown = driver.find_element(By.ID, "attachedDoc")
    temp_select = Select(dropdown)
    options = []
    for option in dropdown.find_elements(By.TAG_NAME, "option"):
        options.append(option.text)
    #option value중 "기타공개첨부서류"에 가장 가까운 항목을 선택한다.
    temp_select.select_by_visible_text(getMostSimilarForTarget(options, "기타공개첨부서류"))
    time.sleep(2)
    driver.switch_to.frame(driver.find_element(By.XPATH, '//*[@id="docViewFrm"]'))
    pdf_links = {}
    for pdf_element in driver.find_elements(By.XPATH, "/html/body/div/div/a"):
        pdf_links[pdf_element.text] = pdf_element.get_attribute("href")
    pdf_link = pdf_links[getLeastSimilarForTarget(list(pdf_links.keys()), "eng")]
    driver.close()
    driver.switch_to.window(driver.window_handles[0])
    return (year, pdf_link)
def saveCsvsToFiles():
    for entity_name, entity in buffer.items():
        entity.to_csv(entity_name + ".csv")

def savePdOneRow(data_row:list, is_overwirte_last_row = False):
    """
    is_overwirte_last_row가 거짓이면 단순히 append
    is_overwirte_last_row가 진실이면 마지막행에 덮어쓰기수정
    """
    if is_overwirte_last_row:
        buffer.loc[len(buffer)-1] = data_row
    else:
        buffer.loc[len(buffer)] = data_row

def initializeDataFrame():
    #csv파일에 들어갈 내용들
    #pds는 key가 DATABASE_FRAME의 엔티티이고, value를 해당 엔티티의 pd데이터프레임으로 이루어진 딕셔너리
    for entity, attributes in DATABASE_FRAME.items():
        buffer = pd.DataFrame(columns=attributes[1:])
    return buffer

BASE_URL = "https://esg.krx.co.kr"
buffer = None
openDataOfLinkAndCompany()
initializeWebDriver()
buffer = initializeDataFrame()
for link, company in linkAndCompany.items():
    url = BASE_URL + link
    year, download_link = getOneCompany(url)
    if year != -1:
        savePdOneRow([year, company, download_link])
        print(f"{company} 회사의 {year}년도 경영보고서 다운로드 링크는 '{download_link}'입니다.")
    else:
        print(f"[Error] {company} 회사는 지속가능경영보고서가 없어서 sustain_report.csv에 저장하지 못했습니다.")
def saveCsvsToFiles():
    buffer.to_csv(list(DATABASE_FRAME.keys())[0] + ".csv")
driver.quit()
saveCsvsToFiles()
