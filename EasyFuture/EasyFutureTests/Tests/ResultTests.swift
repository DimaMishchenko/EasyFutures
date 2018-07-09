//
//  ResultTests.swift
//  EasyFutureTests
//
//  Created by Dima Mishchenko on 04.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import XCTest
@testable import EasyFuture

class ResultTests: XCTestCase {
    
    // MARK: - Funtional composition
    
    func testMap_WhenValue() {
        
        //
        let testString = "result"
        let result = Result<String, Error>.value(testString)
        
        //
        let mapResult = result.map({ $0.count })
        
        //
        XCTAssertEqual(mapResult.value ?? 0, testString.count)
    }
    
    func testMap_WhenError() {
        
        //
        let result = Result<String, Error>.error(DataGenerator.error)
        
        //
        let mapResult = result.map({ $0.count })
        
        //
        XCTAssertTrue(mapResult.isError)
    }
    
    
    func testFlatMap_WhenValue() {
        
        //
        let testString = "result"
        let result = Result<String, Error>.value(testString)
        
        //
        let mapResult = result.flatMap({ .value($0.count) })
        
        //
        XCTAssertEqual(mapResult.value ?? 0, testString.count)
    }
    
    func testFlatMap_WhenError() {
        
        //
        let result = Result<String, Error>.error(DataGenerator.error)
        
        //
        let mapResult = result.flatMap({ .value($0.count) })
        
        //
        XCTAssertTrue(mapResult.isError)
    }
    
    
    func testFlatMap_WhenTransformToError() {
        
        //
        let testString = "result"
        let result = Result<String, Error>.value(testString)
        
        //
        let mapResult = result.flatMap { (value) -> Result<String, Error> in
            return .error(DataGenerator.error)
        }
        
        //
        XCTAssertTrue(mapResult.isError)
    }
    
    // MARK: - Equatable
    
    func testEquatable_WhenDifferentCases() {
        
        //
        let left = Result<Bool, EquatableError>.value(true)
        let right = Result<Bool, EquatableError>.error(DataGenerator.equatableError(""))
        
        //
        XCTAssertFalse(left == right)
    }
    
    func testEquatable_WhenValuesIsEqual() {
        
        //
        let left = Result<Bool, EquatableError>.value(true)
        let right = Result<Bool, EquatableError>.value(true)
        
        //
        XCTAssertTrue(left == right)
    }
    
    func testEquatable_WhenValuesIsNotEqual() {
        
        //
        let left = Result<Bool, EquatableError>.value(true)
        let right = Result<Bool, EquatableError>.value(false)
        
        //
        XCTAssertFalse(left == right)
    }
    
    func testEquatable_WhenErrorsIsEqual() {
        
        //
        let left = Result<Bool, EquatableError>.error(DataGenerator.equatableError("equal"))
        let right = Result<Bool, EquatableError>.error(DataGenerator.equatableError("equal"))
        
        //
        XCTAssertTrue(left == right)
    }
    
    func testEquatable_WhenErrorsIsNotEqual() {
        
        //
        let left = Result<Bool, EquatableError>.error(DataGenerator.equatableError("equal"))
        let right = Result<Bool, EquatableError>.error(DataGenerator.equatableError("notEqual"))
        
        //
        XCTAssertFalse(left == right)
    }
    
    // MARK: - On Value
    
    func testOnValue_WhenValueIsNotNil() {
        
        //
        let result = Result<Bool, Error>.value(true)
        var onValueCalled = false
        
        //
        result.onValue { (value) in
            onValueCalled = true
        }
        
        //
        XCTAssertTrue(onValueCalled)
    }
    
    func testOnValue_WhenValueIsNil() {
        
        //
        let result = Result<Bool, Error>.error(DataGenerator.error)
        var onValueCalled = false
        
        //
        result.onValue { (value) in
            onValueCalled = true
        }
        
        //
        XCTAssertFalse(onValueCalled)
    }
    
    // MARK: - On Error
    
    func testOnError_WhenErrorIsNotNil() {
        
        //
        let result = Result<Bool, Error>.error(DataGenerator.error)
        var onErrorCalled = false
        
        //
        result.onError { (error) in
            onErrorCalled = true
        }
        
        //
        XCTAssertTrue(onErrorCalled)
    }
    
    func testOnError_WhenErrorIsNil() {
        
        //
        let result = Result<Bool, Error>.value(true)
        var onErrorCalled = false
        
        //
        result.onError { (error) in
            onErrorCalled = true
        }
        
        //
        XCTAssertFalse(onErrorCalled)
    }
    
    // MARK: - Getters
    
    func testValueGetter_WhenValue() {
        
        //
        let result = Result<Bool, Error>.value(true)
        
        //
        XCTAssertNotNil(result.value)
    }
    
    func testValueGetter_WhenError() {
        
        //
        let result = Result<Bool, Error>.error(DataGenerator.error)
        
        //
        XCTAssertNil(result.value)
    }
    
    func testErrorGetter_WhenError() {
        
        //
        let result = Result<Bool, Error>.error(DataGenerator.error)
        
        //
        XCTAssertNotNil(result.error)
    }
    
    func testErrorGetter_WhenValue() {
        
        //
        let result = Result<Bool, Error>.value(true)
        
        //
        XCTAssertNil(result.error)
    }
    
    func testIsErrorGetter_WhenError() {
        
        //
        let result = Result<Bool, Error>.error(DataGenerator.error)
        
        //
        XCTAssertTrue(result.isError)
    }
    
    func testIsErrorGetter_WhenValue() {
        
        //
        let result = Result<Bool, Error>.value(true)
        
        //
        XCTAssertFalse(result.isError)
    }
}
