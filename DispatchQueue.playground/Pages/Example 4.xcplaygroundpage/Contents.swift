//: [Previous](@previous)

import Foundation
import PlaygroundSupport

// serial queue
let a: DispatchQueue = DispatchQueue(label: "A")
//concurrent queue
let b: DispatchQueue = DispatchQueue(label: "B", attributes: [.concurrent, .initiallyInactive], target: a)

// use init inactive attribuite because we use .initiallyInactive attrbuites
b.setTarget(queue: a) // 1
print("setTarget")

b.async { // 3
    print("Tetsing ativeation/dec")
}
print("activate()")
b.activate() // 2

