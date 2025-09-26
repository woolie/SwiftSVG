//
//  ClosePathTests.swift
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

import Foundation
@testable import SwiftSVG
import Testing

@Suite final class PathTests {
	@Test func closePath() async throws {
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 1.0, y: 1.0))
		path.line(to: CGPoint(x: 2.0, y: 2.0))
		path.move(to: CGPoint(x: 3.0, y: 3.0))
		path.close()
		path.move(to: CGPoint(x: 4.0, y: 4.0))
		path.line(to: CGPoint(x: 2.0, y: 2.0))
		path.move(to: CGPoint(x: 1.0, y: 1.0))
		path.line(to: CGPoint(x: 2.0, y: 2.0))
		path.close()

		path.cgPath.applyWithBlock { elementPointer in
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
			print("type: \(type), point: \(points)")
		}
		print("path: \(path.cgPath)")
	}

	// ClosePath will restore the startingPoint, hence `MoveTo(parameters: [20, -30]...`
	@Test func closePathLastElement() async throws {
        let testPath = UIBezierPath()
        _ = MoveTo(parameters: [20, -30], pathType: .absolute, path: testPath)
        _ = ClosePath(parameters: [], pathType: .absolute, path: testPath)
		let pathElements = testPath.cgPath.pointsAndTypes
        let lastPointAndType = pathElements.last!

		#expect(lastPointAndType.1 == .moveToPoint, "Expected .moveToPoint, got \(lastPointAndType.1)")
		#expect(lastPointAndType.0.x.isNaN != true && lastPointAndType.0.y.isNaN != true, "Expected NaN, NaN, got \(lastPointAndType.0)")
    }
}
