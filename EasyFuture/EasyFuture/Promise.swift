//
//  Promise.swift
//  EasyFuture
//
//  Created by Dima Mishchenko on 30.06.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

public class Promise<T> {

    public let future: Future<T>
    
    public init() {
        
        future = Future<T>()
    }
  
    public func complete(_ result: Future<T>.ResultType) {
        
        future.complete(result)
    }
    
    public func success(_ value: T) {
        
        future.success(value)
    }
    
    public func error(_ error: Error)  {
        
        future.error(error)
    }
}
