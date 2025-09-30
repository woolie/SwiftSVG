//
//  SVGEllipse.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// Concrete implementation that creates a `CAShapeLayer` from a `<ellipse>` element and its attributes
final class SVGEllipse: SVGShapeElement {
	/// :nodoc:
	static let elementName = "ellipse"

	/// The ellipse's center point. Defaults to `CGRect.zero`
	var ellipseCenter = CGPoint.zero

	///  The ellipse's x radius. Defaults to `CGRect.zero`
	var xRadius: CGFloat = 0

	/// The ellipse's x radius. Defaults to `CGRect.zero`
	var yRadius: CGFloat = 0

	/// :nodoc:
	var svgLayer = CAShapeLayer()

	/// :nodoc:
	var supportedAttributes: [String: (String) -> Void] = [:]

	/// Function that parses the number string and sets this instance's x radius
	func xRadius(r: String) {
		guard let r = CGFloat(lengthString: r) else { return }
		xRadius = r
	}

	/// Function that parses the number string and sets this instance's y radius
	func yRadius(r: String) {
		guard let r = CGFloat(lengthString: r) else { return }
		yRadius = r
	}

	/// Function that parses the number string and sets this instance's x center
	func xCenter(x: String) {
		guard let x = CGFloat(lengthString: x) else { return }
		ellipseCenter.x = x
	}

	/// Function that parses the number string and sets this instance's y center
	func yCenter(y: String) {
		guard let y = CGFloat(lengthString: y) else { return }
		ellipseCenter.y = y
	}

	/// Function that is called after the ellipse's center and radius have been parsed and set. This function creates the path and sets the internal `SVGLayer`'s path.
	func didProcessElement(in container: SVGContainerElement?) {
		guard let container else { return }

		let ellipseRect = CGRect(x: ellipseCenter.x - xRadius, y: ellipseCenter.y - yRadius, width: 2 * xRadius, height: 2 * yRadius)
		let circlePath = UIBezierPath(ovalIn: ellipseRect)
		svgLayer.path = circlePath.cgPath
		container.containerLayer.addSublayer(svgLayer)
	}
}
