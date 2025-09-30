//
//  Scalar+FromByteArray.swift
//  SwiftSVGiOS
//
//  Copyright (c) 2017 Michael Choe
//

import CoreGraphics

extension CGFloat {
	/// Initializer that creates a new CGFloat from a String
	init?(_ string: String) {
		guard let asDouble = Double(string) else { return nil }
		self.init(asDouble)
	}

	/// Initializer that creates a new CGFloat from a Character byte array with the option to set the base.
	init?(byteArray: [CChar], base: Int32 = 10) {
		var nullTerminated = byteArray
		nullTerminated.append(0)
		self.init(strtol(nullTerminated, nil, base))
	}
}

extension Float {
	/// Initializer that creates a new Float from a Character byte array
	init?(byteArray: [CChar]) {
		guard !byteArray.isEmpty else { return nil }

		var nullTerminated = byteArray
		nullTerminated.append(0)
		var error: UnsafeMutablePointer<Int8>?
		let result = strtof(nullTerminated, &error)
		if error != nil, error?.pointee != 0 {
			return nil
		}
		self = result
	}
}

extension Double {
	/// Initializer that creates a new Double from a Character byte array
	init?(byteArray: [CChar]) {
		guard !byteArray.isEmpty else { return nil }

		var nullTerminated = byteArray
		nullTerminated.append(0)
		var error: UnsafeMutablePointer<Int8>?
		let result = strtod(nullTerminated, &error)
		if error != nil, error?.pointee != 0 {
			return nil
		}
		self = result
	}
}
