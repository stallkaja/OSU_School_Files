'use strict';
// Don't add or change anything above this comment.

/*
* Don't change the declaration of this function.
*/
const reducer1 = (previousValue, currentValue) => {
    //  Write your code here
	if(typeof(currentValue)!="number" && typeof(previousValue)!="number"){
		return 0;
	}
	else if(typeof(currentValue)!="number"){
		return previousValue
	}
	else if(typeof(previousValue)!="number"){
		return currentValue
	}
	else{
		return currentValue+previousValue;
	}
	
};

/*
* Don't change the declaration of this function.
*/
const reducer2 = (previousValue, currentValue) => {
    //  Write your code here
	if(typeof(previousValue)!="number" || typeof(currentValue)!="number") {
		throw new TypeError();
	}
	else {
		return previousValue+currentValue;
	}
};


// Don't add or change anything below this comment.
module.exports = { reducer1, reducer2 };