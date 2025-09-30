//
//  SVGPath.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/// Concrete implementation that creates a `CAShapeLayer` from a `<path>` element and its attributes
final class SVGPath: SVGShapeElement, ParsesAsynchronously, DelaysApplyingAttributes {
	/// :nodoc:
	static let elementName = "path"

	/// Attributes that are applied after the path has been processed
	var delayedAttributes = [String: String]()

	/// :nodoc:
	var asyncParseManager: CanManageAsychronousParsing?

	/// Flag that sets whether the path should be parsed asynchronously or not
	var shouldParseAsynchronously = true

	/// :nodoc:
	var supportedAttributes = [String: (String) -> Void]()

	/// :nodoc:
	var svgLayer = CAShapeLayer()

	/// :nodoc:
	init() {}

	/// Initializer to to set the `svgLayer`'s cgPath. The path string does not have to be a single path for the whole element, but can include multiple subpaths in the `d` attribute. For instance, the following is a valid path string to pass:
	/// ```
	/// <path d="M30 20 L25 15 l10 50z M40 60 l80 10 l 35 55z">
	/// ```
	/// - parameter singlePathString: The `d` attribute value of a `<path>` element
	///
	init(singlePathString: String) {
		shouldParseAsynchronously = false
		parseD(singlePathString)
	}

	/// Function that takes a `d` path string attribute and sets the `svgLayer`'s `cgPath`
	func parseD(_ pathString: String) {
		let workingString = pathString.trimWhitespace()
		assert(workingString.hasPrefix("M") || workingString.hasPrefix("m"), "Path d attribute must begin with MoveTo Command (\"M\")")
		autoreleasepool { () in
			let pathDPath = UIBezierPath()
			pathDPath.move(to: CGPoint.zero)

			let parsePathClosure = {
				var previousCommand: PreviousCommand? = nil
				for thisPathCommand in PathDLexer(pathString: workingString) {
					thisPathCommand.execute(on: pathDPath, previousCommand: previousCommand)
					previousCommand = thisPathCommand
				}
			}

			if self.shouldParseAsynchronously {
				let concurrent = DispatchQueue(label: "com.straussmade.swiftsvg.path.concurrent", attributes: .concurrent)

				concurrent.async(execute: parsePathClosure)
				concurrent.async(flags: .barrier) { [weak self] in
					guard var this = self else { return }
					this.svgLayer.path = pathDPath.cgPath
					this.applyDelayedAttributes()
					this.asyncParseManager?.finishedProcessing(this.svgLayer)
				}

			} else {
				parsePathClosure()
				self.svgLayer.path = pathDPath.cgPath
			}
		}
	}

	/// The clip rule for this path to be applied after the path has been parsed
	func clipRule(_ clipRule: String) {
		guard let thisPath = svgLayer.path else {
			delayedAttributes["clip-rule"] = clipRule
			return
		}

		guard clipRule == "evenodd" else { return }

		#if os(iOS) || os(tvOS)
		let bezierPath = UIBezierPath(cgPath: thisPath)
		bezierPath.usesEvenOddFillRule = true
		svgLayer.path = bezierPath.cgPath
		#endif
	}

	/// :nodoc:
	func didProcessElement(in container: SVGContainerElement?) {
		guard let container else { return }
        container.containerLayer.addSublayer(svgLayer)
    }
}
