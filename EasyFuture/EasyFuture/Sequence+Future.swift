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
