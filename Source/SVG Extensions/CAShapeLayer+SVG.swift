//
//  CAShapeLayer+SVG.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public extension CAShapeLayer {
	///
	/// Convenience initalizer that synchronously parses a single path string and returns a `CAShapeLayer`
	/// - Parameter pathString: The path `d` string to parse.
	///
	convenience init(pathString: String) {
		self.init()
		let singlePath = SVGPath(singlePathString: pathString)
		path = singlePath.svgLayer.path
	}
}
