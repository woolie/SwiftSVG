//
//  Transformable.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// A struct that represents a single transformation that can then be combined with other `Transform`s
struct Transform {
	let affineTransform: CGAffineTransform

	init?(rawValue: String, coordinatesString: String) {
		let coordinatesArray = coordinatesString.components(separatedBy: CharacterSet(charactersIn: ", "))

		guard !coordinatesArray.isEmpty else { return nil }

		let coordinates = coordinatesArray.compactMap { thisCoordinate -> CGFloat? in
			return CGFloat(thisCoordinate.trimWhitespace())
		}

		guard !coordinates.isEmpty else { return nil }

		switch rawValue {
		case "matrix":
			guard coordinates.count >= 6 else { return nil }
			affineTransform = CGAffineTransform(
				a: coordinates[0], b: coordinates[1],
				c: coordinates[2], d: coordinates[3],
				tx: coordinates[4], ty: coordinates[5]
			)

		case "rotate":
			if coordinates.count == 1 {
				let degrees = CGFloat(coordinates[0])
				affineTransform = CGAffineTransform(rotationAngle: degrees.toRadians)
			} else if coordinates.count == 3 {
				let degrees = CGFloat(coordinates[0])
				let translate = CGAffineTransform(translationX: coordinates[0], y: coordinates[1])
				let rotate = CGAffineTransform(rotationAngle: degrees.toRadians)
				let translateReverse = CGAffineTransform(translationX: -coordinates[0], y: -coordinates[1])
				affineTransform = translate.concatenating(rotate).concatenating(translateReverse)
			} else {
				return nil
			}

		case "scale":
			if coordinates.count == 1 {
				affineTransform = CGAffineTransform(scaleX: coordinates[0], y: coordinates[0])
			} else {
				affineTransform = CGAffineTransform(scaleX: coordinates[0], y: coordinates[1])
			}

		case "skewX":
			affineTransform = CGAffineTransform(
				a: 1.0, b: tan(coordinates[0]),
				c: 0.0, d: 1.0,
				tx: 0.0, ty: 0.0
			)

		case "skewY":
			affineTransform = CGAffineTransform(
				a: 1.0, b: 0.0,
				c: tan(coordinates[0]), d: 1.0,
				tx: 0.0, ty: 0.0
			)

		case "translate":
			if coordinates.count == 1 {
				affineTransform = CGAffineTransform(translationX: coordinates[0], y: 0.0)
				return
			}
			affineTransform = CGAffineTransform(translationX: coordinates[0], y: coordinates[1])

		default:
			return nil
		}
	}
}

private enum TransformableConstants {
	static let attributesRegex = "(\\w+)\\(((\\-?\\d+\\.?\\d*e?\\-?\\d*\\s*,?\\s*)+)\\)"
}

/// A protocol that describes an instance that can be transformed via an SVG element's `transform` attribute. Currently, `matrix`, `rotate`, `scale`, `skewX`, and `skewY` are supported. A default implementation is supplied for `SVGContainerElement`s that sets the `affineTransform` of the container layer itself, not on all of its subelements.
public protocol Transformable {
	var layerToTransform: CALayer { get }
}

extension Transformable where Self: SVGContainerElement {
	/// Default implementation for a `SVGContainerElement` that transforms the `containerLayer`
	var layerToTransform: CALayer {
		containerLayer
	}
}

extension Transformable where Self: SVGShapeElement {
	/// Default implementation for a `SVGShapeElement` that transforms the `svgLayer`
	var layerToTransform: CALayer {
		svgLayer
	}
}

extension Transformable where Self: SVGShapeElement {
	///
	/// The curried function to be used for the `SVGElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
	/// - parameter Key: The SVG string value of the attribute
	/// - parameter Value: A curried function to use to implement the SVG attribute
	///
	var transformAttributes: [String: (String) -> Void] {
		[
			"transform": transform,
		]
	}
}

extension Transformable where Self: SVGGroup {
	///
	/// The curried function to be used for the `SVGElement`'s default implementation. This dictionary is meant to be used in the `SVGParserSupportedElements` instance
	/// - parameter Key: The SVG string value of the attribute
	/// - parameter Value: A curried function to use to implement the SVG attribute
	///
	var transformAttributes: [String: (String) -> Void] {
		[
			"transform": unown(self, SVGGroup.transform)
		]
	}
}

extension Transformable {
	/// Parses and applies the SVG transform string to this `SVGElement`'s `SVGLayer`. Can parse multiple transforms separated by spaces
	func transform(_ transformString: String) {
		do {
			let regex = try NSRegularExpression(pattern: TransformableConstants.attributesRegex, options: .caseInsensitive)
			let matches = regex.matches(in: transformString, options: [], range: NSMakeRange(0, transformString.utf8.count))

			let combinedTransforms = matches
				.compactMap { thisMatch -> Transform? in
					let nameRange = thisMatch.range(at: 1)
					let coordinateRange = thisMatch.range(at: 2)
					let transformName = transformString[nameRange.location ..< nameRange.location + nameRange.length]
					let coordinateString = transformString[coordinateRange.location ..< coordinateRange.location + coordinateRange.length]
					return Transform(rawValue: transformName, coordinatesString: coordinateString)
				}
				.reduce(CGAffineTransform.identity) { accumulate, next -> CGAffineTransform in
					return accumulate.concatenating(next.affineTransform)
				}
			layerToTransform.setAffineTransform(combinedTransforms)

		} catch {
			print("Couldn't parse transform string: \(transformString)")
			return
		}
	}
}
