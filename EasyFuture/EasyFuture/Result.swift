//
//  Result.swift
//  EasyFuture
//
//  Created by Dima Mishchenko on 30.06.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

public enum Result<T, E> {
    
    case value(T)
    case error(E)
    
    public var value: T? {
        
        switch self {
        case .value(let value):
            return value
        case .error:
            return nil
        }
    }
    
    public var error: E? {
        
        switch self {
        case .error(let error):
            return error
        case .value:
            return nil
        }
    }
    
    public var isError: Bool {
        
        switch self {
        case .error:
            return true
        case .value:
            return false
        }
    }
    
    public func onValue(_ closure: (T) -> ()) {
        
        if let value = value {
            closure(value)
        }
    }
    
    public func onError(_ closure: (E) -> ()) {
        
        if let error = error {
            closure(error)
        }
    }
    
    // MARK: - Functional composition
    
    public func map<U>(_ transform: (T) throws -> U) rethrows -> Result<U, E> {
        
        switch self {
        case .value(let value):
            return try .value(transform(value))
        case .error(let error):
            return .error(error)
        }
    }
    
    public func flatMap<U>(_ transform: (T) throws -> Result<U, E>) rethrows -> Result<U, E> {
        
        switch self {
        case .value(let value):
            return try transform(value)
        case .error(let error):
            return .error(error)
        }
    }
}

extension Result where T: Equatable, E: Equatable {
    
    public static func ==(left: Result<T, E>, right: Result<T, E>) -> Bool {
        
        if let left = left.value, let right = right.value {
            return left == right
        } else if let left = left.error, let right = right.error {
            return left == right
        }
        return false
    }
}
