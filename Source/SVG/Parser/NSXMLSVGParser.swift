//
//  NSXMLSVGParser.swift
//  SwiftSVG
//
//  Copyright (c) 2017 Michael Choe
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

/// `NSXMLSVGParser` conforms to `SVGParser`
extension NSXMLSVGParser: SVGParser {}

/// Concrete implementation of `SVGParser` that uses Foundation's `XMLParser` to parse a given SVG file.
open class NSXMLSVGParser: XMLParser, XMLParserDelegate {
	/// Error type used when a fatal error has occured
	enum SVGParserError {
		case invalidSVG
		case invalidURL
	}

	/// :nodoc:
	fileprivate var asyncParseCount: Int = 0

	/// :nodoc:
	fileprivate var didDispatchAllElements = true

	/// :nodoc:
	fileprivate var elementStack = Stack<SVGElement>()

	/// :nodoc:
	public var completionBlock: ((SVGLayer) -> Void)?

	/// :nodoc:
	public var supportedElements: SVGParserSupportedElements?

	/// The `SVGLayer` that will contain all of the SVG's sublayers
	open var containerLayer = SVGLayer()

	/// :nodoc:
	let asyncCountQueue = DispatchQueue(label: "com.straussmade.swiftsvg.asyncCountQueue.serial", qos: .userInteractive)

	/// :nodoc:
	private init() {
		super.init(data: Data())
	}

	///
	/// Convenience initializer that can initalize an `NSXMLSVGParser` using a local or remote `URL`
	/// - parameter svgURL: The URL of the SVG.
	/// - parameter supportedElements: Optional `SVGParserSupportedElements` struct that restrict the elements and attributes that this parser can parse.If no value is provided, all supported attributes will be used.
	/// - parameter completion: Optional completion block that will be executed after all elements and attribites have been parsed.
	///
	public convenience init(svgURL: URL, supportedElements: SVGParserSupportedElements? = nil, completion: ((SVGLayer) -> Void)? = nil) {
		do {
			let urlData = try Data(contentsOf: svgURL)
			self.init(svgData: urlData, supportedElements: supportedElements, completion: completion)
		} catch {
			self.init()
			print("Couldn't get data from URL")
		}
	}

	/// :nodoc:
	@available(*, deprecated, renamed: "init(svgURL:supportedElements:completion:)")
	public convenience init(SVGURL: URL, supportedElements: SVGParserSupportedElements? = nil, completion: ((SVGLayer) -> Void)? = nil) {
		self.init(svgURL: SVGURL, supportedElements: supportedElements, completion: completion)
	}

	///
	/// Initializer that can initalize an `NSXMLSVGParser` using SVG `Data`
	/// - parameter svgURL: The URL of the SVG.
	/// - parameter supportedElements: Optional `SVGParserSupportedElements` struct that restricts the elements and attributes that this parser can parse. If no value is provided, all supported attributes will be used.
	/// - parameter completion: Optional completion block that will be executed after all elements and attribites have been parsed.
	///
	public required init(svgData: Data, supportedElements: SVGParserSupportedElements? = SVGParserSupportedElements.allSupportedElements, completion: ((SVGLayer) -> Void)? = nil) {
		super.init(data: svgData)
		delegate = self
		self.supportedElements = supportedElements
		completionBlock = completion
	}

	/// :nodoc:
	@available(*, deprecated, renamed: "init(svgData:supportedElements:completion:)")
	public convenience init(SVGData: Data, supportedElements: SVGParserSupportedElements? = SVGParserSupportedElements.allSupportedElements, completion: ((SVGLayer) -> Void)? = nil) {
		self.init(svgData: SVGData, supportedElements: supportedElements, completion: completion)
	}

	/// Starts parsing the SVG document
	public func startParsing() {
		asyncCountQueue.sync {
			self.didDispatchAllElements = false
		}
		parse()
	}

	/// The `XMLParserDelegate` method called when the parser has started parsing an SVG element. This implementation will loop through all supported attributes and dispatch the attribiute value to the given curried function.
	open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
		guard let elementType = supportedElements?.tags[elementName] else {
			print("\(elementName) is unsupported. For a complete list of supported elements, see the `allSupportedElements` variable in the `SVGParserSupportedElements` struct. Click through on the `elementName` variable name to see the SVG tag name.")
			return
		}

		let svgElement = elementType()

