/*:
 To use this playground you should open it in EasyFuture.xcodeproj and build EasyFuture framework.
 */
//: [Previous page](@previous)
import EasyFuture
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Composition
//: EasyFuture Futures are composable.
//: Supported combining functions:

//: # - map:
//: Returns new Future with result you return to closure or with error if first Future contains error.
// with value
let mapFuture = Future<Int>(value: 100)
mapFuture.onSuccess { value in
    // value == 100
}

mapFuture.map { value -> String in
    return "\(value) now it's string"
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // "100 now it's string""
    case .error(let error):
        print(error) // no error
    }
}

// with error
let error = NSError(domain: "", code: -1, userInfo: nil)
let mapErrorFuture = Future<Int>(error: error)

mapErrorFuture.map { value -> String in
    return "\(value)"
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // no value
    case .error(let error):
        print(error) // error
    }
}
//: # - flatMap
//: Returns new Future with Future you return to closure or with error if first Future contains error.
let flatMapFuture = Future<Int>(value: 1)
flatMapFuture.flatMap { value -> Future<String> in
    return Future<String>(value: "\(value * 100)%")
}.onSuccess { value in
    print(value) // "100%"
}
//: Error handling is same as map.

//: # - filter
//: Returns Future if value satisfies the filtering, else returns error.
let filterFuture = Future<Int>(value: 500)

// value
filterFuture.filter { value -> Bool in
    return value > 100
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // 100
    case .error(let error):
        print(error) // no error
    }
}

// error
filterFuture.filter { value -> Bool in
    return value > 1000
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // no value
    case .error(let error):
        print(error) // FutureError.filterError
    }
}

// with custom error
let myCustomError = NSError(domain: "", code: -1, userInfo: nil)
filterFuture.filter(error: myCustomError) { value -> Bool in
    return value > 1000
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // no value
    case .error(let error):
        print(error) // myCustomError
    }
}
//: # - recover
//: If Future contain or will contain error you can recover it with new value.
let recoverFuture = Future<Int>(error: error)

recoverFuture.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // no value
    case .error(let error):
        print(error) // error
    }
}

recoverFuture.recover { error -> Int in
    return 100
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // 100
    case .error(let error):
        print(error) // no error
    }
}
//: # - zip
//: Combines two values into a tuple.
let first = Future<Int>(value: 1)
let second = Future<Int>(value: 2)
first.zip(second).onSuccess { firstValue, secondValue in
    print(firstValue) // 1
    print(secondValue) // 2
}
//: # - andThen
//: Returns new Future with same value.
let someFuture = Future<String>(value: "and")

someFuture.onSuccess { value in
    print(value)
}.andThen { value in
    print(value) // "and"
}.andThen { value in
    print(value.count) // 3
}
//: # - flatten
//: If value of Future is another Future you can flatten it.
let future = Future<Future<String>>(value: Future<String>(value: "value"))

future.onSuccess { value in
    print(value) // Future<String>(value: "value")
}

future.flatten().onSuccess { value in
    print(value) // "value"
}

//: # Error handling
//: "map", "flatMap", "filter" and "recover" can catch errors and ruturn Future with this error, so you don't need to handle it with do/catch.
let errorsHandling = Future<String>(value: "")
let errorToThrow = NSError(domain: "", code: -1, userInfo: nil)

errorsHandling.map { value -> String in
    throw errorToThrow
}.flatMap { value -> Future<String> in
    throw errorToThrow
}.filter { value -> Bool in
    throw errorToThrow
}.recover { error -> String in
    throw errorToThrow
}
//: [Next page](@next)
