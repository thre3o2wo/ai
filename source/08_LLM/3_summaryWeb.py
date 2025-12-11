# 인터프리터 선택 ctrl+shift+p
# ctrl+j → streamlit run 3_summaryWeb.py
import streamlit as st
from openai import OpenAI
from dotenv import load_dotenv
import os

def askGPT(prompt):
    "GPT에게 요청해 prompt 내용의 한 줄 요약 return"
    load_dotenv()
    client = OpenAI()
    response=client.chat.completions.create(
        model='gpt-4.1-nano',
        messages=[
            {'role':'system', 'content':'당신은 한국어 텍스트를 잘 요약하는 전문 어시스턴트입니다.'},
            {'role':'user', 'content':prompt}
        ]
    )
    return response.choices[0].message.content

def main():
    ''
    load_dotenv()
    st.set_page_config(page_title='요약 프로그램')
    # st.text(os.getenv('OPENAI_API_KEY'))
    st.header('요약 프로그램')
    st.markdown('---')
    message = st.text_area('요약할 글을 입력하세요.')
    if st.button('summarize'):
        prompt = f'''your task is to summarize the text sentences in Korean language.
        Summarize in 1 line. Use the format of a bullet point.
        text: {message}'''
        st.info(askGPT(prompt=prompt))

if __name__=='__main__':
    main()