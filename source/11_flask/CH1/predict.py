# predict.py 파일
# 가상환경 만들기 : python -m venv .venv : .venv 가상환경 생성
# 가상환경 들어가기 : .venv\Scripts\activate
# pip 업그레이드 : python -m pip install --upgrade pip
    # pip install statsmodels joblib
    # pip install xlwings
    # pip install flask
# pip freeze > requirements.txt (프로젝트별 버전 공유)
# requirements.txt의 라이브러리를 그대로 설치 : pip install -r requirements.txt
# .gitignore에 .venv/와 .idea/추가

import pandas as pd
import statsmodels.api as sm #회귀모델
import joblib #joblib로 모델 save / 모델 load

loaded_model = joblib.load('model/pApt.joblib')
def predict_apt_price(year, square, floor):
    input_data=[[int(year), int(square), int(floor), 1]]
    result = round(loaded_model.predict(input_data)[0] * 10000)
    return format(result, ',') + '원입니다.'

if __name__=="__main__":
    year = input('몇 년도? ')
    square = input('몇 제곱미터? ')
    floor = input('몇 층? ')
    print('예측한 금액은 ', predict_apt_price(year, square, floor))