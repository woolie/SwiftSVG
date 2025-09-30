//
//  FloatingPoint+DegreesRadians.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

import Foundation

/// Extension that converts a `FloatingPoint` to and from radians and degrees
public extension FloatingPoint {
	/// Converts a `FloatingPoint` type to radians
	var toRadians: Self {
		self * .pi / 180
	}

	/// Converts a `FloatingPoint` type to degrees
	var toDegrees: Self {
		self * 180 / .pi
	}
}
