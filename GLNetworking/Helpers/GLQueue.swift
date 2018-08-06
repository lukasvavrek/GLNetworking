//
//  GLQueue.swift
//  GLNetworking
//
//  Created by Lukas Vavrek on 12/17/17.
//  Copyright © 2017 Lukas Vavrek. All rights reserved.
//

/// Queue generic implementation using array.
internal struct GLQueue<T> {
    fileprivate var list = [T]()
    
    /// Returns `true` if queue doesn't contain any items.
    /// `false` otherwise.
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    /// Append the item to the queue.
    /// It modifies an existing list.
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    /**
     If queue contains elements, then it removes first and returns an item.
     It modifies an existing list.
     
     If the queue is empty, then `nil` is returned.
     */
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        list.removeFirst()
        
        return element
    }
    
    /// Returns first element of the queue, if it's not empty.
    /// `nil` otherwise.
    public func peek() -> T? {
        return list.first
    }
}
