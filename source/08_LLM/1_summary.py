# ctrl + shift + p → Python: Select Interpreter → llm 가상환경 선택
# ctrl + j 터미널 실행
### 내일(1211 thur 예정) 웹버전 - 입력된 데이터를 요약해서 보여 주기
from dotenv import load_dotenv
from openai import OpenAI
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

if __name__=='__main__':
    message = input('요약할 글을 입력하세요: ')
    if message:
        prompt = f'''your task is to summarize the text sentences in Korean language.
        Summarize in 1 line. Use the format of a bullet point.
        text: {message}'''
        result = askGPT(prompt)
        print('↓ ↓ ↓ 요약 내용 ↓ ↓ ↓')
        print(result)