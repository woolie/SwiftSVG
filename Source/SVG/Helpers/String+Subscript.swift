//
//  String+Subscript.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

import Foundation
#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

public extension String {
	/// Helper function that creates a new String from a given integer range
	subscript(integerRange: Range<Int>) -> String {
		let start = index(startIndex, offsetBy: integerRange.lowerBound)
		let end = index(startIndex, offsetBy: integerRange.upperBound)
		return String(self[start ..< end])
	}
}
