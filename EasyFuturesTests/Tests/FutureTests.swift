//
//  FutureTests.swift
//  FutureTests
//
//  Created by Dima Mishchenko on 30.06.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import XCTest
@testable import EasyFutures

class FutureTests: XCTestCase {
    
    // MARK: - Init
    
    func testInit_WithOperation_WithValue() {
        
        //
        let future = Future<Bool> { (completion) in
            completion(.value(true))
        }
        var isSuccess = false
        
        ///
        future.onSuccess { (value) in
            isSuccess = true
        }
        
        future.onError { (error) in
            XCTFail()
        }
        
        //
        XCTAssert(isSuccess)
    }
    
    func testInit_WithOperation_WithThrowsError() {
        
        //
        let future = Future<Bool> { (completion) in
            throw DataGenerator.error
        }
        var isError = false
        
        ///
        future.onSuccess { (value) in
            XCTFail()
        }
        
        future.onError { (error) in
            isError = true
        }
        
        //
        XCTAssert(isError)
    }
    
    func testInit_WithOperation_WithError() {
        
        //
        let future = Future<Bool> { (completion) in
            completion(.error(DataGenerator.error))
        }
        var isError = false
        
        ///
        future.onSuccess { (value) in
            XCTFail()
        }
        
        future.onError { (error) in
            isError = true
        }
        
        //
        XCTAssert(isError)
    }
    
    func testInit_WithResult_WithValue() {
        
        //
        let future = Future<Bool>(result: .value(true))
        var isSuccess = false
        
        ///
        future.onSuccess { (value) in
            isSuccess = true
        }
        
        future.onError { (error) in
            XCTFail()
        }
        
        //
        XCTAssert(isSuccess)
    }
    
    func testInit_WithResult_WithError() {
        
        //
        let future = Future<Bool>(result: .error(DataGenerator.error))
        var isError = false
        
        ///
        future.onSuccess { (value) in
            XCTFail()
        }
        
        future.onError { (error) in
            isError = true
        }
        
        //
        XCTAssert(isError)
    }
    
    func testInit_WithValue() {
        
        //
        let future = Future<Bool>(value: true)
        var isSuccess = false
        
        ///
        future.onSuccess { (value) in
            isSuccess = true
        }
        
        future.onError { (error) in
            XCTFail()
        }
        
        //
        XCTAssert(isSuccess)
    }
    
    func testInit_WithError() {
        
        //
        let future = Future<Bool>(error: DataGenerator.error)
        var isError = false
        
        ///
        future.onSuccess { (value) in
            XCTFail()
        }
        
        future.onError { (error) in
            isError = true
        }
        
        //
        XCTAssert(isError)
    }
    
    // MARK: - On complete
    
    func testOnComlete_WhenCompletedBeforeCallback_WithSuccess() {
        
        //
        let future = Future<Bool>()
        var onCompleteCalled = false
        
        //
        future.success(true)
        
        future.onComplete { result in
            switch result {
            case .value: onCompleteCalled = true
            case .error: XCTFail()
            }
        }
        
        XCTAssert(onCompleteCalled)
    }
    
    func testOnComlete_WhenCompletedBeforeCallback_WithError() {
        
        //
        let future = Future<Bool>()
        var onCompleteCalled = false
        
        //
        future.error(DataGenerator.error)
        
        future.onComplete { result in
            switch result {
            case .value: XCTFail()
            case .error: onCompleteCalled = true
            }
        }
        
        XCTAssert(onCompleteCalled)
    }
    
    func testOnComlete_WhenCompletedAfterCallback_WithSuccess() {
        
        //
        let future = Future<Bool>()
        var onCompleteCalled = false
        
        //
        future.onComplete { result in
            switch result {
            case .value: onCompleteCalled = true
            case .error: XCTFail()
            }
        }
        
        future.success(true)
        
        XCTAssert(onCompleteCalled)
    }
    
    func testOnComlete_WhenCompletedAfterCallback_WithError() {
        
        //
        let future = Future<Bool>()
        var onCompleteCalled = false
        
        //
        future.onComplete { result in
            switch result {
            case .value: XCTFail()
            case .error: onCompleteCalled = true
            }
        }
        
        future.error(DataGenerator.error)
        
        XCTAssert(onCompleteCalled)
    }
    
