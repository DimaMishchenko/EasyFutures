//
//  FutureType.swift
//  EasyFuture
//
//  Created by Dima Mishchenko on 05.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

// Needs for some extension to use 'where'

extension Future: FutureType {}

public protocol FutureType {
    
    associatedtype T
    
    // MARK: - Public properties
    
    var value: T? { get }
    var error: Error? { get }
    var isCompleted: Bool { get }
    var isSuccess: Bool { get }
    var isError: Bool { get }
    
    // MARK: - Completions
    
    func complete(_ result: Future<T>.ResultType)
    func success(_ value: T)
    func error(_ error: Error)
    
    // MARK: - Callbacks
    
    @discardableResult func onComplete(_ completion: @escaping Future<T>.CallbackBlock) -> Self
    @discardableResult func onSuccess(_ completion: @escaping (T) -> ()) -> Self
    @discardableResult func onError(_ completion: @escaping (Error) -> ()) -> Self
    
    // MARK: - Funtional composition
    
    func map<U>(_ transform: @escaping (T) throws -> U) rethrows -> Future<U>
    func flatMap<U>(_ transform: @escaping (T) throws -> Future<U>) rethrows -> Future<U>
    func filter(error customError: Error, _ predicate: @escaping (T) throws -> Bool) rethrows -> Future<T>
    func recover(_ transform: @escaping (Error) throws -> T) rethrows -> Future<T>
    func zip<U>(_ future: Future<U>) -> Future<(T,U)>
    @discardableResult func andThen(_ completion: @escaping (T) -> ()) -> Future<T>
}
