# vscode에서 ctrl + shift + p → Python: Select Interpreter → llm 가상환경 선택
# (실행) ctrl+j : 터미널 → cmd에서 streamlit run 2_streamlit.py
# (종료) 터미널에서 ctrl+c
import streamlit as st

st.set_page_config(page_title='첫 번째 데모') # 페이지타이틀

st.title('나의 첫 stream 웹')
st.header("웹 앱을 만들기 위한 강력하고 사용하기 쉬운 라이브러리") # almost h1 태그
st.subheader('Streamlit에 오신 것을 환영합니다.') # almost h6 태그
st.text('이 부분은 일반 텍스트입니다.') # 본문
st.write('write 함수를 이용해 텍스트 표시') # 본문

st.markdown('---') # 구분선
message = st.text_area('요약 글을 입력하세요.') # 텍스트박스

if st.button('요약'):
    st.info('버튼 클릭했네?')

if prompt := st.chat_input('챗 입력 받기'):
    st.chat_message('user').write(prompt)