import re
import csv # fn5_save_customer_csv를 위해 import

# ============== 1. 클래스 및 유틸리티 정의 ==============

class NonPositiveIntError(Exception):
    """나이나 등급이 0 이하의 숫자가 입력되었을 때 발생하는 예외."""
    pass

class Customer:
    def __init__(self, name, phone, email, age, grade, etc):
        self.name = name
        self.phone = phone
        self.email = email
        self.age = int(age)
        # grade와 age는 int로 강제 변환
        self.grade = int(grade) 
        self.etc = etc
        
    def as_dic(self): # 객체를 딕셔너리 데이터로 반환
        return self.__dict__
        
    def to_txt_style(self): # 객체를 TXT 저장 포맷으로 변환 (직렬화)
        # 모든 속성 값을 쉼표와 공백으로 구분된 문자열로 반환하며, \n을 붙여 한 줄로 만듭니다.
        return f"{self.name}, {self.phone}, {self.email}, {self.age}, {self.grade}, {self.etc}\n"
        
    def __str__(self):
        return "{:>5}\t{:^3}\t{:^13}\t{:^10}\t{}\t{}".format(
            '*' * self.grade, self.name, self.phone, self.email, self.age, self.etc
        )
    
    def __repr__(self):
        return f"Customer('{self.name}', grade={self.grade})"

# 파일의 한 줄 문자열을 Customer 객체로 변환
def to_customer(row):
    try:
        # 파일에서 읽을 때는 strip()으로 줄 바꿈 문자 제거
        data = row.strip().split(', ') 
        if len(data) < 6:
             raise ValueError("데이터 항목 개수 부족")

        # Age와 Grade는 반드시 정수로 변환
        age = int(data[3])
        grade = int(data[4])
        
        return Customer(data[0], data[1], data[2], age, grade, data[5])
    
    except ValueError as e:
        print(f"⚠️ 데이터 변환 오류: '{row.strip()}' - Age/Grade 항목이 숫자가 아니거나 형식이 잘못되었습니다. ({e})")
        return None # 변환 실패 시 None 반환

# ============== 2. DB 및 파일 I/O 함수 ==============

# 0. 고객목록 로딩
def load_customers():
    """파일에서 고객 정보를 읽어 Customer 객체 리스트로 반환"""
    filepath = 'data/ch09_customers.txt'
    customer_list = []
       
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            for line in lines:
                customer = to_customer(line)
                if customer: # 변환에 성공한 객체만 추가
                    customer_list.append(customer)
    except FileNotFoundError:
        # 파일이 없을 경우 빈 파일을 생성하고, 빈 리스트 반환
        with open(filepath, 'w', encoding='utf-8') as f:
            pass 
            
    return customer_list

# fn9. 텍스트 파일에 저장 (프로그램 종료 시 호출)
def fn9_save_customer_txt(customer_list):
    """Customer 객체 리스트를 텍스트 파일에 저장"""
    filepath = 'data/ch09_customers.txt'
    try:
        with open(filepath, 'w', encoding='utf-8') as f:
            for customer in customer_list:
                # to_txt_style() 메서드를 호출하고 반환된 문자열을 파일에 씁니다.
                f.write(customer.to_txt_style()) 
        print(f"\n✅ {len(customer_list)}명의 고객 정보가 '{filepath}'에 저장되었습니다.")
    except Exception as e:
        print(f"❌ 파일 저장 중 오류 발생: {e}")

# ============== 3. 메뉴별 기능 구현 ==============

# 정규표현식 패턴 컴파일 (앵커 ^ $ 추가)
NAME_PATTERN = re.compile(r"^[가-힣]{2,5}$|^[a-zA-Z ]{3,20}$") 
PHONE_PATTERN = re.compile(r"^(\d{2,3})-(\d{3,4})-(\d{4})$") # 앵커 추가
EMAIL_PATTERN = re.compile(r"^\w+@\w+(\.\w+){1,2}$") # 앵커 추가

