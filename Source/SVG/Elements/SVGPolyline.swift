//
//  SVGPolyline.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Concrete implementation that creates a `CAShapeLayer` from a `<polyline>` element and its attributes
struct SVGPolyline: SVGShapeElement {
	/// :nodoc:
	static let elementName = "polyline"

	/// :nodoc:
	var supportedAttributes: [String: (String) -> Void] = [:]

	/// :nodoc:
	var svgLayer = CAShapeLayer()

	/// Parses a coordinate string and creates a new polyline based on them
	func points(points: String) {
		let polylinePath = UIBezierPath()
		for (index, thisPoint) in CoordinateLexer(coordinateString: points).enumerated() {
			if index == 0 {
				polylinePath.move(to: thisPoint)
			} else {
				polylinePath.addLine(to: thisPoint)
			}
		}
		svgLayer.path = polylinePath.cgPath
	}

	/// :nodoc:
	func didProcessElement(in container: SVGContainerElement?) {
		guard let container else { return }
		container.containerLayer.addSublayer(svgLayer)
	}
}
