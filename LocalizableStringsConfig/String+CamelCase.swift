//
//  String+CamelCase.swift
//  LocalizableStringsConfig
//
//  Created by Silvio Daminato on 29/01/19.
//  Copyright © 2019 2Specials SRL. All rights reserved.
//

import Foundation

fileprivate let badChars = CharacterSet.alphanumerics.inverted

extension String {
	var uppercasingFirst: String {
		return prefix(1).uppercased() + dropFirst()
	}
	
	var lowercasingFirst: String {
		return prefix(1).lowercased() + dropFirst()
	}
	
	var toCamelCase: String {
		guard !isEmpty else {
			return ""
		}
		
		let parts = self.components(separatedBy: badChars)
		
		let first = String(describing: parts.first!).lowercasingFirst
		let rest = parts.dropFirst().map({String($0).uppercasingFirst})
		
		return ([first] + rest).joined(separator: "")
	}
}