		if var asyncElement = svgElement as? ParsesAsynchronously {
			asyncCountQueue.sync {
				self.asyncParseCount += 1
				asyncElement.asyncParseManager = self
			}
		}

		for (attributeName, attributeClosure) in svgElement.supportedAttributes {
			if let attributeValue = attributeDict[attributeName] {
				attributeClosure(attributeValue)
			}
		}

		elementStack.push(svgElement)
	}

	///
	/// The `XMLParserDelegate` method called when the parser has ended parsing an SVG element. This methods pops the last element parsed off the stack and checks if there is an enclosing container layer. Every valid SVG file is guaranteed to have at least one container layer (at a minimum, a `SVGRootElement` instance).
	///
	/// If the parser has finished parsing a `SVGShapeElement`, it will resize the parser's `containerLayer` bounding box to fit all subpaths
	///
	/// If the parser has finished parsing a `<svg>` element, that `SVGRootElement`'s container layer is added to this parser's `containerLayer`.
	///
	open func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		guard let last = elementStack.last else { return }
		guard elementName == type(of: last).elementName else { return }
		guard let lastElement = elementStack.pop() else { return }

		if let rootItem = lastElement as? SVGRootElement {
			DispatchQueue.main.safeAsync {
				self.containerLayer.addSublayer(rootItem.containerLayer)
			}
			return
		}

		guard let containerElement = elementStack.last as? SVGContainerElement else { return }

		lastElement.didProcessElement(in: containerElement)

		if let lastShapeElement = lastElement as? SVGShapeElement {
			resizeContainerBoundingBox(lastShapeElement.boundingBox)
		}
	}

	///
	/// The `XMLParserDelegate` method called when the parser has finished parsing the SVG document. All supported elements and attributes are guaranteed to be dispatched at this point, but there's no guarantee that all elements have finished parsing.
	///
	/// - SeeAlso: `CanManageAsychronousParsing` `finishedProcessing(shapeLayer:)`
	/// - SeeAlso: `XMLParserDelegate` (`parserDidEndDocument(_:)`)[https://developer.apple.com/documentation/foundation/xmlparserdelegate/1418172-parserdidenddocument]
	///
	public func parserDidEndDocument(_ parser: XMLParser) {
		asyncCountQueue.sync {
			self.didDispatchAllElements = true
		}
		if asyncParseCount <= 0 {
			DispatchQueue.main.safeAsync {
				self.completionBlock?(self.containerLayer)
				self.completionBlock = nil
			}
		}
	}

	///
	/// The `XMLParserDelegate` method called when the parser has reached a fatal error in parsing. Parsing is stopped if an error is reached and you may want to check that your SVG file passes validation.
	/// - SeeAlso: `XMLParserDelegate` (`parser(_:parseErrorOccurred:)`)[https://developer.apple.com/documentation/foundation/xmlparserdelegate/1412379-parser]
	/// - SeeAlso: (SVG Validator)[https://validator.w3.org/]
	///
	public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
		print("Parse Error: \(parseError)")
		let code = (parseError as NSError).code
		switch code {
		case 76:
			print("Invalid XML: \(SVGParserError.invalidSVG)")
		default:
			break
		}
	}
}

extension NSXMLSVGParser {
	/// Method that resizes the container bounding box that fits all the subpaths.
	func resizeContainerBoundingBox(_ boundingBox: CGRect?) {
		guard let thisBoundingBox = boundingBox else { return }
		containerLayer.boundingBox = containerLayer.boundingBox.union(thisBoundingBox)
	}
}

/// `NSXMLSVGParser` conforms to the protocol `CanManageAsychronousParsing` that uses a simple reference count to see if there are any pending asynchronous tasks that have been dispatched and are still being processed. Once the element has finished processing, the asynchronous elements calls the delegate callback `func finishedProcessing(shapeLayer:)` and the delegate will decrement the count.
extension NSXMLSVGParser: CanManageAsychronousParsing {
	/// The `CanManageAsychronousParsing` callback called when an `ParsesAsynchronously` element has finished parsing
	func finishedProcessing(_ shapeLayer: CAShapeLayer) {
		asyncCountQueue.sync {
			self.asyncParseCount -= 1
		}

		resizeContainerBoundingBox(shapeLayer.path?.boundingBox)

		guard asyncParseCount <= 0, didDispatchAllElements else { return }
		DispatchQueue.main.safeAsync {
			self.completionBlock?(self.containerLayer)
			self.completionBlock = nil
		}
	}
}
