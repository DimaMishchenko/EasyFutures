//
//  EquatableError.swift
//  EasyFuturesTests
//
//  Created by Dima Mishchenko on 04.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

enum EquatableError: Error, Equatable {
    
    case error(message: String)
    
    static func == (lhs: EquatableError, rhs: EquatableError) -> Bool {
        
        if case .error(let firstMessage) = lhs, case .error(let secondMessage) = rhs {
            return firstMessage == secondMessage
        }
        return false
    }
}
