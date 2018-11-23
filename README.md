# create_localizable_strings

Swift script to create an enum to use instead of `Localizable.strings` strings keys.

## Build
Open the project with Xcode and build it (⌘ + B), a binary file named `create_localizable_strings` will be created in the root folder of the project.

## Usage
Call `./create_localizable_strings` with two arguments:
1. (Required) the path of the `Localizable.strings` file to use as a source for the keys
2. (Optional) the path of the destination file

Example:

`./create_localizable_strings Boilerplate/FileSupports/en.lproj/Localizable.strings Boilerplate/Sources/Common/LocalizableStringKey.swift`
