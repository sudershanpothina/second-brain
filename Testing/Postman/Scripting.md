```
let firstName = "John";

let lastName = "Doe";

// let name = firstName + " " + lastName; or

let name = `${firstName} ${lastName}`;

const age = 30;

console.log(firstName);

console.log(age);

console.log(name, age);

if(age == 30) {

    console.log("age is 30")

}

if(firstName === "John") {

    console.log("name is John")

} else {

    console.log("name is not John")

}

  

logMessageToConsole();

function logMessageToConsole() {

    console.log("Hello")

}

function logMessageToConsoleCustom(name) {

    console.log(name)

}

logMessageToConsoleCustom("Test")

  

function sayHello(name) {

    console.log(`Hello ${name}`)

    return name

}

  

sayHello("test123")

  
  

let person = {

    firstName: 'Tom',

    lastName: "Doe",

    age: 30,

    sayHi: function() {

        console.log(`Hello ${this.firstName}`)

    }

}

console.log(person)

console.log(person.firstName) // or

console.log(person['lastName'])

person.email = "tom@gmail.com"

console.log(person)

person.sayHi()

  

// convert to json

let personJson = JSON.stringify(person)

// console.log(JSON.stringify(person))

console.log(personJson)

  

// parse Json

let person1 = JSON.parse(personJson)

console.log(person1.age)

  

// arrays

let profiles = ['site1', 'site2']

let user = {}

user.name = "Joe"

user.profiles = profiles

console.log(user)

console.log(user.profiles.length)

console.log(user.profiles[1])

profiles.push("site3")

console.log(user.profiles)

profiles.pop()

console.log(user.profiles)

  

//loops

for(let i=0; i<user.profiles.length; i++) {

    console.log(user.profiles[i])

}

  

user.profiles.forEach(logItems)

  

function logItems(item, index, array) {

    console.log(item)

}

  

user.profiles.forEach(function(item, index, array){

    console.log(item)

})

  

user.profiles.forEach((item, index, array) => {

    console.log(item)

})

  

user.profiles.forEach(console.log)

  
  

// send request

pm.sendRequest("https://postman-echo.com/get", function (err, response) {

    console.log(response.json());

});

// read data from csv or json file

let region = pm.iterationData.get("Region")

let value = pm.iterationData.get("value")

  

console.log(region, value)```