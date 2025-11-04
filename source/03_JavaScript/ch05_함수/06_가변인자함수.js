// 가변인자함수 : 매개변수 개수에 따라 변하는 함수. 화살표함수에서는 불가
// 내장함수 Array()
var arr1 = [1, 2, '삼'];
var arr2 = Array(1, 2, '삼');
var arr3 = [ , , , ]; // 방의 갯수가 3개인 빈 배열
var arr4 = Array(3); // 변수를 하나만 넣으면 배열에 한 값만 넣는 게 아니라, 방의 개수로 처리
var arr5 = [];
var arr6 = Array();
console.log(arr1); 
console.log(arr2); 
console.log(arr3); 
console.log(arr4); 
console.log(arr5); 
console.log(arr6); 