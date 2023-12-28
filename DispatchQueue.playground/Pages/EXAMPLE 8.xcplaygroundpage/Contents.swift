//: [Previous](@previous)

import Foundation
import PlaygroundSupport


var counter = 1

// Main Queue -> Serial queue
// async -> don't block current impelmenation
// it's first one to be sumbit
DispatchQueue.main.async {
    for i in 0...3 {
        counter = i
        print("\(counter)")
    }
}

// not block with any queue or asyn or sync
for i in 4...6 {
    counter = i
    print("\(counter)")
}

// it's will be the last one cuz we have FIFO
DispatchQueue.main.async {
        counter = 9
        print("\(counter)")
}
