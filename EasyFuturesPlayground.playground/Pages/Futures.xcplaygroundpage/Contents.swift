/*:
 To use this playground you should open it in EasyFutures.xcodeproj and build EasyFutures framework.
 */
//: [Previous page](@previous)
import EasyFutures
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Futures
//: You can read Futures & Promises theory on Wikipedia [https://en.wikipedia.org/wiki/Futures_and_promises](https://en.wikipedia.org/wiki/Futures_and_promises)

//: # Let's start
let stringFuture = Future<String>(value: "string")
//: This is a Future. We can imagine this as a box which can contain a value of some type (in this case it's String).
stringFuture.value // "string"
//: But it also could be empty:
let newStringFuture = Future<String>()
newStringFuture.value // nil
//: If something goes wrong Future can contain error and empty value:
let error = NSError(domain: "", code: -1, userInfo: nil)

let errorFuture = Future<String>(error: error)

errorFuture.error // error
errorFuture.value // nil
//: Actually Future contain "result" which can be empty, value or error. Future can be completed or not. If completed result will be value or error. If not completed result will be empty.
//: We can detect Future state using isCompleted, isSuccess, isError properties:
stringFuture.isCompleted // if completed - true, else - false
stringFuture.isSuccess // if completed with value - true, else - false
stringFuture.isError // if completed with error - true, else - false
//: There are 4 ways to create (init) Future. With operation, with result, with value or with error:
let futureWithOperation = Future<String> { completion in
    // we can do async operation and then complete it with value or error
    completion(.value("value"))
 // completion(.error(error))
    
    // you can also throw error (Future will complete with error)
}

let futureWithResult = Future<String>(result: .value("value")) // result can be .value(value) or .error(error)

let futureWithValue = Future<String>(value: "value")

let futureWithError = Future<String>(error: error)
//: But how we are get a result?
//: We can easily define "onComplete" callback.
let futureWithAsyncCompletion = Future<Int> { completion in
    
    DispatchQueue.global().async {
        completion(.value(100))
    }
}

futureWithAsyncCompletion.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // 100
        // our value
    case .error(let error):
        print(error)
        //handle error
    }
}
//: We can also define "onSuccess" and "onError" callbacks:
futureWithAsyncCompletion.onSuccess { value in
    // our value
    print(value) // 100
}

futureWithAsyncCompletion.onError { error in
    // handle error
    print(error)
}
//: We can even combine them (all of them (onComplete, onSuccess, onError)):
futureWithAsyncCompletion.onSuccess { value in
    // valye
}.onError { error in
    // error
}
//: EasyFutures support multiple callbacks, so we can do something like this:
futureWithAsyncCompletion.onSuccess { value in
    // make this
}
futureWithAsyncCompletion.onSuccess { value in
    // and make that
}
//: # More examples
//: # #1
func loadData() -> Future<String> {
    
    return Future<String> { completion in
        
        DispatchQueue.global().async {
            
            // loading data...
            
            let data = "a lot of data"
            completion(.value(data))
        }
    }
}

loadData().onSuccess { data in
    DispatchQueue.main.async {
        // data loaded
        // do smth..
    }
}.onError { error in
    // handle error
}

//: # #2
func loadDataThatCanThows() -> Future<String> {
    
    return Future<String> { completion in
        
        return try String(contentsOfFile: "invalid file")
        
    }
}

loadDataThatCanThows().onComplete { result in
    
    switch result {
    case .value(let value):
        print(value)
    case .error(let error):
        print(error)
        // will be error because of throws
    }
}

//: [Next page](@next)
