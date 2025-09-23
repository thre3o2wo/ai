#ch05.py (ch05 모듈)
#ctrl+shft+p → select interpreter (패스 선정 안 했을 때)
#실행은 cmd 터미널(ctrl+j)에서 python ch05.py 
#vsCode에서 자동완성핫키: ctrl+space
def my_hello(cnt): #cnt회 반복
    print(__name__)
    for i in range(cnt):
        print('Hello, Python', end='\t')
        print('Hello, World')
if __name__ == '__main__':
    my_hello(2)