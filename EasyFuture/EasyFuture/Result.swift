// MIT License
//
// Copyright (c) 2018 DimaMishchenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
    
    // MARK: - Funtional composition
    
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
