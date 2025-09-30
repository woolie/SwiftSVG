//
//  SVGPolygon.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Concrete implementation that creates a `CAShapeLayer` from a `<polygon>` element and its attributes
struct SVGPolygon: SVGShapeElement {
	/// :nodoc:
	static let elementName = "polygon"

	/// :nodoc:
	var supportedAttributes: [String: (String) -> Void] = [:]

	/// :nodoc:
	var svgLayer = CAShapeLayer()

	/// Function that parses a coordinate string and creates a polygon path
	func points(points: String) {
		let polylinePath = UIBezierPath()
		for (index, thisPoint) in CoordinateLexer(coordinateString: points).enumerated() {
			if index == 0 {
				polylinePath.move(to: thisPoint)
			} else {
				polylinePath.addLine(to: thisPoint)
			}
		}
		polylinePath.close()
		svgLayer.path = polylinePath.cgPath
	}

	/// :nodoc:
	func didProcessElement(in container: SVGContainerElement?) {
		guard let container else { return }
		container.containerLayer.addSublayer(svgLayer)
	}
}
