//
//  Dictionary+JSON.swift
//  SwiftSVG
//
//  Copyright (c) 2019 Michael Choe
//

import Foundation

extension Dictionary where Key: Decodable, Value: Decodable {
	init?(jsonFile name: String?) {
		guard let jsonPath = Bundle(for: NSXMLSVGParser.self).url(forResource: name, withExtension: "json") else {
			return nil
		}
		guard let jsonData = try? Data(contentsOf: jsonPath) else { return nil }
		guard let asDictionary = try? JSONDecoder().decode([Key: Value].self, from: jsonData) else { return nil }
		self = asDictionary
	}
}
