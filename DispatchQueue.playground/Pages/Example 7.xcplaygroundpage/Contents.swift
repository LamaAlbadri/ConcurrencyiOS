//: [Previous](@previous)

import Foundation

var value: Int = 20
let concurrentQueue = DispatchQueue(label: "com.queue.Serial", attributes: .concurrent)
 // label -> we need to name the queue with universal standarded



func doAsyncTaskInConcurrentQueue() {
    for i in 1...3 {
        concurrentQueue.async {
            if Thread.isMainThread {
                print("task running in main thread")
            } else {
                print("task running in other thread")
            }
            
            
            // downloading will take some time
            let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
            let _ = try! Data(contentsOf: imageURL)
            print("\(i) finished downloading")
        }
    }
}
print("------------------")
doAsyncTaskInConcurrentQueue()
// excute on a diffrent thread
concurrentQueue.async {
    for i in 0...3 {
        value = i
        print("\(value) ")
    }
}

print("last line in the packground #####")
