var arr = [2, 3, '홍길동', function(){}, [1,2], {'0':273, '1':'hello'}]; 
//python의 list와 매우 유사
console.log('arr의 타입: ', typeof(arr) + ' /값: ', arr)
console.log(0 + ':' + arr[0]);
console.log(1 + ':' + arr[1]);
console.log(2 + ':' + arr[2]);
console.log(3 + ':' + arr[3]);
console.log(4 + ':' + arr[4]);
console.log(5 + ':' + arr[5]);
console.log(6 + ':' + arr[6]); //undefined
arr.push('제일 끝 방에 추가');
console.log(6 + ':' + arr[6]);
var value = arr.pop(); // 제일 끝방의 값을 return하고 없앰
console.log(6 + ':' + arr[6]); //undefined
console.log('삭제된 값:', value); //'제일 끝 방에 추가'