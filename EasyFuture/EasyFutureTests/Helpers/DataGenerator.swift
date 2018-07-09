//
//  DataGenerator.swift
//  EasyFutureTests
//
//  Created by Dima Mishchenko on 02.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

class DataGenerator {
    
    static var error: Error {
        return NSError(domain: "com.easyfuture.tests", code: 2000, userInfo: nil)
    }
    
    static func equatableError(_ message: String) -> EquatableError {
        return .error(message: message)
    }
}
