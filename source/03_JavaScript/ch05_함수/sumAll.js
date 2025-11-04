function sumAll() {
    if(arguments.length == 0) {
        return -999;
    } else {
        let sum = 0;
        // for(let idx in arguments) {
        //     sum += arguments[idx];
        // }
        for(let data of arguments) {
            sum += data;
        }
        return sum;
    }
}