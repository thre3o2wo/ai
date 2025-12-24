# 가상환경 생성 방법 1: terminal → python -m venv .venv
# 가상환경 생성 방법 2: vscode → ctrl+shift+p → select interpreter 
#                       → 가상환경 만들기 → Venv(.venv로 가상환경 만들기) → 인터프리터 경로 입력 → 찾기(python.exe)
# 가상환경 생성 방법 2를 사용하면 pip upgrade와 가상환경 들어가기까지 수행
# pip install pydantic
# pip install flask
# pip freeze > requirements.txt
from flask import Flask # 앱 객체(서버) 생성 목적
from flask import render_template # html 렌더링
from flask import request # get / post 방식으로 파라미터 데이터 받기
from flask import abort # 강제 예외 발생
from models import Member # 유효성 검사를 위한 클래스 (models.py)
from filters import mask_password # (filters.py)

app = Flask(__name__)
# 필터링 추가(str → str 문자 개수만큼 *로 전환)
app.template_filter("mask_pw")(mask_password)

@app.route('/user/<name>') # /user/hong # update/delete 할 때 # 동적 라우팅 
def viewFunction_handlerFunction(name):
    return f"<h1>{name}님 환영합니다.</h1>"

@app.route('/user') # /user?name=hong # read할 때 # 파라미터로 전달 # 정적 라우팅
def get_user():
    name = request.args.get('name') # get 방식 파라미터 값 받기
    if name:
        return f"<h1>전달받은 이름 {name}님 반갑습니다.</h1>"
    else:
        abort(404)

# 에러(예외) 페이지 처리
@app.errorhandler(404)
def errorhandler(error):
    return render_template("error_page.html"), 404 # def 200

@app.route("/")
def index():
    return render_template("1_onlyget/index.html")

@app.route("/join_form")
def join_form():
    return render_template('1_onlyget/join.html')

@app.route('/join') #/join?name=이름&id=1&pw=11&addr=seoul
def join():
    name = request.args.get('name') #get 방식으로 파라미터 데이터 문자로 받기
    id   = request.args.get('id')
    pw   = request.args.get('pw')
    addr = request.args.get('addr')
    try:
        member = Member(name=name, id=id, pw=pw, addr=addr)
    except:
        return render_template("error_page.html", msg="유효하지 않은 값을 입력"), 500
    return render_template("1_onlyget/result.html", member=member)

if __name__=="__main__":
    app.run(debug=True, port=80)