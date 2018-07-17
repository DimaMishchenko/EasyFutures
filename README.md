# EasyFutures
[![Swift 4.1](https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/EasyFutures.svg)](https://cocoapods.org/pods/EasyFutures)
[![Build Status](https://travis-ci.org/DimaMishchenko/EasyFutures.svg?branch=master)](https://travis-ci.org/DimaMishchenko/EasyFutures)
[![codecov.io](https://codecov.io/gh/DimaMishchenko/EasyFutures/branch/master/graphs/badge.svg)](https://codecov.io/gh/DimaMishchenko/EasyFutures)
[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)](LICENSE)

Swift implementation of Futures & Promises. You can read more about Futures & Promises in Wikipedia: https://en.wikipedia.org/wiki/Futures_and_promises.

**EasyFutures** is:
- 100% Swift, [100% test coverage](https://codecov.io/gh/DimaMishchenko/EasyFutures).
- easy to understand.
- type safe (uses Swift generics).
- the avoidance of a "callback hell".
- out of the box errors handling (you don't need to use `do/catch`).
- composeable ([`map`](#map), [`flatMap`](#flatmap), [`filter`](#filter), [`recover`](#recover), [`zip`](#zip), [`andThen`](#andthen), [`flatten`](#flatten)).
- support sequences ([`fold`](#fold), [`traverse`](#traverse), [`sequence`](#sequence)).
- [fully documented](#documentation).

## Documentation
- Full documentation and more examples you can find in [Playground](EasyFuturesPlayground.playground) (to use playground you should open it in `EasyFutures.xcodeproj` and build EasyFutures framework).
- [Wiki](https://github.com/DimaMishchenko/EasyFutures/wiki) (full documentation and all examples).
- [Unit tests](EasyFuturesTests).
- [Examples section](#examples).

## Installation

[CocoaPods](http://www.cocoapods.org):

``` ruby
pod 'EasyFutures'
```

``` swift
import EasyFutures
```

## Examples
Traditional way to write asynchronous code:
``` swift
func loadChatRoom(_ completion: (_ chat: Chat?, _ error: Error?) -> Void) {}
func loadUser(id: String, _ completion: (_ user: User?, _ error: Error?) -> Void) {}

loadChatRoom { chat, error in
    if let chat = chat {
        loadUser(id: chat.ownerId) { user, error in
            if let user = user {
                print(user)
                // owner loaded
            } else {
                // handle error
            }
        }
    } else {
        // handle error
    }
}
```
Same logic but with **EasyFutures**:
``` swift
func loadChatRoom() -> Future<Chat>
func loadUser(id: String) -> Future<User> 

loadChatRoom().flatMap({ chat -> Future<User> in
    // loading user
    return loadUser(id: chat.ownerId)
}).onSuccess { user in
    // user loaded
}.onError { error in
    // handle error
}
```
### Future
Future is an object that contains or will contain `result` which can be value or error. Usually result gets from some asynchronous process. To receive result you can define `onComplete`, `onSuccess`, `onError` callbacks.  
``` swift

func loadData() -> Future<String> 

let future = loadData()

future.onComplete { result in
    switch result {
    case .value(let value):
        // value
    case .error(let error):
        // error
    }
}

future.onSuccess { data in
    // value
}.onError { error in
    // error
}
```
### Promise
The Promises are used to write functions that returns the Futures. The Promise contains the Future instance and can complete it.
``` swift
func loadData() -> Future<String> {

    // create the promise with String type
    let promise = Promise<String>()

    // check is url valid
    guard let url = URL(string: "https://api.github.com/emojis") else {
        // handle error
        promise.error(ExampleError.invalidUrl)
        return promise.future
    }

    // loading data from url
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let data = data, let string = String(data: data, encoding: .utf8) {
            // return result
            promise.success(string)
        } else {
            // handle error
            promise.error(ExampleError.cantLoadData)
        }
    }
    task.resume()

    // return the future
    return promise.future
}

loadData().onSuccess { data in
    DispatchQueue.main.async {
        self.label.text = data
    }
}.onError { error in
    print(error)
    // handle error
}
```
## Composition
### map
Returns the new Future with the result you return to closure or with error if the first Future contains error.
``` swift

let future = Future<Int>(value: 100)
future.onSuccess { value in
    // value == 100
}

let mapFuture = future.map { value -> String in
    return "\(value) now it's string"
}
mapFuture.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // "100 now it's string""
    case .error(let error):
        // handle error
    }
}
```
### flatMap
Returns the new Future with the Future you return to closure or with error if the first Future contains error.
``` swift
let future = Future<Int>(value: 1)

let flatMapFuture = future.flatMap { value -> Future<String> in
    return Future<String>(value: "\(value * 100)%")
}
flatMapFuture.onSuccess { value in
    print(value) // "100%"
}
```
### filter
Returns the Future if value satisfies the filtering else returns error.
``` swift 
let future = Future<Int>(value: 500)

future.filter { value -> Bool in
    return value > 100
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // 100
    case .error(let error):
        print(error) // no error
    }
}

future.filter { value -> Bool in
    return value > 1000
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // no value
    case .error(let error):
        print(error) // FutureError.filterError
    }
}
```
### recover
If the Future contains or will contain error you can recover it with the new value.
``` swift 
let future = Future<Int>(error: someError)

future.recover { error -> Int in
    return 100
}.onComplete { result in
    switch result {
    case .value(let value):
        print(value) // 100
    case .error(let error):
        print(error) // no error
    }
}
```
### zip
Combines two values into a tuple.
``` swift 
let first = Future<Int>(value: 1)
let second = Future<Int>(value: 2)

first.zip(second).onSuccess { firstValue, secondValue in
    print(firstValue) // 1
    print(secondValue) // 2
}
```
### andThen
Returns the new Future with the same value.
``` swift 
let future = Future<String>(value: "and")

future.andThen { value in
    print(value) // "and"
}.andThen { value in
    print(value.count) // 3
}
```
### flatten
If the value of the Future is the another Future you can flatten it.
``` swift 
let future = Future<Future<String>>(value: Future<String>(value: "value"))

future.onSuccess { value in
    print(value) // Future<String>(value: "value")
}

future.flatten().onSuccess { value in
    print(value) // "value"
}
```
## Errors handling
[`map`](#map), [`flatMap`](#flatmap), [`filter`](#filter) and [`recover`](#recover) can catch errors and return the Future with this error, so you don't need to handle it with `do/catch`.
``` swift
let future = Future<String>(value: "")
let errorToThrow = NSError(domain: "", code: -1, userInfo: nil)

future.map { value -> String in
    throw errorToThrow
}.flatMap { value -> Future<String> in
    throw errorToThrow
}.filter { value -> Bool in
    throw errorToThrow
}.recover { error -> String in
    throw errorToThrow
}
```
## Sequences
**EasyFutures** provides some functions to help you work with the sequences of Futures.
### fold
You can convert a list of the values into a single value. Fold returns the Future with this value. Fold takes default value and then you perform action with default value and every value from the list. Can catch errors.
``` swift
let futures = [Future<Int>(value: 1), Future<Int>(value: 2), Future<Int>(value: 3)]

futures.fold(0) { defaultValue, currentValue -> Int in
    return defaultValue + currentValue
}.onSuccess { value in
    print(value) // 6
}
```
### traverse
Traverse can work with any sequence. Takes closure where you transform the value into the Future. Returns the Future which contains array of the values from the Futures returned by the closure.
``` swift 
[1, 2, 3].traverse { number -> Future<String> in
    return Future<String>(value: "\(number * 100)")
}.onSuccess { value in
    print(value) // ["100", "200", "300"]
}
```
### sequence
Transforms a list of the Futures into the single Future with an array of values.
``` swift 
let futures = [Future<Int>(value: 1), Future<Int>(value: 2), Future<Int>(value: 3)] // [Future<Int>, Future<Int>, Future<Int>]
let sequence = futures.sequence() // Future<[Int]>
sequence.onSuccess { numbers in
    print(numbers) // [1, 2, 3]
}
```
## License
**EasyFutures** is under MIT license. See the [LICENSE](LICENSE) file for more info.
