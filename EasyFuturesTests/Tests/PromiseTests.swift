//
//  PromiseTests.swift
//  EasyFuturesTests
//
//  Created by Dima Mishchenko on 04.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import XCTest
@testable import EasyFutures

class PromiseTests: XCTestCase {
    
    func testSuccess() {
        
        //
        let promise = Promise<Bool>()
        
        //
        promise.success(true)
        
        //
        XCTAssert(promise.future.isSuccess)
    }
    
    func testError() {
        
        //
        let promise = Promise<Bool>()

        //
        promise.error(DataGenerator.error)
        
        //
        XCTAssert(promise.future.isError)
    }
    
    func testComplete_WithValue() {
        
        //
        let promise = Promise<Bool>()
        
        //
        promise.complete(.value(true))
        
        //
        XCTAssert(promise.future.isCompleted)
        XCTAssert(promise.future.isSuccess)
    }
    
    func testComplete_WithError() {
        
        //
        let promise = Promise<Bool>()
        
        //
        promise.complete(.error(DataGenerator.error))
        
        //
        XCTAssert(promise.future.isCompleted)
        XCTAssert(promise.future.isError)
    }
}
