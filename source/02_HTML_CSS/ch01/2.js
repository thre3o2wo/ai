/* 
2.js : 동적인 부분 (JavaScript) (utf-8)
VisualStudioCommunity는 기본 euckr로 저장하므로, 
다른 이름으로 저장 → 인코딩하여 저장 → utf-8 선택
*/
name = prompt("이름은?", "홍길동"); // 파이썬의 name = input('이름은?')과 같은 역할. 취소하면 'null' 문자열
if (name != 'null') {
    document.write(name + '님 반갑습니다.<br>');
}