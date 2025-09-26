//
//  IndentifiableTests.swift
//  SwiftSVGTests
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

import System
import Testing
import Foundation
@testable import SwiftSVG

@Suite final class TestFileTests {
	@Test func shapeElementSetsLayerName() async throws {
		let testShapeElement = TestShapeElement()
		testShapeElement.identify(identifier: "id-to-check")
		#expect(testShapeElement.svgLayer.name == "id-to-check", "Expected \"id-to-check\", got: \(String(describing: testShapeElement.svgLayer.name))")
	}

	@Test(arguments: ["simple-rectangle.svg"])
	func testEndToEnd(filename: String) async throws {
		let resourceURL = try filePathURL(from: "simple-rectangle.svg")
		let asData = try! Data(contentsOf: resourceURL)
		await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
			Task { @MainActor in
				_ = UIView(svgData: asData) { svgLayer in
					defer { continuation.resume() }
					guard let rootLayerName = svgLayer.sublayers?[0].name else {
						Issue.record("Root layer name is nil")
						return
					}

					#expect(rootLayerName == "root-rectangle-id", "Root layer name should be 'root-rectangle-id'")

					guard let innerID = svgLayer.sublayers?[0].sublayers?[0].name else {
						Issue.record("Inner layer name is nil")
						return
					}

					#expect(innerID == "inner-rectangle-id", "Inner layer name should be 'inner-rectangle-id'")
				}
			}
		}
	}

	func filePathURL(from filename: String) throws -> URL {
		let filenamePath = FilePath(filename)
		guard let filePath = Bundle.module.path(
			forResource: filenamePath.stem,
			ofType: filenamePath.extension,
			inDirectory: "TestFiles"
		) else {
			Issue.record("Bundle path not found (\(filename))")
			throw BundleError.resourceNotFound
		}

		return URL(fileURLWithPath: filePath)
	}
}

enum BundleError: Error {
	case resourceNotFound
}
