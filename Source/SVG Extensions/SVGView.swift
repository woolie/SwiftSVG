//
//  SVGView.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// A `UIView` subclass that can be used in Interface Builder where you can set the @IBInspectable propert `SVGName` in the side panel. Use the UIView extensions if you want to creates SVG views programmatically.
open class SVGView: UIView {
	/// The name of the SVG file in the main bundle
	@IBInspectable
	open var svgName: String? {
		didSet {
			guard let thisName = svgName else { return }

			#if TARGET_INTERFACE_BUILDER
			let bundle = Bundle(for: type(of: self))
			#else
			let bundle = Bundle.main
			#endif

			if let url = bundle.url(forResource: thisName, withExtension: "svg") {
				CALayer(svgURL: url) { [weak self] svgLayer in
					self?.nonOptionalLayer.addSublayer(svgLayer)
				}
			} else if #available(iOS 9.0, tvOS 9.0, OSX 10.11, *) {
				#if os(iOS) || os(tvOS)
				guard let asset = NSDataAsset(name: thisName, bundle: bundle) else { return }
				#elseif os(OSX)
				guard let asset = NSDataAsset(name: NSDataAsset.Name(thisName as NSString), bundle: bundle) else { return }
				#endif
				let data = asset.data
				CALayer(svgData: data) { [weak self] svgLayer in
					self?.nonOptionalLayer.addSublayer(svgLayer)
				}
			}
		}
	}

	/// :nodoc:
	@available(*, deprecated, renamed: "svgName")
	open var SVGName: String?
}