    func testOnComlete_WhenCompletedWithMultipleCallback_WithSuccess() {
        
        //
        let future = Future<Bool>()
        var firstCallbackOnCompleteCalled = false
        var secondCallbackOnCompleteCalled = false
        
        //
        future.onComplete { result in
            switch result {
            case .value: firstCallbackOnCompleteCalled = true
            case .error: XCTFail()
            }
        }
        
        future.onComplete { result in
            switch result {
            case .value: secondCallbackOnCompleteCalled = true
            case .error: XCTFail()
            }
        }
        
        future.success(true)
        
        XCTAssert(firstCallbackOnCompleteCalled && secondCallbackOnCompleteCalled)
    }
    
    func testOnComlete_WhenCompletedWithMultipleCallback_WithError() {
        
        //
        let future = Future<Bool>()
        var firstCallbackOnCompleteCalled = false
        var secondCallbackOnCompleteCalled = false
        
        //
        future.onComplete { result in
            switch result {
            case .value: XCTFail()
            case .error: firstCallbackOnCompleteCalled = true
            }
        }
        
        future.onComplete { result in
            switch result {
            case .value: XCTFail()
            case .error: secondCallbackOnCompleteCalled = true
            }
        }
        
        future.error(DataGenerator.error)
        
        XCTAssert(firstCallbackOnCompleteCalled && secondCallbackOnCompleteCalled)
    }
    
    // MARK: - On success
    
    func testOnSuccess_WhenCompletedBeforeCallback() {
        
        //
        let future = Future<Bool>()
        var onSuccessCalled = false
        
        //
        future.success(true)
        
        future.onSuccess { value in
            onSuccessCalled = true
        }
        
        //
        future.onError { (error) in
            XCTFail()
        }
        
        XCTAssert(onSuccessCalled)
    }
    
    func testOnSuccess_WhenCompletedAfterCallback() {
        
        //
        let future = Future<Bool>()
        var onSuccessCalled = false
        
        future.onSuccess { value in
            onSuccessCalled = true
        }
        
        //
        future.success(true)
        
        //
        future.onError { (error) in
            XCTFail()
        }
        
        XCTAssert(onSuccessCalled)
    }
    
    func testOnSuccess_WhenCompletedWithMultipleCallbacks() {
        
        //
        let future = Future<Bool>()
        var firstCallbackOnSuccessCalled = false
        var secondCallbackOnSuccessCalled = false
        
        //
        future.onSuccess { value in
            firstCallbackOnSuccessCalled = true
        }
        
        future.onSuccess { value in
            secondCallbackOnSuccessCalled = true
        }
        
        future.success(true)
        
        //
        future.onError { (error) in
            XCTFail()
        }
        
        XCTAssert(firstCallbackOnSuccessCalled && secondCallbackOnSuccessCalled)
    }
    
    // MARK: - On error
    
    func testOnError_WhenErrorBeforeCallback() {
        
        //
        let future = Future<Bool>()
        var onErrorCalled = false
        
        //
        future.error(DataGenerator.error)
        
        future.onError { (error) in
            onErrorCalled = true
        }
        
        //
        future.onSuccess { value in
            XCTFail()
        }
        
        XCTAssert(onErrorCalled)
    }
    
    func testOnError_WhenErrorAfterCallback() {
        
        //
        let future = Future<Bool>()
        var onErrorCalled = false
        
        future.onError { (error) in
            onErrorCalled = true
        }
        
        //
        future.error(DataGenerator.error)
        
        //
        future.onSuccess { value in
            XCTFail()
        }
        
        XCTAssert(onErrorCalled)
    }
    
