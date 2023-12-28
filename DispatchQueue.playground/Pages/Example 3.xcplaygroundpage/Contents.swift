//: [Previous](@previous)
import Foundation
import PlaygroundSupport

// label -> name of the queue can be use in the debug purposes
// attributes -> .concurrent , .initaillyInactive or both of them
//concurrent -> for create a concurrent queue
// initaillyInactive -> want the excuteing should start after some time later we need to active that queue on is isActive
//[concurrent,initaillyInactive] -> create a concurrent queue that's initally inactive

// target Queue -> a queue in which actual executing happend [when you init a queue you think it's excuting in it's queue but behind the scene it's excute on another queue]

// If you don't set the target qeuee from the init you can't change it later
// serial queue
let a: DispatchQueue = DispatchQueue(label: "A")
//concurrent queue
let b: DispatchQueue = DispatchQueue(label: "B", attributes: .concurrent, target: a)

print("**********************")
// taregt queue A is serial queue so everything it will excute on a serial qeueu
a.async {
    for i in 0 ... 5 {
        print(i)
    }
}

a.async {
    for i in 6 ... 10  {
        print(i)
    }
}

b.async {
    for i in 11 ... 15  {
        print(i)
    }
}

b.async {
    for i in 16 ... 20  {
        print(i)
    }
}
