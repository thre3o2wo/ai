# 인터프리터 선택(ctrl+shift+p → Python: Select Interpreter → llm 가상환경 선택)
# (실행) ctrl+j : 터미널 → cmd에서 streamlit run 7_aibot.py
# docs.streamlit.io
import streamlit as st
from ai_llm import ask_with_reference_rerank

st.set_page_config(page_title='소득세 챗봇', page_icon="🤖")
st.title('💰 소득세 챗봇')
st.caption('소득세 챗봇을 이용해 질문에 답변하고 참조 조항을 함께 반환합니다.')

# 저장될 대화 이력을 초기화
if 'messages' not in st.session_state:
    st.session_state.messages = []
# 대화 이력 표시
for msg in st.session_state.messages:
    st.chat_message(msg['role']).write(msg['content'])

# 사용자 질문을 받아 출력하고 session에 추가
if user_question := st.chat_input(placeholder='소득세와 관련한 질문을 입력하세요.'):
    st.chat_message('user').write(user_question)
    st.session_state.messages.append(
        {'role':'user', 'content':user_question}
    )
    # AI 응답을 받아 출력하고 session에 추가
    with st.spinner('질문에 대한 응답을 생성하는 중입니다...'):
        answer = ask_with_reference_rerank(user_question, chat_history=st.session_state.messages[:-1]) # 직전 최종 질문까지 전달
        st.chat_message('ai').write(answer)
        st.session_state.messages.append(
            {'role':'ai', 'content':answer}
        )