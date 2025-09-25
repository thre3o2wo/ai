#ctrl+shft+p → select interpreter → base
#ctrl+j → cmd 
def fibonacci_print(n):
    "매개변수로 들어온 n값 미만의 피보나치 수열을 출력하는 함수"
    a, b = 0, 1 #함수 내에 선언한 변수: 지역 변수(↔전역 변수)
    while a < n:
        print(a, end=' ')
        a, b = b, a+b
    print() #줄바꿈
def fibonacci(n):
    "n 미만의 피보나치 수열을 리스트로 return"
    result = [] #피보나치 수열을 append 할 리스트
    a, b = 0, 1
    while a<n:
        result.append(a) #리스트에 append(추가)
        a, b = b, a+b
    return result

#피보나치 수열 관련 함수들 테스트(cmd 창에서 python fibonacci.py 100)
if __name__=="__main__":
    import sys
    if len(sys.argv) > 1:
        n = int(sys.argv[1])
    else:
        n = int(input("n? "))
    print("1. print test: ", end=' ')
    fibonacci_print(n)
    print("2. return test: ", fibonacci(n))