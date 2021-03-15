//
//  DownloadLink.swift
//  Jade
//
//  Created by Nindi Gill on 4/10/20.
//

import ArgumentParser
import Foundation

struct DownloadLink: Codable {

    enum Platform: String, Codable, ExpressibleByArgument {
        // swiftlint:disable redundant_string_enum_value
        case mac = "mac"
        case linux = "linux"
        case windows = "windows"
        case manual = "manual"
        case redhat = "redhat"
        case ubuntu = "ubuntu"

        var description: String {
            self.rawValue
        }

        var friendlyDescription: String {
            switch self {
            case .mac:
                return "Mac"
            case .linux:
                return "Linux"
            case .windows:
                return "Windows"
            case .manual:
                return "Manual"
            case .redhat:
                return "RedHat"
            case .ubuntu:
                return "Ubuntu"
            }
        }

        var key: String {
            switch self {
            case .mac:
                return "MAC"
            case .linux:
                return "LINUX"
            case .windows:
                return "WINDOWS"
            case .manual:
                return "MANUAL"
            case .redhat:
                return "REDHAT"
            case .ubuntu:
                return "UBUNTU"
            }
        }

        init?(platform: String) {
            switch platform {
            case "MAC":
                self = .mac
            case "LINUX":
                self = .linux
            case "WINDOWS":
                self = .windows
            case "MANUAL":
                self = .manual
            case "REDHAT":
                self = .redhat
            case "UBUNTU":
                self = .ubuntu
            default:
                return nil
            }
        }
    }

    let platform: Platform
    let url: String
    let checksum: String
    var dictionary: [String: Any] {
        [
            "platform": platform.description,
            "url": url,
            "checksum": checksum
        ]
    }
}
