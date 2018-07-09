//
//  Sequence+Future.swift
//  EasyFuture
//
//  Created by Dima Mishchenko on 05.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

extension Sequence {
    
    public func traverse<U, F: FutureType>(
        _ transform: (Iterator.Element) throws -> F) rethrows -> Future<[U]> where F.T == U {

        return try map(transform).fold([U](), { (initialResult, element) -> [U] in
            return initialResult + [element]
        })
    }
}


extension Sequence where Iterator.Element : FutureType {
    
    public func fold<R>(_ initialResult: R,
                        _ nextPartialResult: @escaping (R, Iterator.Element.T) throws -> R) -> Future<R> {
        
        return reduce(Future<R>(value: initialResult), { initialResult, element -> Future<R> in
            return initialResult.flatMap { value -> Future<R> in
                return try element.map { elementValue -> R in
                    return try nextPartialResult(value, elementValue)
                }
            }
        })
    }
    
    public func sequence() -> Future<[Iterator.Element.T]> {
        
        return traverse { $0 }
    }
}
