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
    static let appVersion: String = "1.1"
    static var identifier: String { "com.ninxsoft.\(appName)" }
    static let cookieName: String = "JSESSIONID"
    static let loginURL: String = "https://www.jamf.com/jamf-nation/api/v1/session/login"
    static let help: String = """
    \(String.appName) - Jamf Asset Downloader Extreme

    Usage: \(String.appName) [-h] | [-v] | [-c] | [-l] | [-d] [-t] [-r] [-p] [-o]

    Options:
    \t-h, --help\t\tDisplay help / this usage message
    \t-v, --version\t\tDisplay the version of \(String.appName)
    \t-c, --credentials\tInteractively add / update username
    \t\t\t\tand password credentials to keychain
    \t-l, --list\t\tList all assets available to download
    \t-d, --download\t\tDownload an asset from Jamf Nation

    Download Options:
    \t-t, --type\t\tDownload types (depending on availability):
    \t\t\t\tjamf (Jamf Pro Installer)
    \t\t\t\tadcs (Jamf AD CS Connector)
    \t\t\t\tjim (Jamf Infrastructure Manager)
    \t\t\t\tjpp (Jamf PKI Proxy)
    \t\t\t\tjpst (Jamf Pro Server Tools)
    \t\t\t\tsccm (Jamf SCCM Plugin)
    \t\t\t\tconnect (Jamf Connect)
    \t\t\t\tcomposer (Composer)
    \t\t\t\thealth (Healthcare Listener)
    \t\t\t\tDefault: jamf

    \t-r, --release\t\tRelease version
    \t\t\t\tDefault: latest

    \t-p, --platform\t\tDownload platforms (depending on availability):
    \t\t\t\tmac (Mac binaries and DMGs)
    \t\t\t\twindows (Windows binaries and MSIs)
    \t\t\t\tlinux (Linux binaries and .run files)
    \t\t\t\tmanual (Manual archives)
    \t\t\t\tredhat (RedHat RPM installers)
    \t\t\t\tubuntu (Ubuntu DEB installers)
    \t\t\t\tDefault: mac

    \t-o, --output\t\tOutput directory
    \t\t\t\tDefault: ~/Downloads/

    """

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
