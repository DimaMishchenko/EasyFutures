//
//  ThrowsFunction.swift
//  EasyFuturesTests
//
//  Created by Dima Mishchenko on 05.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

func throwsFunc<T>(_ value: T, error: Error, throw mustThrow: Bool) throws -> T {
    
    if mustThrow {
        throw error
    } else {
        return value
    }
}
