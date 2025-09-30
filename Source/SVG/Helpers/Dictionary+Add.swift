//
//  Dictionary+Add.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

import Foundation

/// An extension that add the elements of one dictionary to another
public extension Dictionary {
	/// An extension that add the elements of one dictionary to another
	mutating func add(_ dictionary: [Key: Value]) {
		for (key, value) in dictionary {
			self[key] = value
		}
	}
}
