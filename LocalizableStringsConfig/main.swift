//
//  main.swift
//  LocalizableStringsConfig
//
//  Created by Silvio Daminato on 23/11/18.
//  Copyright © 2018 2Specials SRL. All rights reserved.
//

import Foundation

if CommandLine.arguments.count < 2 {
	print("[ERROR] Unexpected number of arguments")
	exit(1)
}

var writeFilePath = "LocalizedString.swift"

if CommandLine.arguments.count > 2 {
	writeFilePath = CommandLine.arguments[2]
}

let path = CommandLine.arguments[1]

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .short

var enumString =
	"//\n" +
		"//  LocalizedString.swift\n" +
		"//  Generated automatically by create_localizable_strings\n" +
		"//  https://github.com/silviodaminato/LocalizableStringsConfig\n" +
		"//\n" +
		"//  Created by 2Specials on " + dateFormatter.string(from: Date()) + ".\n" +
		"//  Copyright © 2018 2Specials SRL. All rights reserved.\n" +
		"//\n\n" +
//"enum LocalizableStringKey : String {\n"

"import Foundation\n\n" +
"class LocalizedString {\n\n"

do {
	let data = try String(contentsOfFile: path, encoding: .utf8)
	let myStrings = data.components(separatedBy: .newlines)
	for string in myStrings {
		if string.hasPrefix("\"") {
			let substrings = string.components(separatedBy: "\"")
			if substrings.count > 1 {
				let value = substrings[1]
				let key = value.toCamelCase
				
//				let spacesCount = 50 - key.count
//				let spaces = String(repeating: " ", count: spacesCount > 1 ? spacesCount : 1)
//				enumString = enumString + "\tcase \(key)\(spaces)= \"\(value)\"\n"
				
				enumString = enumString + "\tpublic class var \(key): String {\n\t\treturn localize(key: \"\(value)\")\n\t}\n\n"
			}
		}
	}
	
	enumString = enumString + "\tprivate static func localize(key: String) -> String {\n" +
	"\t\treturn NSLocalizedString(key, comment:\"\")\n\t}\n\n"
	
	enumString = enumString + "}"
	
//	print(enumString)
	
	do {
		try enumString.write(toFile: writeFilePath, atomically: true, encoding: .utf8)
	} catch {
		print(error)
		exit(3)
	}
	
} catch {
	print(error)
	exit(2)
}

print(writeFilePath)
exit(0)
