/* array 함수 : 가변인자 함수 (파이썬 튜플매개변수로 구현)
 * 매개변수가 0개 : length가 0 인 배열 return
 * 매개변수가 1개 : length가 매개변수만큼의 크기인 배열 return
 * 매개변수가 2개 이상 : 배개변수로 배열을 생성 return */
function array() { //arguments(매개변수 배열) : 매개변수의 내용
    let result = []; //length==0 이면 이대로 return
    if(arguments.length==1) {
        //result를 arguments[0] 만큼의 크기인 배열로 : result.push(null)를 arguments[0]회
        // for(let cnt=1; cnt <= arguments[0]; cnt++) {
        //     result.push(null);
        // }
        result.length = arguments[0]; //크기만 잡기
    } else if(arguments.length >= 2) {
        //result를 arguments 내용의 배열로 : result.push(arguments[first(0)~last])
        // for(let idx=0; idx<arguments.length; idx++) {
        //     result.push(arguments[idx]);
        // }
        // for(let idx in arguments) {
        //     result.push(arguments[idx]);
        // }
        for(let data of arguments) {
            result.push(data);
        }
    }
    return result;
}
var arr1 = array();
var arr2 = array(5);
var arr3 = array(1, 2, 3, 10);
console.log(arr1);
console.log(arr2);
console.log(arr3);