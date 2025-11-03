//1초 동안 반복하는 while 구문 / do~while 구문
var cnt = 0; // 반복 횟수
var startTime = new Date().getTime(); // 시작 시점 (ms 단위)
// while(new Date().getTime() <= startTime + 1000) { //1000ms = 1s. 즉, 1초 지날 때까지
//     cnt++; //cnt 1 증가
// }
do{
    cnt++;
} while (new Date().getTime() <= startTime + 1000);
console.log('1초 동안 while문 수행한 횟수: ', cnt);