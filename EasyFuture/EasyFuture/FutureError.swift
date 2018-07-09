//
//  FutureError.swift
//  EasyFuture
//
//  Created by Dima Mishchenko on 05.07.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import Foundation

public enum FutureError: Error {
    
    case filterError
}

extension FutureError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .filterError: return "Future filter predicate is not satisfied"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .filterError: return "Future filter predicate is not satisfied"
        }
    }
}
