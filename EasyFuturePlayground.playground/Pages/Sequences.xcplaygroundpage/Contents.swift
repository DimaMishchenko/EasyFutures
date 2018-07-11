/*:
 To use this playground you should open it in EasyFuture.xcodeproj and build EasyFuture framework.
 */
//: [Previous page](@previous)
import EasyFuture
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Sequences
//: EasyFuture provide some functions to help you work with sequences of Futures.

//: # - Fold
//: You can convert list of values into a single value. Fold returns Future with this value. Fold takes default value and then you perform action with default value and every value from list.
let futures = [Future<Int>(value: 1), Future<Int>(value: 2), Future<Int>(value: 3)]

futures.fold(0) { defaultValue, currentValue -> Int in
    return defaultValue + currentValue
}.onSuccess { value in
    print(value) // 6
}
//: Can catch errors.
let error = NSError(domain: "", code: -1, userInfo: nil)

futures.fold(0) { defaultValue, currentValue -> Int in
    throw error
}.onError { error in
    print(error) // error
}
//: # - Traverse
//: Traverse can work with any sequence. Takes closure where you transform value into a Future. Returns Future which contains array of the values from the Futures returned by the closure.
[1, 2, 3].traverse { number -> Future<String> in
    return Future<Int>(value: "\(number * 100)")"
}.onSuccess { value in
     print(value) // ["100", "200", "300"]
}
//: # - Sequence
//: Transforms list of Futures into a single Future with array of values.
futures // [Future<Int>, Future<Int>, Future<Int>]
futures.sequence() // Future<[Int]>
futures.sequence().onSuccess { numbers in
    print(numbers) // [1, 2, 3]
}
