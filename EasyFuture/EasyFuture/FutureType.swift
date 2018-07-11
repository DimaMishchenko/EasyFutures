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
    
    // MARK: - Callbacks
    
    @discardableResult func onComplete(_ completion: @escaping Future<T>.CallbackBlock) -> Self
    @discardableResult func onSuccess(_ completion: @escaping (T) -> ()) -> Self
    @discardableResult func onError(_ completion: @escaping (Error) -> ()) -> Self
    
    // MARK: - Functional composition
    
    func map<U>(_ transform: @escaping (T) throws -> U) rethrows -> Future<U>
    func flatMap<U>(_ transform: @escaping (T) throws -> Future<U>) rethrows -> Future<U>
    func filter(error customError: Error, _ predicate: @escaping (T) throws -> Bool) rethrows -> Future<T>
    func recover(_ transform: @escaping (Error) throws -> T) rethrows -> Future<T>
    func zip<U>(_ future: Future<U>) -> Future<(T,U)>
    @discardableResult func andThen(_ completion: @escaping (T) -> ()) -> Future<T>
}
