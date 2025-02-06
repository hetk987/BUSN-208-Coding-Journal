struct Debt{
    var person:Person;
    var amount:Double;
}

struct Person{
    var name:String;
    var peopleIOwe:[Debt];
    var peopleOweMe:[Debt];
}

func AccountSummary(user:Person)->Void{
    var output=[String:Double]();
    for personIOwe in user.peopleIOwe {
        for peopleOweMe in user.peopleOweMe {
            if(personIOwe.person.name == peopleOweMe.person.name){
                output[personIOwe.person.name] = personIOwe.amount - peopleOweMe.amount
            }
        }
    }
    
    print("Account Summary:")
    for (e, value) in output  {
        print(e , " : " , value)
    }
}
