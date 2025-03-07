'use strict';
// Don't add or change anything above this comment.

/*
* Don't change the declaration of this function.
*/
function deepEqual(val1, val2) {
	
	if ( val1 === null && val2 === null) {
		return true; //both are null
	}
	if ( val1 === null || val2 === null) {
		return false; //checking if either val is null
	}
	if((typeof(val1) != 'object')&&(typeof(val2) != 'object')) {
		//neither val is an object
		if(val1 === val2){
			return true; //return true if not an object and the same
		}
		else{
			return false
		}
	}
	else{
		// one of the values is an object
		if((typeof(val1) != 'object')||(typeof(val2) != 'object')) {
			return false; //returning false if one value is an object but the other isnt
		}
		if(Array.isArray(val1)){
			if(!(Array.isArray(val2))){
				return false
			}
		}
		else if(Array.isArray(val2)){
			if(!(Array.isArray(val1))){
				return false
			}
		}
		if((val1.length === 0 )||(val2.length === 0 )){
			return false;
		}
		//both vals are objects and not null
		if (Object.keys(val1).length !== Object.keys(val2).length) {
			return false;
		}
		return Object.keys(val1).every(prop => {
			const objOneValue = val1[prop];
			const objTwoValue = val2[prop];

		return deepEqual(objOneValue, objTwoValue);
		});
	}
}

// Don't add or change anything below this comment.
module.exports = deepEqual;