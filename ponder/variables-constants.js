const PI = 3.14;
let radius = 3;

let area = radius * radius * PI;

console.log(area);

radius = 20;
area = radius * radius * PI;

console.log(area);

// type coersion the two is a string, but js is going to let it be a number based on the context. 
const one = 1;
const two = '2';

let result = one * two;
console.log(result);

// here using a string with a plus with then be a concatonation, the answer is 12. To fix that you could change the code to turn "two" into a number.
result = one + Number(two);
console.log(result);

//scope

let course = "CSE131"; //global scope
if (true) {
    let student = "John";
    console.log(course);  //works just fine, course is global
    console.log(student); //works just fine, it's being accessed within the block
}
console.log(course); //works fine, course is global
console.log(student); //does not work, can't access a block variable outside the block
                    
                    