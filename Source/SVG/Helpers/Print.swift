//
//  Print.swift
//  SwiftSVG
//
//  Copyright (c) 2019 Michael Choe
//

import Foundation

func print(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
	#if DEBUG
	Swift.print(item(), separator: separator, terminator: terminator)
	#endif
}
