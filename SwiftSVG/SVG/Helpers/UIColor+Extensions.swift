//
//  UIColor+Extensions.swift
//  SwiftSVG
//
//
//  Copyright (c) 2017 Michael Choe
//  http://www.github.com/mchoe
//  http://www.straussmade.com/
//  http://www.twitter.com/_mchoe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

/**
 A struct that represents named colors as listed [here](https://www.w3.org/TR/SVGColor12/#icccolor)
 */
struct NamedColors {
    /// Dictionary of named colors
    private let fromLiterals: [String: CGColor] = {
		let colorDictionary = [
			"aliceblue": "#f0f8ff",
			"antiquewhite": "#faebd7",
			"aqua": "#00ffff",
			"aquamarine": "#7fffd4",
			"azure": "#f0ffff",
			"beige": "#f5f5dc",
			"bisque": "#ffe4c4",
			"black": "#000000",
			"blanchedalmond": "#ffebcd",
			"blue": "#0000ff",
			"blueviolet": "#8a2be2",
			"brown": "#a52a2a",
			"burlywood": "#deb887",
			"cadetblue": "#5f9ea0",
			"chartreuse": "#7fff00",
			"chocolate": "#d2691e",
			"coral": "#ff7f50",
			"cornflowerblue": "#6495ed",
			"cornsilk": "#fff8dc",
			"crimson": "#dc143c",
			"cyan": "#00ffff",
			"darkblue": "#00008b",
			"darkcyan": "#008b8b",
			"darkgoldenrod": "#b8860b",
			"darkgray": "#a9a9a9",
			"darkgreen": "#006400",
			"darkgrey": "#a9a9a9",
			"darkkhaki": "#bdb76b",
			"darkmagenta": "#8b008b",
			"darkolivegreen": "#556b2f",
			"darkorange": "#ff8c00",
			"darkorchid": "#9932cc",
			"darkred": "#8b0000",
			"darksalmon": "#e9967a",
			"darkseagreen": "#8fbc8f",
			"darkslateblue": "#483d8b",
			"darkslategray": "#2f4f4f",
			"darkslategrey": "#2f4f4f",
			"darkturquoise": "#00ced1",
			"darkviolet": "#9400d3",
			"deeppink": "#ff1493",
			"deepskyblue": "#00bfff",
			"dimgray": "#696969",
			"dimgrey": "#696969",
			"dodgerblue": "#1e90ff",
			"firebrick": "#b22222",
			"floralwhite": "#fffaf0",
			"forestgreen": "#228b22",
			"fuchsia": "#ff00ff",
			"gainsboro": "#dcdcdc",
			"ghostwhite": "#f8f8ff",
			"goldenrod": "#daa520",
			"gold": "#ffd700",
			"gray": "#808080",
			"green": "#008000",
			"greenyellow": "#adff2f",
			"grey": "#808080",
			"honeydew": "#f0fff0",
			"hotpink": "#ff69b4",
			"indianred": "#cd5c5c",
			"indigo": "#4b0082",
			"ivory": "#fffff0",
			"khaki": "#f0e68c",
			"lavenderblush": "#fff0f5",
			"lavender": "#e6e6fa",
			"lawngreen": "#7cfc00",
			"lemonchiffon": "#fffacd",
			"lightblue": "#add8e6",
			"lightcoral": "#f08080",
			"lightcyan": "#e0ffff",
			"lightgoldenrodyellow": "#fafad2",
			"lightgray": "#d3d3d3",
			"lightgreen": "#90ee90",
			"lightgrey": "#d3d3d3",
			"lightpink": "#ffb6c1",
			"lightsalmon": "#ffa07a",
			"lightseagreen": "#20b2aa",
			"lightskyblue": "#87cefa",
			"lightslategray": "#778899",
			"lightslategrey": "#778899",
			"lightsteelblue": "#b0c4de",
			"lightyellow": "#ffffe0",
			"lime": "#00ff00",
			"limegreen": "#32cd32",
			"linen": "#faf0e6",
			"magenta": "#ff00ff",
			"maroon": "#800000",
			"mediumaquamarine": "#66cdaa",
			"mediumblue": "#0000cd",
			"mediumorchid": "#ba55d3",
			"mediumpurple": "#9370db",
			"mediumseagreen": "#3cb371",
			"mediumslateblue": "#7b68ee",
			"mediumspringgreen": "#00fa9a",
			"mediumturquoise": "#48d1cc",
			"mediumvioletred": "#c71585",
			"midnightblue": "#191970",
			"mintcream": "#f5fffa",
			"mistyrose": "#ffe4e1",
			"moccasin": "#ffe4b5",
			"navajowhite": "#ffdead",
			"navy": "#000080",
			"none": "#00000000",
			"oldlace": "#fdf5e6",
			"olive": "#808000",
			"olivedrab": "#6b8e23",
			"orange": "#ffa500",
			"orangered": "#ff4500",
			"orchid": "#da70d6",
			"palegoldenrod": "#eee8aa",
			"palegreen": "#98fb98",
			"paleturquoise": "#afeeee",
			"palevioletred": "#db7093",
			"papayawhip": "#ffefd5",
			"peachpuff": "#ffdab9",
			"peru": "#cd853f",
			"pink": "#ffc0cb",
			"plum": "#dda0dd",
			"powderblue": "#b0e0e6",
			"purple": "#800080",
			"rebeccapurple": "#663399",
			"red": "#ff0000",
			"rosybrown": "#bc8f8f",
			"royalblue": "#4169e1",
			"saddlebrown": "#8b4513",
			"salmon": "#fa8072",
			"sandybrown": "#f4a460",
			"seagreen": "#2e8b57",
			"seashell": "#fff5ee",
			"sienna": "#a0522d",
			"silver": "#c0c0c0",
			"skyblue": "#87ceeb",
			"slateblue": "#6a5acd",
			"slategray": "#708090",
			"slategrey": "#708090",
			"snow": "#fffafa",
			"springgreen": "#00ff7f",
			"steelblue": "#4682b4",
			"tan": "#d2b48c",
			"teal": "#008080",
			"thistle": "#d8bfd8",
			"tomato": "#ff6347",
			"transparent": "00000000",
			"turquoise": "#40e0d0",
			"violet": "#ee82ee",
			"wheat": "#f5deb3",
			"white": "#ffffff",
			"whitesmoke": "#f5f5f5",
			"yellow": "#ffff00",
			"yellowgreen": "#9acd32"]
        return colorDictionary
            .compactMapValues { hexString -> CGColor? in
                guard let asColor = UIColor(hexString: hexString)?.cgColor else {
                    return nil
                }
                return asColor
            }
    }()

