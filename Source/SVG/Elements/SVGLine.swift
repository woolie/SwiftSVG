//
//  SVGLine.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Concrete implementation that creates a `CAShapeLayer` from a `<line>` element and its attributes
final class SVGLine: SVGShapeElement {
	/// :nodoc:
	static let elementName = "line"

	/// The line's end point. Defaults to `CGPoint.zero`
	var end = CGPoint.zero

	/// The line's end point. Defaults to `CGPoint.zero`
	var start = CGPoint.zero

	/// :nodoc:
	var svgLayer = CAShapeLayer()

	/// :nodoc:
	var supportedAttributes: [String: (String) -> Void] = [:]

	/// Function parses a number string and sets this line's start `x`
	func x1(x1: String) {
		guard let x1 = CGFloat(x1) else { return }
		start.x = x1
	}

	/// Function parses a number string and sets this line's end `x`
	func x2(x2: String) {
		guard let x2 = CGFloat(x2) else { return }
		end.x = x2
	}

	/// Function parses a number string and sets this line's start `y`
	func y1(y1: String) {
		guard let y1 = CGFloat(y1) else { return }
		start.y = y1
	}

	/// Function parses a number string and sets this line's end `y`
	func y2(y2: String) {
		guard let y2 = CGFloat(y2) else { return }
		end.y = y2
	}

	/// Draws a line from the `startPoint` to the `endPoint`
	func didProcessElement(in container: SVGContainerElement?) {
		guard let container else { return }

		let linePath = UIBezierPath()
		linePath.move(to: start)
		linePath.addLine(to: end)
		svgLayer.path = linePath.cgPath
		container.containerLayer.addSublayer(svgLayer)
	}
}
