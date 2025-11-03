let num1 = 25;
let num2 = 20;
let difference = (num1>num2) ? num1-num2 : num2 - num1;
// if문 안에서 변수 정의하면 밖에서 출력 등 활용 못함
// if(num1>num2) {
//     difference = num1 - num2;
// } else {
//     difference = num2 - num1;
// }
if (num1>num2) {
    msg = '첫 번째 수가 ' + difference + '만큼 더 크다';
} else if (num1<num2) {
    msg = '두 번째 수가 ' + difference + '만큼 더 크다';
} else {
    msg = '두 수는 같다';
};
// msg = (num1>num2) ? ('첫 번째 수가 ' + difference + '만큼 더 크다') 
//                     : (num2>num1) ? '두 번째 수가 ' + difference + '만큼 더 크다' :
//                                     '두 수는 같다'
// console.log('두 수의 차이는', difference)
console.log(msg);