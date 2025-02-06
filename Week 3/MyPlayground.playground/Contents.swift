import Foundation

//property wrapper to calidate price
@propertyWrapper
struct ValidatePrice{
    private var value:Double
    
    var wrappedValue:Double{
        get {value}
        
        set{value = max(newValue, 0)}
    }
    
    init(wrappedValue:Double){
        self.value = max(wrappedValue, 0)
    }
}



//structure to represent a car
//make model year

struct Car{
    var make:String
    var model:String
    var year:Int
    
    @ValidatePrice var price:Double
    
    func carDescription()->String{
        return "\(year) \(make) \(model) : \(price)"
    }
}

//class for person

class Person{
    var name:String
    var contactNumber:String
    
    init(name:String, contactNumber:String){
            self.name = name
            self.contactNumber = contactNumber
    }
    
    func contactInfo()->String{
        return "Name: \(name), Contact number: \(contactNumber)"
    }
}

//subclass for saleperson and customer

//Customer class

class Customer:Person{
    var purchasedCars:[Car] = []
    
    func addCar(car:Car){
        purchasedCars.append(car)
    }
    
    func listPurchasedCars()->String{
        return purchasedCars.map { $0.carDescription() }.joined(separator: "\n")    }
}

//Salesperson
class SalesPerson:Person{
    var employeeID:String
    
    init(name:String, contactNumber:String, employeeID: String) {
        self.employeeID = employeeID
        super.init(name: name, contactNumber: contactNumber)
    }
    
    override func contactInfo() -> String {
        return "Name: \(name), EID: \(employeeID), Contact number: \(contactNumber)"
    }
}

let car1 = Car(make: "Honda", model: "Accord", year: 2005, price: -20000)

let car2 = Car(make: "Toyota", model: "Camry", year: 2001, price: 10000)

let customer = Customer(name: "John Doe", contactNumber: "123-123-1233")

let salesperson = SalesPerson(name: <#T##String#>, contactNumber: <#T##String#>, employeeID: <#T##String#>)

print(car1.carDescription())

print(car2.carDescription())


