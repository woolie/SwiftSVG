//
//  CoordinateLexer.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

import CoreGraphics
import Foundation

/// A struct that conforms to the `Sequence` protocol that takes a coordinate string and continuously returns`CGPoint`s
struct CoordinateLexer: IteratorProtocol, Sequence {
	/// Generates a `CGPoint`
	typealias Element = CGPoint

	/// :nodoc:
	private var currentCharacter: CChar {
		workingString[interatorIndex]
	}

	/// :nodoc:
	private var coordinateString: String

	/// :nodoc:
	private var workingString: ContiguousArray<CChar>

	/// :nodoc:
	private var interatorIndex: Int = 0

	/// :nodoc:
	private var numberArray = [CChar]()

	/// Creates a new `CoordinateLexer` from a comma or space separated number string
	init(coordinateString: String) {
		self.coordinateString = coordinateString.trimWhitespace()
		workingString = self.coordinateString.utf8CString
	}

	/// Required by Swift's `IteratorProtocol` that returns a new `CoordinateLexer`
	func makeIterator() -> CoordinateLexer {
		CoordinateLexer(coordinateString: coordinateString)
	}

	/// Required by Swift's `IteratorProtocol` that returns the next `CGPoint` or nil if it's at the end of the sequence
	mutating func next() -> Element? {
		var didParseX = false
		var returnPoint = CGPoint.zero

		while interatorIndex < workingString.count - 1 {
			switch currentCharacter {
			case PathDConstants.DCharacter.comma.rawValue, PathDConstants.DCharacter.space.rawValue:
				interatorIndex += 1
				if !didParseX {
					if let asDouble = Double(byteArray: numberArray) {
						returnPoint.x = CGFloat(asDouble)
						numberArray.removeAll()
						didParseX = true
					}
				} else {
					if let asDouble = Double(byteArray: numberArray) {
						returnPoint.y = CGFloat(asDouble)
						numberArray.removeAll()
						didParseX = false
						return returnPoint
					}
				}

			default:
				numberArray.append(currentCharacter)
				interatorIndex += 1
			}
		}
		if didParseX {
			if let asDouble = Double(byteArray: numberArray) {
				returnPoint.y = CGFloat(asDouble)
				numberArray.removeAll()
				return returnPoint
			}
		}
		return nil
	}
}
