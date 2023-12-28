//: [Previous](@previous)
import Foundation

var value: Int = 20
let serialQeue = DispatchQueue(label: "com.queue.Serial") // any custome queue or global queue is not running in the main thread


 // we need to name the queue with universal standarded
func doAsyncTaskInSerialQueue() {
    for i in 1...3 {
        //async it will not block the implemnation and it will goes to the next line of the implemnation
        // when we use sync block to any dispatch qeueu
        // any sync it's block the main Thread
        // system found the main thread is idle that's way they run the sync in the main thread
        
        serialQeue.sync {
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

doAsyncTaskInSerialQueue()

// excute on a diffrent thread
serialQeue.async {
    for i in 0...3 {
        value = i
        print("\(value) ")
    }
}

print("last line in the packground #####")
