//
//  Download.swift
//  JADE
//
//  Created by Nindi Gill on 4/10/20.
//

import Foundation

struct Download {

    enum Platform: String, Codable {
        case mac = "MAC"
        case linux = "LINUX"
        case windows = "WINDOWS"
        case manual = "MANUAL"
        case redhat = "REDHAT"
        case ubuntu = "UBUNTU"

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

        init?(description: String) {
            switch description.lowercased() {
            case "mac":
                self = .mac
            case "linux":
                self = .linux
            case "windows":
                self = .windows
            case "manual":
                self = .manual
            case "redhat":
                self = .redhat
            case "ubuntu":
                self = .ubuntu
            default:
                return nil
            }
        }
    }

    let platform: Platform
    let url: String
    let checksum: String
}
