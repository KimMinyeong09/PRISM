"""
본 웹크롤링은 krx.esg에서 가져온 데이터들을 아래 엔티티들에 맞춰준다.
#가져오는 데이터는 오직 코스피200에 포함되는 회사
#Output 파일구조

"""
URL = "https://esg.krx.co.kr/contents/02/02020000/ESG02020000.jsp"
BASE_URL = "https://esg.krx.co.kr"
#해당 리스트안에 있는 esg기관들의 등급을 가져옴
ESGINTITUDE_ENTITY = {
    #"KCGS" : "KCGS_SCORE",
    "한국ESG연구소" : "ESGLAB_SCORE",
    #"Moody's" : "MOODYS_SCORE",
    #"MSCI" : "MSCI_SCORE",
    #"S&P" : "SANDP_SCORE",
}
DATABASE_FRAME = {
    "COMPANY":[
        "Company_id",#!!!krx.esg에서 사용하는 회사 id인 isu_cd를 엔티티가 COMPANY인 테이블의 Company_id로 사용
        "Name",
        "Industry", #!!!!!!구현안됨
    ],
    "ESGLAB_SCORE":[
        "Esglab_score_id",
        "Company_name",#한국 ESG 연구소 등급을 산정하는 기업의 이름
        "Company_industry",# 기업이 속한 업종
        "Eval_year",# 등급 평가가 이루어진 연도
        "Overall_score",# ESG 성과를 기준으로 기업에 부여하는 종합점수
        "E_score",# 기업에 부여된 E(환경) 점수
        "S_score",# 기업에 부여된 S(사회) 점수
        "G_score",# 기업에 부여된 G(거버넌스) 점수
    ],
    "SUSTAIN_REPORT":[
        "Sustain_report_id",
        "Year",#지속가능경영보고서 발행 연도
        "Company",# 발행 기업
        "Download_link",# 지속가능경영보고서를 다운로드 받을 수 있는 링크
    ],
}


from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup
import requests
import sys
import io
import time
import random
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
import csv
import pandas as pd
import os

# 현재 실행 파일의 경로를 가져옵니다
current_file_path = os.path.abspath(__file__)
# 현재 실행 파일의 디렉토리 경로를 가져옵니다
current_directory = os.path.dirname(current_file_path)
# 작업 폴더를 현재 실행 파일의 디렉토리로 변경합니다
os.chdir(current_directory)

def saveCsvsToFiles():
    for entity_name, entity in buffers.items():
        entity.to_csv(entity_name + ".csv")

def savePdOneRow(entity, data_row:list, is_overwirte_last_row = False):
    """
    is_overwirte_last_row가 거짓이면 단순히 append
    is_overwirte_last_row가 진실이면 마지막행에 덮어쓰기수정
    """
    table:pd.DataFrame = buffers[entity]
    if is_overwirte_last_row:
        table.loc[len(table)-1] = data_row
    else:
        table.loc[len(table)] = data_row

def parsingDataForESG(company_name, raw_data:list) -> list:
    """
    [KCGS,2022,B+,B+,A+,B]을 다음 형식으로 재맞춤한 리스트를 반환
    ["ESG기관_score_id",
    "Company_name",#한국 ESG 연구소 등급을 산정하는 기업의 이름
    "Company_industry",# 기업이 속한 업종
    "Eval_year",# 등급 평가가 이루어진 연도
    "Overall_score",# ESG 성과를 기준으로 기업에 부여하는 종합점수
    "E_score",# 기업에 부여된 E(환경) 점수
    "S_score",# 기업에 부여된 S(사회) 점수
    "G_score",# 기업에 부여된 G(거버넌스) 점수
    ]
    """
    return [company_name, None, raw_data[1], raw_data[2], raw_data[3], raw_data[4], raw_data[5]]

def parsingRanks(raw_data:list) -> dict:
    """
    ['KCGS : A', '한국ESG연구소 : S', "Moody's : -", 'MSCI : BBB', 'S&P : 11']
    을 딕셔너리형태인
    {
        "KCGS" : "A",
        "한국ESG연구소" : "S",
        "Moody's" : "-",
        "MSCI" : "BBB",
        "S&P" : "11"
    }으로 변환해주는 함수
    """
    data = {}
    for element in raw_data:
        temps = element.split(" : ")
        data[temps[0]] = temps[1]
    return data
driver = webdriver.Chrome()
driver.set_window_size(958, 919)
driver.get(URL)
driver.implicitly_wait(10)
time.sleep(4+random.random())

html = driver.page_source

soup = BeautifulSoup(html, "html.parser")

#csv파일에 들어갈 내용들
buffers = {}
#pds는 key가 DATABASE_FRAME의 엔티티이고, value를 해당 엔티티의 pd데이터프레임으로 이루어진 딕셔너리
for entity, attributes in DATABASE_FRAME.items():
    temp = pd.DataFrame(columns=attributes[1:])
    buffers[entity] = temp
  
