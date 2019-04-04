//
//  main.swift
//  LocalizableStringsConfig
//
//  Created by Silvio Daminato on 23/11/18.
//  Copyright © 2018 2Specials SRL. All rights reserved.
//

import Foundation

let android = "android"
let ios = "ios"

if CommandLine.arguments.count < 3 {
	print("[ERROR] Unexpected number of arguments - [PLATFORM - INPUT PATH - OUTPUT PATH")
	exit(1)
}

let platform = CommandLine.arguments[1]
if platform != android && platform != ios {
    print("[ERROR] Unexpected platform \(platform) - android or ios")
    exit(1)
}

let inputPath = CommandLine.arguments[2]

var writeFilePath = platform == ios ? "LocalizationKeys.swift" : "LocalizationKeys.java"
if CommandLine.arguments.count > 3 {
	writeFilePath = CommandLine.arguments[3]
}

let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .short
dateFormatter.timeStyle = .short

var enumString = ""
if platform == ios {
    enumString =
        "//\n" +
        "//  LocalizationKeys.swift\n" +
        "//  Generated automatically by create_localizable_strings\n" +
        "//\n" +
        "//  Created by Developer on " + dateFormatter.string(from: Date()) + ".\n" +
        "//  Copyright © 2019 Intesys. All rights reserved.\n" +
        "//\n\n" +
    "enum LocalizationKeys : String {\n"
} else if platform == android {
    enumString = """
    package it.santanderconsumerbank.dealerapp.commons;\n
    import org.jetbrains.annotations.NotNull;\n
    import it.intesys.ytranslation.LocalizableItem;\n
    public enum LocalizationKeys implements LocalizableItem {\n
    """
}

do {
	let data = try String(contentsOfFile: inputPath, encoding: .utf8)
    let myStrings = data.components(separatedBy: .newlines)
    var arrayOfKeysAdded: [String] = [String]()
	for string in myStrings {
		if string.hasPrefix("\"") {
			let substrings = string.components(separatedBy: "\"")
			if substrings.count > 1 {
                var key = substrings[1]
                let splittedStrings = key.components(separatedBy: ".")
                if let last = splittedStrings.last {
                    key = last
                }
                if !arrayOfKeysAdded.contains(key) {
                    if platform == ios {
                        enumString += "\tcase \(key)\n"
                    } else if platform == android {
                        enumString += "\t\(key),\n"
                    }
                    arrayOfKeysAdded.append(key)
                }
			}
		}
	}
	
    if platform == ios {
        enumString += "}"
    } else if platform == android {
        enumString += """
        \n
        \t;
        \n
        \t@NotNull
        \t@Override
        \tpublic String getName() {
        \t\treturn this.name();
        \t}
        }
        """
    }
	
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
