//
//  ViewController.swift
//  OperationQueue
//
//  Created by Lama Albadri on 25/12/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadExample5()
//        print("Custome operation excuted")
    }
    
    func viewDidLoadExample5() {
        let operationQueue: OperationQueue = OperationQueue()
        let operation1: PrintNumberOperation = PrintNumberOperation(range: Range(0 ... 25))
        let operation2: PrintNumberOperation = PrintNumberOperation(range: Range(26 ... 50))
        
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
        
    }
    
    func viewDidLoadExample4() {
        let operationQueue: OperationQueue = OperationQueue()
        
        let operation1: BlockOperation = BlockOperation(block: printOneToTen)
        
        let operation2: BlockOperation = BlockOperation(block: printElevenToTwenty)
        
        // addDependency will not work because we add async() work that's will not be consider
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
        
    }
    
    func printOneToTen() {
        DispatchQueue.global().async {
            for i in 0 ... 10 {
                print(i)
            }
        }
    }
    
    func printElevenToTwenty() {
        DispatchQueue.global().async {
            for i in 11 ... 20 {
                print(i)
            }
        }
    }
    
    
    func viewDidLoadExample3() {
        // create OperationQueue
        // is excuted in diffrent thread not a main thread
        // the async is being handle to operation queue
        // queue is excute the operation on multiple threads
        let operationQueue: OperationQueue = OperationQueue()
        
//        operationQueue.maxConcurrentOperationCount = 1 // this will give you a seriall behvior here
        
        // a block operation
        let operation1: BlockOperation = BlockOperation()
        let operation2: BlockOperation = BlockOperation()
        
        operation1.addExecutionBlock {
            for i in 0 ... 10 {
                print(i)
            }
//            print("Operation 1 is being executed")
        }
        
        operation1.completionBlock = {
            print("Operation 1 executed")
        }
        
        operation2.addExecutionBlock {
            for i in 11 ... 20 {
                print(i)
            }
//            print("Operation 2 is being executed")
        }
        
        operation2.completionBlock = {
            print("Operation 2 executed")
        }
        
        // Operation 2 should wait till operation 1 is done executing
        operation2.addDependency(operation1)
        operationQueue.addOperation(operation1)
        operationQueue.addOperation(operation2)
    }
    
    
    func viewDidLoadExample2() {
        let operation: CustomeOperation = CustomeOperation()
        operation.start()
        print("Custome operation excuted")
    }
    
    
    func viewDidLoadExample1() {
                print("About to begin operation")
                testOperations()
                print("Operatione excute ")
    }

//    func testOperations() {
//        // create operation using BlockOperation Sub-Class
//        let operation: BlockOperation = BlockOperation {
//            // this work is in sync manner excute
//            sleep(3)
//            print("First test")
//        }
//        operation.start()
//    }

//    func testOperations() {
//        // create operation using BlockOperation Sub-Class
//        // excute on counncrent manner
//        let operation: BlockOperation = BlockOperation()
//           
//            operation.addExecutionBlock {
//                print("First block excuted")
//            }
//            
//            operation.addExecutionBlock {
//                print("Second block excuted")
//            }
//            
//        operation.addExecutionBlock {
//            print("Third block excuted")
//        }
//        
//            operation.start()
//
//    }
    
    
    func testOperations() {
        // create operation using BlockOperation Sub-Class
        // excute on counncrent manner
        let operation: BlockOperation = BlockOperation()
           
        operation.completionBlock = {
            // when-ever the completion is completed
            print("Execution completed")
        }
        
            operation.addExecutionBlock {
                print("First block excuted")
            }
            
            operation.addExecutionBlock {
                print("Second block excuted")
            }
            
        operation.addExecutionBlock {
            print("Third block excuted")
        }
        
        DispatchQueue.global().async {
            // excutation sync
            operation.start()
            print("Did this run main thread = \(Thread.isMainThread)")
        }
    
    }
}



class CustomeOperation: Operation {
    
    override func start() {
        // thread can be init with a block
        // we pass a main block to start
        
        // don't deal with Thread class directally
        Thread.init(block: main).start()
    }
    override func main() {
        for i in 0 ... 10 {
            print(i)
        }
    }
}


class AsyncOperation: Operation {
    
    enum State: String { // is get only properties
        case isReady
        case isExecuting
        case isFinished
    }
    
    var state: State = .isReady {
        // willChangeValue and didChangeValue are methods from NSObject
        willSet(newValue) {
            willChangeValue(forKey: state.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isAsynchronous: Bool {true}
    override var isExecuting: Bool { state == .isExecuting}
    override var isFinished: Bool {
        if isCancelled && state != .isExecuting { return true}
        return state == .isFinished
    }
    
    override func start() {
        guard !isCancelled else {
            state = .isFinished
            return
        }
        state = .isExecuting
        main()
    }
    
    override func cancel() {
        state = .isFinished
    }
    
    
}

// PrintNumberOperation is sub-class from AsyncOperation
class PrintNumberOperation: AsyncOperation {
    
    
    var range: Range<Int>
    
    init(range: Range<Int>) {
        self.range = range
    }
    
    override func main() {
        DispatchQueue.global().async { [weak self] in
            guard let self: PrintNumberOperation = self  else {return }
            for i in self.range {
                print(i)
            }
            self.state = .isFinished
            
        }
    }
}