link_detail = None
isu_cd = None

#아래부터 리스트페이지 : ESG연구소 자료가 있는 회사의 링크들만 모조리 저장
link_details = {}
next_button = driver.find_element(By.CLASS_NAME, "next")
now_page = 1
while True:
    time.sleep(1+random.random()*2)
    html = driver.page_source
    soup = BeautifulSoup(html, "html.parser")
    rows = soup.find("tbody").select("tr")
    for row in rows:
        if row.select_one("td>span.kesg").get_text() == "-":
            continue
        #한국ESG연구소 랭크가 표기되어있다면
        a_href = row.find(attrs = {"name" : "com_abbrv"}).find("a")
        company = a_href.get_text()
        print(f"    {company} 추가...")
        link_detail = a_href["href"]
        link_details[link_detail] = company
    print(f"{now_page}페이지 스캔완료..")
    now_page+=1
    next_button = driver.find_element(By.CLASS_NAME, "next")
    #마지막페이지에선 다음버튼이 비활성화되어있음. 그땐 반복 탈출
    if next_button.get_dom_attribute("class").find("disabled") != -1:
        break
    next_button.click()

for company in link_details.values():
    savePdOneRow("COMPANY", [company, None])
import pickle
with open("cache\LinkAndCompany.pkl", "wb") as f:
    pickle.dump(link_details, f)

#아래부터 해당 회사 디테일페이지
error_company = []
for link_detail, company in link_details.items():
    print(f"{company} 회사 페이지 작업중...")
    driver.get(BASE_URL + link_detail)
    driver.implicitly_wait(10)
    time.sleep(2+random.random())
    html = driver.page_source
    soup = BeautifulSoup(html, "html.parser")
    #페이지에서 그래프에서 모든년도 데이터 들고옴
    graph_esg = driver.find_element(By.CLASS_NAME, "chart-box")
    action = ActionChains(driver)
    action.move_to_element(graph_esg)
    action.move_by_offset(-100, 0)
    graph_popups = {}
    for x in range(10):
        action.move_by_offset(20, 0).perform()
        time.sleep(0.3+random.random()/4)
        soup = BeautifulSoup(driver.page_source, "html.parser")
        graph_popups[soup.select_one(".tip-xaxis").get_text()] = soup.select_one(".tip-yaxis").find_all(text=True)
    """graph_popup_texts 예시
    {'2021': ['KCGS : A', '한국ESG연구소 : S', "Moody's : -", 'MSCI : BBB', 'S&P : 11'],
    '2022': ['KCGS : A', '한국ESG연구소 : A', "Moody's : 23", 'MSCI : BBB', 'S&P : 58'],
    '2023': ['KCGS : -', '한국ESG연구소 : -', "Moody's : 23", 'MSCI : BBB', 'S&P : -']}
    """
    for year, ranks_unparsed in graph_popups.items():
        ranks = parsingRanks(ranks_unparsed)
        for ins, rank_all in ranks.items():
            #ranks의 예시 {'KCGS': 'A', 'MSCI': 'BBB', "Moody's": '-', 'S&P': '11', '한국ESG연구소': 'S'}
            if rank_all == "-":
                continue
            try:
                #우리가 가져오기로 설정한 기관에서만 가져옴
                savePdOneRow(ESGINTITUDE_ENTITY[ins], parsingDataForESG(company, [ins, year, rank_all, None, None, None]))
            except: pass
    #위의 표에서 최근년도 e,s,g구해서 열 덮어쓰기
    tables = driver.find_element(By.ID, "company_table")
    esg_table = None
    for table in tables.find_elements(By.TAG_NAME, "table"):
        if table.text.strip() != "":
            esg_table = table
    if esg_table == None:
        print(f"!!!!!!!!!!!!!!!{company} rank테이블 로드 오류!")
        error_company.append(company)
        continue
    esg_rows = esg_table.find_element(By.TAG_NAME, "tbody").find_elements(By.TAG_NAME, "tr")
    for erow in esg_rows:
        temp = []
        for ecol in erow.find_elements(By.TAG_NAME, "td"):
            if ecol.text == company:
                continue
            temp.append(ecol.text)
            try:
                savePdOneRow(ESGINTITUDE_ENTITY[temp[0]], parsingDataForESG(company, temp), True)
            except: pass
driver.quit()
saveCsvsToFiles()
if len(error_company) != 0:
    print("[Error] 다음 회사들에서 문제가 있어서 ESGLAB_SCORE에 반영이 안되었습니다.")
    for e in error_company:
        print("  " + e)
print("같은 폴더 내에 COMPANY.csv, ESGLAB_SCORE.csv가 저장되었습니다!")