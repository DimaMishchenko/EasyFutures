//
//  FuturesSequenceTests.swift
//  EasyFuturesTests
//
//  Created by Dima Mishchenko on 09.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

import XCTest
@testable import EasyFutures

class FuturesSequenceTests: XCTestCase {
    
    func testFold_AfterAllSuccess() {
        
        //
        let firstNumber = 1
        let secondNumber = 2
        let thirdNumber = 3
        
        let futures = [Future<Int>(value: firstNumber),
                       Future<Int>(value: secondNumber),
                       Future<Int>(value: thirdNumber)]
        
        //
        let folded = futures.fold(0, { $0 + $1 })
        
        //
        XCTAssert(folded.value == firstNumber + secondNumber + thirdNumber)
    }
    
    func testFold_BeforeAllSuccess() {
        
        //
        let firstNumber = 1
        let secondNumber = 2
        let thirdNumber = 3
        
        let firstFuture = Future<Int>()
        let secondFuture = Future<Int>()
        let thirdFuture = Future<Int>()
        
        let futures = [firstFuture, secondFuture, thirdFuture]
        
        var onCompleteCalled = false
        
        //
        let folded = futures.fold(0, { $0 + $1 })
        
        firstFuture.success(firstNumber)
        secondFuture.success(secondNumber)
        thirdFuture.success(thirdNumber)
        
        folded.onComplete { (_) in
            onCompleteCalled = true
        }
        
        //
        XCTAssert(onCompleteCalled)
        XCTAssert(folded.value == firstNumber + secondNumber + thirdNumber)
    }
    
    func testFold_AfterError() {
        
        //
        let firstNumber = 1
        let secondNumber = 2
        
        let futures = [Future<Int>(value: firstNumber),
                       Future<Int>(value: secondNumber),
                       Future<Int>(error: DataGenerator.error)]
        
        var onErrorCalled = false
        
        //
        let folded = futures.fold(0, { $0 + $1 })
        
        folded.onError { (_) in
            onErrorCalled = true
        }
        
        //
        XCTAssert(onErrorCalled)
        XCTAssertNil(folded.value)
        XCTAssert(folded.isError)
    }
    
    func testFold_BeforeError() {
        
        //
        let firstNumber = 1
        let secondNumber = 2
        let future = Future<Int>()
        
        let futures = [Future<Int>(value: firstNumber),
                       Future<Int>(value: secondNumber),
                       future]
        
        var onErrorCalled = false
        
        //
        let folded = futures.fold(0, { $0 + $1 })
        
        folded.onError { (_) in
            onErrorCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        XCTAssert(onErrorCalled)
        XCTAssertNil(folded.value)
        XCTAssert(folded.isError)
    }
    
    func testFold_WhenThorwsError() {
        
        //
        let firstNumber = 1
        let secondNumber = 2
        let thirdNumber = 3
        
        let firstFuture = Future<Int>()
        let secondFuture = Future<Int>()
        let thirdFuture = Future<Int>()
        
        let futures = [firstFuture, secondFuture, thirdFuture]
        
        var onErrorCalled = false
        
        //
        let folded = futures.fold(0, { $0 + (try throwsFunc($1, error: DataGenerator.error, throw: true)) })
        
        firstFuture.success(firstNumber)
        secondFuture.success(secondNumber)
        thirdFuture.success(thirdNumber)
        
        folded.onError { (_) in
            onErrorCalled = true
        }
        
        //
        XCTAssert(onErrorCalled)
        XCTAssertNil(folded.value)
        XCTAssert(folded.isError)
    }
    
    func testTraverse_WhenSuccessBefore() {
        
        //
        let numbers = [1, 2, 3]
        
        //
        let traversed = numbers.traverse({ Future<Int>(value: $0) })
        
        //
        XCTAssert(traversed.value == numbers)
    }
    
    func testTraverse_WhenSuccessAfter() {
        
        //
        let numbers = [1, 2, 3]
        let future = Future<Int>()
        
        var onCompleteCalled = false
        
        //
        let traversed = numbers.traverse({ _ in future })
        
        traversed.onComplete { (_) in
            onCompleteCalled = true
        }
        
        future.success(1)
        
        //
        XCTAssert(onCompleteCalled)
    }
    
    func testTraverse_WhenError() {
        
        //
        let numbers = [1, 2, 3]
        let future = Future<Int>()
        
        var onErrorCalled = false
        
        //
        let traversed = numbers.traverse({ _ in future })
        
        traversed.onError { (_) in
            onErrorCalled = true
        }
        
        future.error(DataGenerator.error)
        
        //
        XCTAssert(onErrorCalled)
    }
    
    func testSequence() {
        
        //
        let firstNumber = 1
        let secondNumber = 2
        
        let firstFuture = Future<Int>(value: firstNumber)
        let secondFuture = Future<Int>(value: secondNumber)
        
        //
        let sequence = [firstFuture, secondFuture].sequence()
        
        //
        XCTAssert(sequence.value == [firstNumber, secondNumber])
    }
}
