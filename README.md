
## Counncrency in iOS

### (1) General Dispatch Queue (GCD)
- a class
- works as a FIFO
- Can use main() queue or global queues
- can use asyn() or sync() methods


#### Serial queue vs counnrent queue
* Serial: One task at a time/block the current excution.
* Counncurent: Multiple task at a time.
[even couuncrent tasks will excute as FIFO in swift queue]

#### Async() vs Sync()
* aync(): Contiues the excution of the current tasks while a new task will excute Async.
* sync() : Block the excution till the task is completed will block the current queue so we should aviod use it with main queue.

#### main vs global
* main : It's excute in a main thread only .
* gloabl: it's never excute on the main thread it's run on the global/backgroun thread with Qos(Qulitity of services piroerty).
[ main and global are both properties in DispatchQueue class ]



### Example

```swift

// create a queue with name com.queue1 by default it's serial queue 
let queue1 = DispatchQueue(label: "com.queue1")

let queue2 = DispatchQueue(label: "com.queue2", attribuites: .counccrent)

// it's counncrent queue but init in active we need to call .activate()
let queue3 = DispatchQueue(label: "com.queue3", attribuites: .[.counccrent], .initallyInactive])
queue3,activate()

// add target for the queue to excute in
queue2.setTarget(queue1)

// set a target for the queue from init 
let queue4 = DispatchQueue(label: "com.queue2", target: queue1)


```

* Label: used for uniquely identify the dispatch  queue it's useful for debugging and identifying the purpose of the queue .
* Qos: Helps the system to pirortize tasks we have enum of types
* attribuites: the type of the queue it's by default serial. it can be counncrent or initiallyinactive or both.
* autorelease frequency: auto-release resources will be used like inherent, workItwm and Never.
* target: the target queue on which the new queue should br made dependent. Task submitted to a new queue will be executed on the target queue. If nil global counncrent queue for the specified Qos will be used.


### QOS:

1- UserInactice (Involved in updating UI? Yes use it): animation & event handling.
2- User-initialised (Data required for better UX? yes): Table view & next page.
3- Default (Qos falls between user-initialised & utility)
4- Utility (is user aware of the program> Does it appear to the user? like downloading and progress bar).
5- Background (Is the user aware of the task? No use it): things that are not visible to the user.
6- Unspecified (when some information is missing): Abense of Qos info.


### (2) DisaptchGroup
* A group of tasks that you monitor as a single unit.

### func with dispatch group
* .enter(): will call to enter disoatchGroup
* .leave(): will call after execution is finished/receive the response.
* .wait(): If you want to stop the execution that happened in the current thread(shouldn't be used in the main thread).
* .notify(): Notify If all tasks completed will be called.
[we need to balance the numbers of the .enter() with .leave() or we will end with crash]


### (3) DisaptchWorkItem

* Encapsulate a block of code.
* Can be dispatched on both DispatchQueue or DispatchGroup.
* Provide flexibility to cancel the task.

### wotkItem funcs
* .cancel: if cancel = ture before the execution task will not execute. If canceled during execution cancel will 'return true' but execution won't abort.
* .wait() & .notify(): works like dispatchGroup.

### Flags(DispatchWorlItemFlags)
* Set a behavior of the work item.
* It's QOS whether to create a barrier or spawn a new detached thread.
* types of flags: assignCurrentContext, detached, enforeceQos, inheritQos, .noQos, and barrier.
[barrier is the most used we use it with data race ]

* Data races: Two or more threads in a single process access the same memory location concurrently, and at least one of the accesses is for writing.


### (4) DisaptchSempahre
* Deal with data consistency.
* Data consistency? Multiple account holders for the same account in the same try to access the bank.
* All threads want to access the critical section will be added to the queue: one thread will be allowed at the time.
* Set a counter.

### DisaptchSempahre funcs
* .wait(): reduce value counter by -1.
* .single(): increase the value counter by +1.

### Critical section 
* Part of the program which tries to access shared resources.
* when a critical section is accessed by multiple threads at the same time (strong change of data incontinency) and solution is DisaptchSempahre

### (5) Disaptch Source
* The one used for listening to the event by the system,
* Rarely used thing.
* Can be used to run a timer on the background thread.
* 


## Operation & Operation Queue

 ### GCD VS OperationQueue
 * operation internally used GCD it's init from GCD.
 * GCD: used when the task is not complex we are not interested in the state of execution.
   
 ### Operations
 * Operation: It should be used when we are more interested in the state of execution.
 * When we want more functionality to control the task.
 * Enspaulate a block of functionality that can be re-use.

 ### Operations Types/ Abstraction classes
 * Block operation: execute a block [it's currently run in global queue].
 * NSInvaction Operation: excute invocation [in objective-c only].
 * Custom Operation
   
 ### Operations states
 * isReady: when the operation is ready to execute.
 * isExcuting: When the operation starts executing.
 * isCancelled: When execution is canceled.
 * isFinished: when execution is finish.


