//
//  IndentifiableTests.swift
//  SwiftSVGTests
//
//  Copyright (c) 2017 Michael Choe
//

import Foundation
@testable import SwiftSVG
import System
import Testing

@Suite final class TestFileTests {
	@Test func shapeElementSetsLayerName() async throws {
		let testShapeElement = TestShapeElement()
		testShapeElement.identify(identifier: "id-to-check")
		#expect(testShapeElement.svgLayer.name == "id-to-check", "Expected \"id-to-check\", got: \(String(describing: testShapeElement.svgLayer.name))")
	}

	@Test(arguments: ["simple-rectangle.svg"])
	func endToEnd(filename: String) async throws {
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
