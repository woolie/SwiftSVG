//
//  SVGLayer.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// A protocol that describes an instance that can store bounding box information
public protocol SVGLayerType {
	var boundingBox: CGRect { get }
}

public extension SVGLayerType where Self: CALayer {
	///
	/// Scales a layer to aspect fit the given size.
	/// - Parameter rect: The `CGRect` to fit into
	/// - TODO: Should eventually support different content modes
	///
	@discardableResult
	func resizeToFit(_ rect: CGRect) -> Self {
		let boundingBoxAspectRatio = boundingBox.width / boundingBox.height
		let viewAspectRatio = rect.width / rect.height

		let scaleFactor: CGFloat = if boundingBoxAspectRatio > viewAspectRatio {
			// Width is limiting factor
			rect.width / boundingBox.width
		} else {
			// Height is limiting factor
			rect.height / boundingBox.height
		}
		let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

		DispatchQueue.main.safeAsync {
			self.setAffineTransform(scaleTransform)
		}
		return self
	}
}

/// A `CAShapeLayer` subclass that allows you to easily work with sublayers and get sizing information
open class SVGLayer: CAShapeLayer, SVGLayerType {
	/// The minimum CGRect that fits all subpaths
	public var boundingBox = CGRect.null
}

public extension SVGLayer {
	/// Returns a copy of the given SVGLayer
	var svgLayerCopy: SVGLayer? {
		guard let tmp = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
		else { return nil }

		let copiedLayer: SVGLayer?
		do {
			copiedLayer = try NSKeyedUnarchiver.unarchivedObject(ofClass: SVGLayer.self, from: tmp)
		} catch {
			return nil
		}

		guard let copiedLayer else { return nil }

		copiedLayer.boundingBox = boundingBox
		return copiedLayer
	}
}

// MARK: - Fill Overrides

extension SVGLayer {
	/// Applies the given fill color to all sublayers
	override open var fillColor: CGColor? {
		didSet {
			applyOnSublayers(ofType: CAShapeLayer.self) { thisShapeLayer in
				thisShapeLayer.fillColor = fillColor
			}
		}
	}
}

// MARK: - Stroke Overrides

extension SVGLayer {
	/// Applies the given line width to all `CAShapeLayer`s
	override open var lineWidth: CGFloat {
		didSet {
			applyOnSublayers(ofType: CAShapeLayer.self) { thisShapeLayer in
				thisShapeLayer.lineWidth = lineWidth
			}
		}
	}

	/// Applies the given stroke color to all `CAShapeLayer`s
	override open var strokeColor: CGColor? {
		didSet {
			applyOnSublayers(ofType: CAShapeLayer.self) { thisShapeLayer in
				thisShapeLayer.strokeColor = strokeColor
			}
		}
	}
}
