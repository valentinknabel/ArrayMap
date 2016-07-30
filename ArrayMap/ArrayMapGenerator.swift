//
//  ArrayMapIterator.swift
//  ArrayMap
//
//  Created by Valentin Knabel on 05.01.16.
//  Copyright © 2016 Conclurer GmbH. All rights reserved.
//

public struct ArrayMapIterator<Key: Hashable, Value>: IteratorProtocol {

    public typealias Element = (Key, Value)

    private var primaryGenerator: Dictionary<Key, [Value]>.Iterator
    private var secondaryGenerator: Array<Value>.Generator? = nil
    private var currentKey: Key? = nil

    public init(arrayMap: ArrayMap<Key, Value>) {
        primaryGenerator = arrayMap.rawValue.makeIterator()
    }

    @warn_unused_result
    public mutating func next() -> Element? {
        if let currentKey = currentKey,
            let nextResult = secondaryGenerator?.next()
        {
            return (currentKey, nextResult)
        } else if let newValue = primaryGenerator.next() {
            currentKey = newValue.0
            secondaryGenerator = newValue.1.makeIterator()
            return next()
        } else {
            return nil
        }
    }
}
