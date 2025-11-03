// false로 해석되는 값: 0, "", NaN, null, undefined
// cf. [] 빈 배열은 True로 해석
var i;
console.log(Boolean(i));
console.log(Boolean(0));
console.log(Boolean(NaN));
console.log(Boolean(Number("a")));
console.log(Boolean(""));
console.log(Boolean(null));
console.log();
console.log("0==false의 결과: ", 0==false); //true
console.log("0===false의 결과: ", 0===false); //false
// ctrl + j (터미널 창) node 파일명