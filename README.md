
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

* Label: use for uniquely identify the dispatch  queue it's useful for debugging and identify the purpose of the queue .
* Qos: Helps the system to piroeties tasks we have enum of types
* attribuites: the type of the queue it's by default serial. it can be counncrent or initallyInactive or both.
* autorelease frequency: auto relase resources will be used like inherent, workItwm and Never.
* target: the target queue on which the new queue should br made dependent. Task submitted to new queue will be excuted on the target queue. If nil global counncrent queu efor the specified Qos will be used.


### QOS:

1- UserInactice (Involoced in updating UI? yes use it): animation & event handling.
2- User-initalied (Data required for better ux? yes): Table view & next page.
3- Default (Qos falls between user-initalied & utility)
4- Utility (is user aware of the program> is it appear to user? like downloading and progress bar) .
5- Background (Is user aware of the task? No use it): things that is not visable to the user.
6- Unspaecified (when some information is missig): Abense of Qos info.


### (2) DisaptchGroup
* A group of tasks that you monitor as a single unit.

### func with disptach group
* .enter(): will call to enter disoatchGroup
* .leave(): will call after excution is finish/ recive the response.
* .wait(): If you want to stop the excution happend in the current thread(shouldn't be used in the main thread).
* .notify(): Notify If all tasks completed will be called.
[we need to balance the numbers of the .enter() with .leave() or we will end with crash]


### (3) DisaptchWorkItem

* Encapsulate a block of code.
* Can be dispatched on both DispatchQueue or DispatchGroup.
* Provide flexibility to cancel the task.

### wotkItem funcs
* .cancel: if cancel = ture before the excution task will not excute. If canceled during excution cancel will 'return true' but excution won't abort.
* .wait() & .notify(): works like dispatchGroup.

### Flags(DispatchWorlItemFlags)
* Set a behvior of work item.
* It's QOS whetherto create a barrier or spawn a new detached thread.
* types of flags: assignCurrentContext, detached, enforeceQos, inheritQos, .noQos and barrier.
[barrier is the most used we use it with data race ]

* Data races : Two or more threads in a single process access the same memory location concurrently, and at least one of the accesses is for writing.


### (4) DisaptchSempahre
* Deal with data consitncy.
* Data consitncy? Multiple account holder for same account in the same try to access the bank.
* All trhead want to acess critical section will be added to queue: one thread will be allowed at the time.
* Set a counter.

### DisaptchSempahre funcs
* .wait(): reduce value counter by -1.
* .single(): increase the value counter by +1.

### Cirtical section 
* Part of the program in which tries to access shared resources.
* when critical section is accessed by multiple thread at the same time (strong change of data incontincsincy) and soultion is DisaptchSempahre

### (5) Disaptch Source
* The one used for listent to the event by the system ,
* Rearly used thing.
* Can be used to run timer on the background thread.