    func testOnError_WhenMultipleError() {
        
        //
        let future = Future<Bool>()
        var firstErrorCalled = false
        var secondErrorCalled = false
        
        //
        future.onError { value in
            firstErrorCalled = true
        }
        
        future.onError { value in
            secondErrorCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        future.onSuccess { (error) in
            XCTFail()
        }
        
        XCTAssert(firstErrorCalled && secondErrorCalled)
    }
    
    // MARK: - Functional composition
    
    func testMap_WhenMapAfterSuccess() {
        
        //
        let testString = "testString"
        let future = Future<String>(value: testString)
        var onSuccessCalled = false
        
        //
        let mappedFuture = future.map({ $0.count })
        
        mappedFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(mappedFuture.value == testString.count)
    }
    
    func testMap_WhenMapBeforeSuccess() {
        
        //
        let testString = "testString"
        let future = Future<String>()
        var onSuccessCalled = false
        
        //
        let mappedFuture = future.map({ $0.count })
        mappedFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        future.success(testString)
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(mappedFuture.value == testString.count)
    }
    
    func testMap_WhenCompleteWithError() {
        
        //
        let future = Future<String>()
        var onErrorCalled = false
        
        //
        let mappedFuture = future.map({ $0 })
        
        mappedFuture.onError { (_) in
            onErrorCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        XCTAssert(onErrorCalled)
        XCTAssert(mappedFuture.isError)
    }
    
    func testMap_WhenThrowsError() {
        
        //
        let testString = "testString"
        let future = Future<String>(value: testString)
        var onErrorCalled = false
        
        //
        let mappedFuture = future.map({
            try throwsFunc($0.count, error: DataGenerator.error, throw: true)
        })
        
        mappedFuture.onError { (_) in
            onErrorCalled = true
        }
        
        //
        XCTAssert(onErrorCalled)
        XCTAssertTrue(mappedFuture.isError)
    }
    
    func testMap_WhenNotThrowsError() {
        
        //
        let testString = "testString"
        let future = Future<String>(value: testString)
        
        //
        let mappedFuture = future.map({
            try throwsFunc($0.count, error: DataGenerator.error, throw: false)
        })
        
        //
        XCTAssertFalse(mappedFuture.isError)
        XCTAssert(mappedFuture.value == testString.count)
    }

    func testFaltMap_WhenMapAfterSuccess() {
        
        //
        let testString = "testString"
        let future = Future<String>(value: testString)
        var onSuccessCalled = false
        
        //
        let mappedFuture = future.flatMap({ Future<Int>(value: $0.count) })
        
        mappedFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(mappedFuture.value == testString.count)
    }
    
    func testFlatMap_WhenMapBeforeSuccess() {

        //
        let testString = "testString"
        let future = Future<String>()
        var onSuccessCalled = false

        //
        let mappedFuture = future.flatMap({ Future<Int>(value: $0.count) })

        mappedFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        future.success(testString)

        //
        XCTAssert(onSuccessCalled)
        XCTAssert(mappedFuture.value == testString.count)
    }
    
    func testFlatMap_WhenCompleteWithError() {
        
        //
        let future = Future<String>()
        var onErrorCalled = false
        
        //
        let mappedFuture = future.flatMap({ Future<String>(value: $0) })
        
        mappedFuture.onError { (_) in
            onErrorCalled = true
        }
        future.error(DataGenerator.error)
        
        //
        XCTAssert(onErrorCalled)
        XCTAssert(mappedFuture.isError)
    }
    
    func testFlatMap_WhenThrowsError() {
        
        //
        let testString = "testString"
        let future = Future<String>(value: testString)
        var onErrorCalled = false
        
        //
        let mappedFuture = future.flatMap({
            Future<Int>(value: try throwsFunc($0.count, error: DataGenerator.error, throw: true))
        })
        
        mappedFuture.onError { (_) in
            onErrorCalled = true
        }
        
        //
        XCTAssert(onErrorCalled)
        XCTAssertTrue(mappedFuture.isError)
    }
    
    func testFlatMap_WhenNotThrowsError() {

        //
        let testString = "testString"
        let future = Future<String>(value: testString)

        //
        let mappedFuture = future.flatMap({
            Future<Int>(value: try throwsFunc($0.count, error: DataGenerator.error, throw: false))
        })

        //
        XCTAssertFalse(mappedFuture.isError)
        XCTAssert(mappedFuture.value == testString.count)
    }
    
    func testFlatten_WhenFlattenAfterSuccess() {
        
        //
        let future = Future<Future<Bool>>(value: Future<Bool>(value: true))
        var onSuccessCalled = false
        
        //
        let flatten = future.flatten()
        flatten.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(flatten.value == true)
    }
    
    func testFlatten_WhenFlattenBeforeSuccess() {

        //
        let future = Future<Future<Bool>>()
        var onSuccessCalled = false

        //
        let flatten = future.flatten()
        flatten.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        future.success(Future<Bool>(value: true))
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(flatten.value == true)
    }
    
    func testFlatten_WhenCompleteWithError() {
        
        //
        let future = Future<Future<Bool>>()
        var onErrorCalled = false
        
        //
        let flatten = future.flatten()
        flatten.onError { (_) in
            onErrorCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        XCTAssert(onErrorCalled)
        XCTAssert(flatten.isError)
    }
    
    func testFilter_WhenSuccessFiltering_WhenFilterAfterSuccess() {
        
        //
        let future = Future<Bool>(value: true)
        var onSuccessCalled = false
        
        //
        let filteredFuture = future.filter({ $0 })
        filteredFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(filteredFuture.isCompleted)
        XCTAssert(filteredFuture.value == true)
    }
    
    func testFilter_WhenSuccessFiltering_WhenFilterBeforeSuccess() {
        
        //
        let future = Future<Bool>()
        var onSuccessCalled = false
        
        //
        let filteredFuture = future.filter({ $0 })
        
        filteredFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        future.success(true)
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(filteredFuture.isCompleted)
        XCTAssert(filteredFuture.value == true)
    }
    
    func testFilter_WhenFailedFiltering() {
        
        //
        let future = Future<Bool>()
        var oErrorCalled = false
        
        //
        let filteredFuture = future.filter({ !$0 })
        filteredFuture.onError { (_) in
            oErrorCalled = true
        }
        
        future.success(true)
        
        //
        XCTAssert(oErrorCalled)
        XCTAssert(filteredFuture.isError)
    }
    
    func testFilter_WhenThrowsError() {
        
        //
        let future = Future<Bool>()
        var onErrorCalled = false
        
        //
        let filteredFuture = future.filter({
            try throwsFunc($0, error: DataGenerator.error, throw: true)
        })
        filteredFuture.onError { (_) in
            onErrorCalled = true
        }
        
        future.success(true)
        
        //
        XCTAssert(onErrorCalled)
        XCTAssertTrue(filteredFuture.isError)
    }
    
    func testFilter_WhenNotThrowsError() {

        //
        let future = Future<Bool>()
        
        //
        let filteredFuture = future.filter({
            try throwsFunc($0, error: DataGenerator.error, throw: false)
        })
        
        future.success(true)
        
        //
        XCTAssert(filteredFuture.value == true)
    }
    
    func testFilter_WithCustomError() {
        
        //
        let future = Future<Bool>()
        let error = DataGenerator.equatableError("filterError")
        var onErrorCalled = false
        
        //
        let filteredFuture = future.filter(error: error) { !$0 }
        filteredFuture.onError { (_) in
            onErrorCalled = true
        }
        
        future.success(true)
        
        //
        guard let futureError = filteredFuture.error as? EquatableError else {
            XCTFail()
            return
        }
        XCTAssert(onErrorCalled)
        XCTAssert(error == futureError)
    }
    
    func testFilter_WhenCompleteWithError() {
        
        //
        let future = Future<Bool>()
        var onErrorCalled = false
        
        //
        let filteredFuture = future.filter { $0 }
        filteredFuture.onError { (_) in
            onErrorCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        XCTAssert(onErrorCalled)
        XCTAssert(filteredFuture.isError)
    }
    
    func testRecover_WhenRecoverAfterComplete() {
        
        //
        let future = Future<Bool>(error: DataGenerator.error)
        var onSuccessCalled = false
        
        //
        let recoveredFuture = future.recover { _ -> Bool in return true }
        
        recoveredFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(recoveredFuture.value == true)
    }
    
    func testRecover_WhenRecoverBeforeComplete() {
        
        //
        let future = Future<Bool>()
        var onSuccessCalled = false
        
        //
        let recoveredFuture = future.recover { _ -> Bool in return true }
        
        recoveredFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(recoveredFuture.value == true)
    }
    
    func testRecover_WhenCompleteWithSuccess() {
        
        //
        let future = Future<Bool>()
        var onSuccessCalled = false
        
        //
        let recoveredFuture = future.recover { _ -> Bool in return false }
        recoveredFuture.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        future.success(true)
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(recoveredFuture.value == true)
    }
    
    func testRecover_WhenThrowsError() {
        
        //
        let future = Future<Bool>()
        let error = DataGenerator.equatableError("recoverError")
        var onErrorCalled = false
        
        //
        let recoveredFuture = future.recover { _ -> Bool in
            return try throwsFunc(true, error: error, throw: true)
        }
        recoveredFuture.onError { (_) in
            onErrorCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        guard let recoverError = recoveredFuture.error as? EquatableError else {
            XCTFail()
            return
        }
        XCTAssert(onErrorCalled)
        XCTAssert(error == recoverError)
    }

    func testZip_WhenBothCompleteBeforeZip() {
        
        //
        let first = Future<Bool>(value: true)
        let second = Future<Bool>(value: true)
        var onSuccessCalled = false
        
        //
        let zipped = first.zip(second)
        zipped.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(zipped.value?.0 == true && zipped.value?.1 == true)
    }
    
    func testZip_WhenBothCompleteAfterZip() {
        
        //
        let first = Future<Bool>()
        let second = Future<Bool>()
        var onSuccessCalled = false
        
        //
        let zipped = first.zip(second)
        zipped.onSuccess { (_) in
            onSuccessCalled = true
        }
        
        first.success(true)
        second.success(true)
        
        //
        XCTAssert(onSuccessCalled)
        XCTAssert(zipped.value?.0 == true && zipped.value?.1 == true)
    }
    
    func testZipOnErrorCalled_WhenFirstCompleteWithError() {
        
        //
        let first = Future<Bool>()
        let second = Future<Bool>()
        var onErrorCalled = false
        
        //
        let zipped = first.zip(second)
        
        first.error(DataGenerator.error)
        second.success(true)
        
        zipped.onError { (_) in
            onErrorCalled = true
        }
        
        //
        XCTAssertNil(zipped.value)
        XCTAssertTrue(onErrorCalled)
    }
    
    func testZipOnErrorCalled_WhenSecondCompleteWithError() {
        
        //
        let first = Future<Bool>()
        let second = Future<Bool>()
        var onErrorCalled = false
        
        //
        let zipped = first.zip(second)
        
        first.success(true)
        second.error(DataGenerator.error)
        
        zipped.onError { (_) in
            onErrorCalled = true
        }
        
        //
        XCTAssertNil(zipped.value)
        XCTAssertTrue(onErrorCalled)
    }
    
    func testAndThenCalled_WhenCompleteBeforeAndThen() {
        
        //
        let future = Future<Bool>(value: true)
        var andThenCalled = false
        
        //
        future.andThen { (_) in
            andThenCalled = true
        }
        
        //
        XCTAssert(andThenCalled)
    }
    
    func testAndThenCalled_WhenCompleteAfterAndThen() {
        
        //
        let future = Future<Bool>()
        var andThenCalled = false
        
        //
        future.andThen { (_) in
            andThenCalled = true
        }
        
        future.success(true)
        
        //
        XCTAssert(andThenCalled)
    }
    
    func testAndThenNotCalled_WhenCompleteWithError() {
        
        //
        let future = Future<Bool>()
        var andThenCalled = false
        
        //
        future.andThen { (_) in
            andThenCalled = true
            XCTFail()
        }
        
        future.error(DataGenerator.error)
        
        //
        XCTAssertFalse(andThenCalled)
    }
    
    // MARK: - Properties getters
    
    func testValueGetter_WhenNil() {
        
        //
        let future = Future<Bool>()
        
        //
        XCTAssertNil(future.value)
    }
    
    func testValueGetter_WhenNotNil() {
        
        //
        let future = Future<Bool>(value: true)
        
        //
        XCTAssertNotNil(future.value)
    }
    
    func testErrorGetter_WhenNil() {
        
        //
        let future = Future<Bool>()
        
        //
        XCTAssertNil(future.error)
    }
    
    func testErrorGetter_WhenNotNil() {
        
        //
        let future = Future<Bool>(error: DataGenerator.error)
        
        //
        XCTAssertNotNil(future.error)
    }
    
    func testOnCompletedGetter_WhenFalse() {
        
        //
        let future = Future<Bool>()
        
        //
        XCTAssertFalse(future.isCompleted)
    }
    
    func testOnCompletedGetter_WhenNotTrue() {
        
        //
        let future = Future<Bool>(result: .value(true))
        
        //
        XCTAssertTrue(future.isCompleted)
    }

    func testIsSuccessGetter_WhenFalse() {
        
        //
        let future = Future<Bool>(error: DataGenerator.error)
        
        //
        XCTAssertFalse(future.isSuccess)
    }
    
    func testIsSuccessGetter_WhenNotTrue() {
        
        //
        let future = Future<Bool>(value: true)
        
        //
        XCTAssertTrue(future.isSuccess)
    }
    
    func testIsErrorGetter_WhenFalse() {
        
        //
        let future = Future<Bool>(value: true)
        
        //
        XCTAssertFalse(future.isError)
    }
    
    func testIsErrorGetter_WhenNotTrue() {
        
        //
        let future = Future<Bool>(error: DataGenerator.error)
        
        //
        XCTAssertTrue(future.isError)
    }
    
    // MARK: - CustomStringConvertible, CustomDebugStringConvertible
    
    func test_CustomStringConvertible_And_CustomDebugStringConvertible() {
        
        //
        let testString = "testString"
        let stringFuture = Future<String>(value: testString)
        let errorText = "errorText"
        let errorFuture = Future<String>(error: DataGenerator.equatableError(errorText))
        let notCompletedFuture = Future<String>()
        
        //
        XCTAssert(
            stringFuture.description.contains(testString) && stringFuture.debugDescription.contains(testString)
        )
        XCTAssert(
            errorFuture.description.contains(errorText) && errorFuture.debugDescription.contains(errorText)
        )
        XCTAssert(notCompletedFuture.description.contains("not completed"))
    }
}
