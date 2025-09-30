//
//  Stack.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

import Foundation

/// A protocol that describes an instance that can act as a stack data structure
protocol StackType {
	associatedtype StackItem
	var items: [StackItem] { get set }
	init()
	mutating func pop() -> StackItem?
	mutating func push(_ itemToPush: StackItem)
}

/// A stack data structure
struct Stack<T>: StackType {
	var items = [T]()
	init() {}
}

extension StackType {
	/// Default implementation of popping the last element off the stack
	@discardableResult
	mutating func pop() -> StackItem? {
		guard !items.isEmpty else { return nil }
		return items.removeLast()
	}

	/// Push a new element on to the stack
	mutating func push(_ itemToPush: StackItem) {
		items.append(itemToPush)
	}

	/// Clear all elements from the stack
	mutating func clear() {
		items.removeAll()
	}

	/// Returns the number of elements on the stack
	var count: Int {
		items.count
	}

	/// Check whether the stack is empty or not
	var isEmpty: Bool {
		if items.isEmpty {
			return true
		}
		return false
	}

	/// Return the last element on the stack without popping it off the stack. Equivalent to peek in other stack implementations
	var last: StackItem? {
		if isEmpty == false {
			return items.last
		}
		return nil
	}
}
