//: [Previous](@previous)


import Foundation
import PlaygroundSupport

DispatchQueue.main.async {
    print(Thread.isMainThread ? "Executing on main thread " : "Executing on some other thread")
}
// no matter will happend global queue will never excute on main thread
DispatchQueue.global(qos: .userInteractive).async {
    print(Thread.isMainThread ? "Executing on main thread " : "Executing on global counncrent thread")
}