# fn1. 입력
def fn1_insert_customer_info():
    '''1. 고객정보 입력 및 유효성 검사'''
    
    # [이름 입력]
    while True:
        input_name = input("이름: ")
        if NAME_PATTERN.fullmatch(input_name): 
            name = input_name
            break
        else:
            print("❌ 이름 형식이 부적절합니다. 한글 2~5자 또는 영문 3~20자만 입력 가능합니다.")

    # [전화번호 입력]
    while True:
        input_phone = input("전화번호 (예: 010-1234-5678): ")
        if PHONE_PATTERN.fullmatch(input_phone):
            phone = input_phone
            break
        else:
            print("❌ 전화번호 형식이 맞지 않습니다. (예: 010-0000-0000)")

    # [이메일 입력]
    while True:
        input_email = input("이메일: ")
        if EMAIL_PATTERN.fullmatch(input_email):
            email = input_email
            break
        else:
            print("❌ 이메일 형식이 맞지 않습니다. (예: user@domain.com)")

    # [나이 입력]
    while True:
        try:
            age = int(input("나이: "))
            if age <= 0:
                raise NonPositiveIntError
            break
        except ValueError:
            print("❌ 나이는 반드시 유효한 정수(숫자)로 입력해야 합니다.")
        except NonPositiveIntError:
            print("❌ 나이는 0보다 큰 값이어야 합니다.")
        # 일반적인 except Exception 블록을 제거하여 에러 처리 명확성을 높였습니다.
            
    # [고객등급 입력]
    while True:
        try:
            grade = int(input("고객등급(1~5): "))
            if 1 <= grade <= 5:
                break
            else:
                print("❌ 고객등급은 1부터 5 사이의 정수여야 합니다.")
        except ValueError:
            print("❌ 고객등급은 반드시 정수(숫자)로 입력해야 합니다.")

    # [기타]
    etc = input("기타 정보: ")
    
    return Customer(name, phone, email, age, grade, etc)

# fn2. 전체 출력
def fn2_print_customers(customer_list):
    '''customer_list 출력'''
    if not customer_list:
        print("\n⚠️ 현재 고객 목록이 비어 있습니다. (1.입력 메뉴로 추가하세요)")
        return
        
    print('\n' + '='*70)
    print('{:^70}'.format('고객 정보'))
    print('='*70)
    print("{:>5}\t{:^3}\t{:^13}\t{:^10}\t{}\t{}".format('grade','이름','전화','메일','나이','기타') )
    print('-'*70)
    for customer in customer_list:
        print(customer) # __str__ 호출
    print('-'*70)


# fn3. 삭제
def fn3_delete_customer(customer_list):
    '''타겟 이름을 입력받아 고객 DB에서 제거, 동명이인 있을 경우 확인 절차'''

    target_name = input('DB에서 삭제할 고객 이름을 입력하세요: ')
    
    # 1. 검색: 타겟 이름과 일치하는 모든 객체와 인덱스 찾기
    matches = [(i, c) for i, c in enumerate(customer_list) if c.name == target_name]
    
    if not matches:
        print(f"❌ '{target_name}' 고객을 찾을 수 없습니다.")
        return

    target_idx = -1 

    # 2. 선택/확인: 일치하는 고객이 한 명 이상일 경우
    print(f"\n'{target_name}' 고객 {len(matches)}명을 찾았습니다.")
    
    if len(matches) > 1:
        print("↓↓삭제할 대상 선택↓↓")
        for i, (original_idx, customer) in enumerate(matches):
             # 고객 식별에 필요한 정보만 간결하게 출력
             print("[{}] 등급: {:>5} | 전화: {:^13} / 내부 인덱스 {}".format(
                 i, '*'*customer.grade, customer.phone, original_idx
             ))
        
        # 선택 번호 입력 루프
        while True:
            try:
                choice = input("삭제할 고객의 번호를 입력하세요(0부터 시작, q:취소): ")
                
                if choice.lower() == 'q':
                    print("삭제를 취소했습니다.")
                    return
                
                choice_idx = int(choice)
                if 0 <= choice_idx < len(matches):
                    target_idx = matches[choice_idx][0] # 삭제할 최종 인덱스
                    break
                else:
                    print("잘못된 번호입니다. 다시 입력해주세요.")
            except ValueError:
                print("숫자 또는 'q'만 입력해주세요.")
    else: # 일치하는 고객이 한 명일 경우
        target_idx = matches[0][0]
        
    # 3. 최종 확인: 삭제할 것이 분명한지 Y/N 확인 절차
    print("-" * 30)
    confirm_obj = customer_list[target_idx] 
    
    while True:
        confirm = input(f"'{confirm_obj.name}' 고객 (등급: {confirm_obj.grade}, 인덱스: {target_idx})을(를) 정말로 삭제하시겠습니까? (Y/N): ").upper()
        
        if confirm == 'Y':
            # 4. 삭제 실행
            del customer_list[target_idx]
            print(f"\n✅ 삭제 완료: '{confirm_obj.name}' 고객이 리스트에서 제거되었습니다.")
            return # 함수 종료
        elif confirm == 'N':
            print("삭제를 취소했습니다.")
            return # 함수 종료
        else:
            print("Y 또는 N으로만 응답해주세요.")


