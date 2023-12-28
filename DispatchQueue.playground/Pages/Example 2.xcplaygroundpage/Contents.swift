import Foundation
import PlaygroundSupport

DispatchQueue.global(qos: .background).async {
    print(" --- background queue ----")
    for i in 11...21 {
        print(i)
    }
}

// more resources will be look to the userInteractive
DispatchQueue.global(qos: .userInteractive).async {
    print(" --- userInteractive queue ----")
    for i in 0...10 {
        print(i)
    }
}
