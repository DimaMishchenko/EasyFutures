//
//  Future.swift
//  EasyFuture
//
//  Created by Dima Mishchenko on 30.06.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

public class Future<T> {
    
    public typealias ResultType = Result<T, Error>
    public typealias CallbackBlock = (ResultType) -> ()
    
    // MARK: - Private properties
    
    private var result: ResultType?
    private var callbacks: [CallbackBlock] = []
    
    // MARK: - Public properties
    
    public var value: T?            { return result?.value }
    public var error: Error?        { return result?.error }
    public var isCompleted: Bool    { return result != nil }
    public var isSuccess: Bool      { return result?.value != nil }
    public var isError: Bool        { return result?.error != nil }
    
    // MARK: - Inits
    
    public init() {}
    
    public init(operation: (@escaping CallbackBlock) -> ()) {
        
        operation { result in
            self.complete(result)
        }
    }
    
    public convenience init(result: ResultType) {
        
        self.init(operation: { completion in
            completion(result)
        })
    }

    public convenience init(value: T) {
        
        self.init(result: .value(value))
    }

    public convenience init(error: Error) {
        
        self.init(result: .error(error))
    }
}

// MARK: - Completions

extension Future {
    
    public func complete(_ result: ResultType) {
        
        self.result = result
        callbacks.forEach { $0(result) }
        callbacks.removeAll()
    }
    
    public func success(_ value: T) {
        
        complete(.value(value))
    }
    
    public func error(_ error: Error) {
        
        complete(.error(error))
    }
}

// MARK: - Callbacks

extension Future {
    
    @discardableResult
    public func onComplete(_ completion: @escaping CallbackBlock) -> Self {
        
        if let result = self.result {
            completion(result)
        } else {
            callbacks.append(completion)
        }
        return self
    }
    
    @discardableResult
    public func onSuccess(_ completion: @escaping (T) -> ()) -> Self {
        
        onComplete { result in
            switch result {
            case .value(let value): completion(value)
            default: break
            }
        }
        return self
    }
    
    @discardableResult
    public func onError(_ completion: @escaping (Error) -> ()) -> Self {
        
        onComplete { result in
            switch result {
            case .error(let error): completion(error)
            default: break
            }
        }
        return self
    }
}

// MARK: - Funtional composition

extension Future {
    
    // MARK: - Map
    
    public func map<U>(_ transform: @escaping (T) throws -> U) -> Future<U> {
        
        return Future<U> { completion in
            self.onComplete { result in
                switch result {
                case .value(let value):
                    do {
                        completion(.value(try transform(value)))
                    } catch {
                        completion(.error(error))
                    }
                case .error(let error):
                    completion(.error(error))
                }
            }
        }
    }
    
    // MARK: - FlatMap
    
    public func flatMap<U>(_ transform: @escaping (T) throws -> Future<U>) -> Future<U> {
        
        return map(transform).flatten()
    }
    
    // MARK: - Filter
    
    public func filter(error customError: Error = FutureError.filterError,
                       _ predicate: @escaping (T) throws -> Bool) -> Future<T> {
        
        return Future<T>(operation: { completion in
            self.onComplete { result in
                switch result {
                case .value(let value):
                    do {
                        if try predicate(value) {
                            completion(.value(value))
                        } else {
                            completion(.error(customError))
                        }
                    } catch {
                        completion(.error(error))
                    }
                case .error: completion(result)
                }
            }
        })
    }
    
     // MARK: - Recover
    
    public func recover(_ transform: @escaping (Error) throws -> T) -> Future<T> {
        
        return Future<T>(operation: { completion in
            self.onComplete { result in
                switch result {
                case .value: completion(result)
                case .error(let error):
                    do {
                        completion(.value(try transform(error)))
                    } catch {
                        completion(.error(error))
                    }
                }
            }
        })
    }
    
    // MARK: - Zip
    
    public func zip<U>(_ future: Future<U>) -> Future<(T,U)> {
        
        let zipped = flatMap { currentValue -> Future<(T,U)> in
            return future.map { newValue in
                return (currentValue, newValue)
            }
        }
        return zipped
    }
    
    // MARK: - AndThen
    
    @discardableResult
    public func andThen(_ completion: @escaping (T) -> ()) -> Future<T> {
        
        let future = Future<T>()
        future.onSuccess(completion)
        onComplete { result in
            future.complete(result)
        }
        return future
    }
}

// MARK: - Flatten

extension Future where T: FutureType {

    public func flatten() -> Future<T.T> {

        return Future<T.T> { completion in
            self.onComplete { result in
                switch result {
                case .value(let value): value.onComplete(completion)
                case .error(let error): completion(.error(error))
                }
            }
        }
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

extension Future: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        let resultString = result == nil ? "not completed" : "\(result!)"
        return String(describing: Future.self) + "\n" + "Result: \(resultString)"
    }
    
    public var debugDescription: String { return description }
}