# fn4. 이름 찾기
def fn4_search_customer(customer_list):
    '''이름을 입력받아 해당 고객 정보 출력'''
    target_name = input('검색할 고객 이름을 입력하세요: ')
    
    found_customers = [c for c in customer_list if c.name == target_name]
    
    if not found_customers:
        print(f"❌ '{target_name}' 고객을 찾을 수 없습니다.")
        return
        
    print(f"\n✅ '{target_name}' 고객 {len(found_customers)}명을 찾았습니다.")
    
    # fn2의 출력 포맷을 사용하기 위해 헤더를 다시 출력
    print('='*70)
    print('{:^70}'.format(f"'{target_name}' 검색 결과"))
    print('='*70)
    print("{:>5}\t{:^3}\t{:^13}\t{:^10}\t{}\t{}".format('grade','이름','전화','메일','나이','기타') )
    print('-'*70)
    
    for customer in found_customers:
        print(customer) # __str__ 호출
    print('-'*70)
    

# fn5. 내보내기 (CSV)
def fn5_save_customer_csv(customer_list):
    '''고객 정보를 CSV 파일로 저장'''
    filepath = 'data/ch09_customers_export.csv'
    
    if not customer_list:
        print("⚠️ 저장할 고객 목록이 비어 있습니다.")
        return
        
    try:
        with open(filepath, 'w', newline='', encoding='utf-8') as f:
            # csv.writer를 사용하여 쉼표 구분 파일을 정확하게 생성합니다.
            writer = csv.writer(f)
            
            # 1. 헤더 (컬럼 이름) 쓰기
            header = ["name", "phone", "email", "age", "grade", "etc"]
            writer.writerow(header)
            
            # 2. 데이터 쓰기
            for customer in customer_list:
                # as_dic()으로 딕셔너리를 얻은 후 values()로 값만 추출
                row_data = list(customer.as_dic().values())
                writer.writerow(row_data) 
                
        print(f"\n✅ {len(customer_list)}명의 고객 정보가 CSV 형식으로 '{filepath}'에 저장되었습니다.")
        
    except Exception as e:
        print(f"❌ CSV 파일 저장 중 오류 발생: {e}")


# ==================== MAIN 함수 ====================
def main():
    global customer_list
    customer_list = load_customers() # ch09_customers.txt의 내용을 load
    while True:
        print("\n" + "="*70)
        print("1:입력", "2:전체출력", "3:삭제", "4:이름찾기", "5:내보내기(CSV)", "9:종료", sep=' | ', end=' ')
        print("\n" + "="*570)
        try:
            fn = input('메뉴선택 : ')
            if not fn.isdigit():
                 raise ValueError
                 
            fn = int(fn)
            
            if fn == 1:
                customer = fn1_insert_customer_info()
                customer_list.append(customer)
            elif fn == 2:
                fn2_print_customers(customer_list)
            elif fn == 3:
                fn3_delete_customer(customer_list)
            elif fn == 4:
                fn4_search_customer(customer_list)
            elif fn == 5:
                fn5_save_customer_csv(customer_list)
            elif fn == 9:
                # 9번 선택 시, 저장 후 루프 탈출
                fn9_save_customer_txt(customer_list) 
                break
            else:
                print("❌ 유효한 메뉴 번호를 선택해 주세요.")
                
        except ValueError:
            print("❌ 숫자만 입력하거나, 유효한 메뉴를 선택해 주세요.")

if __name__ == '__main__':
    main()
