// 1. 익명함수 기본형
let funcVar = function() { //매개 변수가 있으나 없으나 같음
    console.log('1. 일반 함수(함수표현식 문법 format)');
    console.log('명령어 여러 줄')
};
funcVar();
// 2. 화살표 함수 no var 2 commands
funcVar = () => {
    console.log('2. 매개변수 없는 2줄 짜리 화살표 함수');
    console.log('명령어 여러 줄')
};
funcVar();
// 3. 화살표 함수 1 var 2 commands
//매개변수 하나인 경우 대개 괄호를 없앰
funcVar = a => { 
    console.log('3. 매개변수 1개인 2줄 짜리 화살표 함수');
    console.log('a = '+a);
};
funcVar(10);
// 4. 화살표 함수 1 var 1 command
// 명령어 블록에 명령어가 1줄, 여러 줄 있을 때 
funcVar = a => console.log('4. 매개변수 1개인 1줄 짜리 화살표 함수. a = '+a); //명령어 한 줄 짜리인 경우 중괄호도 생략 가능
funcVar(20);
// 5. 화살표 함수 1 var 1 return
// return 한 줄 짜리는 return을 생략
funcVar = function(a) {
    return a*a;
}; //아래와 같음
funcVar = a => a*a; //위와 같음
console.log('5. 매개변수 1개, return문 1줄 있는 화살표 함수 호출 결과 :', funcVar(5));
// 6. 화살표 함수 2 vars 1 return
funcVar = function(a, b) {
    return a*10 + b;
}; //아래와 같음
funcVar = (a, b) => a*10 + b; //위와 같음
console.log('6. 매개변수 2개, return문 1줄 있는 화살표 함수 호출 결과 :', funcVar(5,4));