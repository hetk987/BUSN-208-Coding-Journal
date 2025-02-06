// here is my first comment

//const
let num1:Int = 100

//variable
var num2:Int = 200

print(num1)
print(num2)

var lang:String = "none"
var reading:String
// if-else statement
if (lang == "English"){
    reading = "hello"
}
else if(lang == "french"){
    reading="french hello"
}
else{
    reading = "german hello"
}
print(reading)

print(Int(5.4)) //typ casting is similar to c++


var reading2:String?
// if-else statement
if (lang == "English"){
    reading2 = "hello"
}
else if(lang == "french"){
    reading2="french hello"
}

print(reading2 ?? "unknown")

//Converted the above conde into a function so that it could be used as many times as needed.
func Greeting(lang:String) -> String{
    var greeting:String?
    if (lang == "English"){
        greeting = "Hello"
    }
    else if(lang == "French"){
        greeting = "Bonjour"
    }
    
    return greeting ?? "unknown"
}

print(Greeting(lang: "French"))


class year_make_model{
    var year:Int?
    var make: String?
    var model:String?
}

class car_stats: year_make_model{
    var miles:Int?
    var age:Int?
    var type:String?
    var accidents:Bool?
    var price:Int?
}
