//
//  String+Extension.swift
//  JADE
//
//  Created by Nindi Gill on 3/10/20.
//

import Foundation

extension String {

    enum Color: String, CaseIterable {
        case black = "\u{001B}[0;30m"
        case red = "\u{001B}[0;31m"
        case green = "\u{001B}[0;32m"
        case yellow = "\u{001B}[0;33m"
        case blue = "\u{001B}[0;34m"
        case magenta = "\u{001B}[0;35m"
        case cyan = "\u{001B}[0;36m"
        case white = "\u{001B}[0;37m"
        case brightBlack = "\u{001B}[0;90m"
        case brightRed = "\u{001B}[0;91m"
        case brightGreen = "\u{001B}[0;92m"
        case brightYellow = "\u{001B}[0;93m"
        case brightBlue = "\u{001B}[0;94m"
        case brightMagenta = "\u{001B}[0;95m"
        case brightCyan = "\u{001B}[0;96m"
        case brightWhite = "\u{001B}[0;97m"
        case reset = "\u{001B}[0;0m"
    }

    static let appName: String = "jade"
    static let appVersion: String = "1.0"
    static var identifier: String { "com.ninxsoft.\(appName)" }
    static let cookieName: String = "JSESSIONID"
    static let loginURL: String = "https://www.jamf.com/jamf-nation/api/v1/session/login"

    func color(_ color: Color, bold: Bool = false) -> String {
        color.rawValue.replacingOccurrences(of: "0;", with: bold ? "1;" : "0;") + self + Color.reset.rawValue
    }

    func filename() -> String {

        var string: String = self

        if let range: Range = string.range(of: "?") {
            string.removeSubrange(range.lowerBound..<string.endIndex)
        }

        if let index: String.Index = string.lastIndex(of: "/") {
            string.removeSubrange(string.startIndex...index)
        }

        return string
    }
}
