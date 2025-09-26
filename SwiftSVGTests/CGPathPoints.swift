//
//  CGPathPoints.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

import CoreGraphics
@testable import SwiftSVG

extension CGPath {
    var points: [CGPoint] {
        var arrayPoints = [CGPoint]()
        for element in self {
            switch element.type {
            case CGPathElementType.moveToPoint:
                arrayPoints.append(element.points[0])
            case .addLineToPoint:
                arrayPoints.append(element.points[0])
            case .addQuadCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
            case .addCurveToPoint:
                arrayPoints.append(element.points[0])
                arrayPoints.append(element.points[1])
                arrayPoints.append(element.points[2])
            case .closeSubpath:
                arrayPoints.append(element.points[0])
			default:
				fatalError("Unknown CGPathElement")
            }
        }
        return arrayPoints
    }

    var pointsAndTypes: [(CGPoint, CGPathElementType)] {
        var arrayPoints = [(CGPoint, CGPathElementType)]()
        for element in self {
            switch element.type {
            case CGPathElementType.moveToPoint:
                arrayPoints.append((element.points[0], .moveToPoint))
            case .addLineToPoint:
                arrayPoints.append((element.points[0], .addLineToPoint))
            case .addQuadCurveToPoint:
                arrayPoints.append((element.points[0], .addQuadCurveToPoint))
                arrayPoints.append((element.points[1], .addQuadCurveToPoint))
            case .addCurveToPoint:
                arrayPoints.append((element.points[0], .addCurveToPoint))
                arrayPoints.append((element.points[1], .addCurveToPoint))
                arrayPoints.append((element.points[2], .addCurveToPoint))
            case .closeSubpath:
				arrayPoints.append((CGPoint(x: Double(Float.nan),
											y: Double(Float.nan)),
									.closeSubpath))
			default:
				fatalError("Unknown CGPathElement")
            }
        }
        return arrayPoints
    }
}

extension PathCommand {
    init(parameters: [Double], pathType: PathType, path: UIBezierPath, previousCommand: PreviousCommand? = nil) {
        self.init(pathType: pathType)
        coordinateBuffer = parameters
        execute(on: path, previousCommand: previousCommand)
    }
}

// MARK: - CGPath Element Structure
/// A structure representing a single path element with its type and associated points
public struct CGPathElement {
	public let type: CGPathElementType
	public let points: [CGPoint]

	public init(type: CGPathElementType, points: [CGPoint]) {
		self.type = type
		self.points = points
	}
}

// MARK: - CGPath Sequence Conformance
extension CGPath: @retroactive Sequence {
	public typealias Element = CGPathElement

	public func makeIterator() -> CGPathIterator {
		return CGPathIterator(path: self)
	}
}

// MARK: - CGPath Iterator
public struct CGPathIterator: IteratorProtocol {
	public typealias Element = CGPathElement

	private let path: CGPath
	private var elements: [CGPathElement] = []
	private var currentIndex = 0

	public init(path: CGPath) {
		self.path = path
		self.extractElements()
	}

	public mutating func next() -> CGPathElement? {
		guard currentIndex < elements.count else { return nil }
		let element = elements[currentIndex]
		currentIndex += 1
		return element
	}

	private mutating func extractElements() {
		var pathElements: [CGPathElement] = []

		path.applyWithBlock { elementPointer in
			let element = elementPointer.pointee
			let type = element.type

			var points: [CGPoint] = []
			let pointsPointer = element.points

			switch type {
			case .moveToPoint, .addLineToPoint:
				points = [pointsPointer[0]]
			case .addQuadCurveToPoint:
				points = [pointsPointer[0], pointsPointer[1]]
			case .addCurveToPoint:
				points = [pointsPointer[0], pointsPointer[1], pointsPointer[2]]
			case .closeSubpath:
				points = []
			@unknown default:
				points = []
			}

			pathElements.append(CGPathElement(type: type, points: points))
		}

		self.elements = pathElements
	}
}

// MARK: - Convenience Extensions
extension CGPath {
	/// Returns an array of all path elements
	public var pathElements: [CGPathElement] {
		return Array(self)
	}

	/// Returns the number of elements in the path
	public var elementCount: Int {
		return pathElements.count
	}

	/// Returns all points in the path as a flat array
	public var allPoints: [CGPoint] {
		return flatMap { $0.points }
	}

	/// Returns only the points that represent actual positions (excluding control points)
	public var endPoints: [CGPoint] {
		return compactMap { element in
			switch element.type {
			case .moveToPoint, .addLineToPoint:
				return element.points.first
			case .addQuadCurveToPoint, .addCurveToPoint:
				return element.points.last
			case .closeSubpath:
				return nil
			@unknown default:
				return nil
			}
		}
	}
}
