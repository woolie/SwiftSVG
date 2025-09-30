//
//  Fillable.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

///
/// A protocol that described an instance that can be filled. Two default implementations are provided for this protocol:
///	1. `SVGShapeElement` - Will set the fill color, fill opacity, and fill rule on the underlying `SVGLayer` which is a subclass of `CAShapeLayer`
///	2. `SVGGroup` - Will set the fill color, fill opacity, and fill rule of all of a `SVGGroup`'s subelements
///
public protocol Fillable {}

/// Default implementation for fill attributes on `SVGShapeElement`s
extension Fillable where Self: SVGShapeElement {
	///
	/// The curried functions to be used for the `SVGShapeElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
	/// - parameter Key: The SVG string value of the attribute
	/// - parameter Value: A curried function to use to implement the SVG attribute
	///
	var fillAttributes: [String: (String) -> Void] {
		[
			"color": fill,
			"fill": fill,
			"fill-opacity": fillOpacity,
			"fill-rule": fillRule,
			"opacity": fillOpacity,
		]
	}

	///
	/// Sets the fill color of the underlying `SVGLayer`
	/// - SeeAlso: CAShapeLayer's [`fillColor`](https://developer.apple.com/documentation/quartzcore/cashapelayer/1522248-fillcolor)
	///
	func fill(fillColor: String) {
		guard let colorComponents = svgLayer.fillColor?.components else { return }
		guard let fillColor = UIColor(svgString: fillColor) else { return }
		svgLayer.fillColor = fillColor.withAlphaComponent(colorComponents[3]).cgColor
	}

	///
	/// Sets the fill rule of the underlying `SVGLayer`. `CAShapeLayer`s have 2 possible values: `non-zero` (default), and `evenodd`
	/// - SeeAlso: Core Animation's [Shape Fill Mode Value](https://developer.apple.com/documentation/quartzcore/cashapelayer/shape_fill_mode_values)
	///
	func fillRule(fillRule: String) {
		guard fillRule == "evenodd" else { return }
		svgLayer.fillRule = CAShapeLayerFillRule.evenOdd
	}

	/// Sets the fill opacity of the underlying `SVGLayer` through its CGColor, not the CALayer's opacity property. This value will override any opacity value passed in with the `fill-color` attribute.
	func fillOpacity(opacity: String) {
		guard let opacity = CGFloat(opacity) else { return }
		guard let colorComponents = svgLayer.fillColor?.components else { return }
		svgLayer.fillColor = UIColor(red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: opacity).cgColor
	}
}

/// Default implementation for fill attributes on `SVGGroup`s
extension Fillable where Self: SVGGroup {
	/// The curried functions to be used for the `SVGGroup`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
	var fillAttributes: [String: (String) -> Void] {
		[
			"color": unown(self, SVGGroup.fill),
			"fill": unown(self, SVGGroup.fill),
			"fill-opacity": unown(self, SVGGroup.fillOpacity),
			"fill-rule": unown(self, SVGGroup.fillRule),
			"opacity": unown(self, SVGGroup.fillOpacity),
		]
	}

	/// Sets the fill color for all subelements of the `SVGGroup`
	func fill(_ fillColor: String) {
		delayedAttributes["fill"] = fillColor
	}

	///
	/// Sets the fill rule for all subelements of the `SVGGroup`. `CAShapeLayer`s have 2 possible values: `non-zero` (default), and `evenodd`
	/// - SeeAlso: Core Animation's [Shape Fill Mode Value](https://developer.apple.com/documentation/quartzcore/cashapelayer/shape_fill_mode_values)
	///
	func fillRule(_ fillRule: String) {
		delayedAttributes["fill-rule"] = fillRule
	}

    /**
	/// Sets the fill opacity for all subelements of the `SVGGroup` through its CGColor, not the CALayer's opacity property.
     */
	func fillOpacity(_ opacity: String) {
		delayedAttributes["opacity"] = opacity
	}
}