    /// Subscript to access the named color. Must be one of the officially supported values listed [here](https://www.w3.org/TR/SVGColor12/#icccolor)
    subscript(index: String) -> CGColor? {
		fromLiterals[index]
    }
}

fileprivate extension CGColor {
    /**
     Lazily loaded instance of `NamedColors`
     */
    static var named: NamedColors = .init()
}

public extension UIColor {
    /**
     Convenience initializer that creates a new UIColor based on a 3 or 6 digit hex string, integer functional, or named string.
     - Parameter svgString: A hex, integer functional, or named string
     - SeeAlso: See officially supported color formats: [https://www.w3.org/TR/SVGColor12/#sRGBcolor](https://www.w3.org/TR/SVGColor12/#sRGBcolor)
     */
    internal convenience init?(svgString: String) {
        if svgString.hasPrefix("#") {
            self.init(hexString: svgString)
            return
        }

        if svgString.hasPrefix("rgb") {
            self.init(rgbString: svgString)
            return
        }

        if svgString.hasPrefix("rgba") {
            self.init(rgbaString: svgString)
            return
        }

        self.init(cssName: svgString)
    }

    /**
     Convenience initializer that creates a new UIColor based on a 3, 4, 6, or 8 digit hex string. The leading `#` character is optional
     - Parameter hexString: A 3, 4, 6, or 8 digit hex string
     */
    internal convenience init?(hexString: String) {
        var workingString = hexString
        if workingString.hasPrefix("#") {
            workingString = String(workingString.dropFirst())
        }
        workingString = workingString.lowercased()
        let colorArray: [CGFloat]

        if workingString.count == 3 {
            guard let asInt = UInt16(workingString, radix: 16) else {
                return nil
            }
            let red = CGFloat((asInt & 0xF00) >> 8) / 15
            let green = CGFloat((asInt & 0x0F0) >> 4) / 15
            let blue = CGFloat(asInt & 0x00F) / 15
            colorArray = [red, green, blue, 1.0]
        } else if workingString.count == 4 {
            guard let asInt = UInt16(workingString, radix: 16) else {
                return nil
            }
            let red = CGFloat((asInt & 0xF000) >> 12) / 15
            let green = CGFloat((asInt & 0x0F00) >>  8) / 15
            let blue = CGFloat((asInt & 0x00F0) >>  4) / 15
            let alpha = CGFloat(asInt & 0x000F) / 15
            colorArray = [red, green, blue, alpha]
        } else if workingString.count == 6 {
            guard let asInt = UInt32(workingString, radix: 16) else {
                return nil
            }
            let red = CGFloat((asInt & 0xFF0000) >> 16) / 255
            let green = CGFloat((asInt & 0x00FF00) >> 8) / 255
            let blue = CGFloat(asInt & 0x0000FF) / 255
            colorArray = [red, green, blue, 1.0]
        } else if workingString.count == 8 {
            guard let asInt = UInt32(workingString, radix: 16) else {
                return nil
            }
            let red = CGFloat((asInt & 0xFF00_0000) >> 24) / 255
            let green = CGFloat((asInt & 0x00FF_0000) >> 16) / 255
            let blue = CGFloat((asInt & 0x0000_FF00) >> 8) / 255
            let alpha = CGFloat(asInt & 0x0000_00FF) / 255
            colorArray = [red, green, blue, alpha]
        } else {
            return nil
        }
        guard colorArray.count == 4 else {
            return nil
        }
        self.init(red: colorArray[0], green: colorArray[1], blue: colorArray[2], alpha: colorArray[3])
    }

