// 자료형 : string, number, boolean, function, object
var variable;
console.log('1. variable 타입 : ', typeof(variable), ' - 값: ', variable);
// 미할당 변수에 대해서는 undefined로 출력
variable = '이름은 "홍길동"입니다';
console.log('2. variable 타입 : ', typeof(variable), ' - 값: ', variable);
variable = -3131313131.2323;
console.log('3. variable 타입 : ', typeof(variable), ' - 값: ', variable);
variable = false;
console.log('4. variable 타입 : ', typeof(variable), ' - 값: ', variable);
variable = function() {
    alert('함수 속');
};
console.log('5. variable 타입 : ', typeof(variable), ' - 값: ', variable);
variable = {'name':'홍길동', 'age':20};
console.log('6. variable 타입 : ', typeof(variable), ' - 값: ', variable); // object=객체 not 딕셔너리
variable = ['홍길동', 10, function(){}, true, {'name':'홍길동'}, [1,2,3]] // 0,1,2 인덱스에 대한 object로 인식
console.log('7. variable 타입 : ', typeof(variable), ' - 값: ', variable.name, variable.age);