    /**
     Convenience initializer that creates a new UIColor from a integer functional, taking the form `rgb(rrr, ggg, bbb)`
     */
    internal convenience init(rgbString: String) {
        let valuesString = rgbString.dropFirst(4).dropLast()
        self.init(colorValuesString: valuesString)
    }

    /**
     Convenience initializer that creates a new UIColor from an integer functional, taking the form `rgba(rrr, ggg, bbb, <alphavalue>)`
     */
    internal convenience init(rgbaString: String) {
        let valuesString = rgbaString.dropFirst(5).dropLast()
        self.init(colorValuesString: valuesString)
    }

    /// :nodoc:
    private convenience init(colorValuesString: Substring) {
        let colorsArray = colorValuesString
            .split(separator: ",")
            .map { numberString -> CGFloat in
                return CGFloat(String(numberString).trimmingCharacters(in: CharacterSet.whitespaces))!
            }
        self.init(red: colorsArray[0] / 255.0, green: colorsArray[1] / 255.0, blue: colorsArray[2] / 255.0, alpha: colorsArray.count > 3 ? colorsArray[3] / 1.0 : 1.0)
    }

    /**
     Convenience initializer that creates a new UIColor from a CSS3 named color
     - SeeAlso: See here for all the colors: [https://www.w3.org/TR/css3-color/#svg-color](https://www.w3.org/TR/css3-color/#svg-color)
     */
	convenience init?(cssName: String) {
        guard let namedColor = CGColor.named[cssName.lowercased()] else {
            return nil
        }
        self.init(cgColor: namedColor)
    }
}

