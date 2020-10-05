//
//  Asset.swift
//  JADE
//
//  Created by Nindi Gill on 3/10/20.
//

import Foundation

struct Asset {

    enum AssetType: String, CaseIterable {
        case jamf = "JAMF_PRO"
        case adcs = "AD_CS_CONNECTOR"
        case jim = "INFRASTRUCTURE_MANAGER"
        case jpp = "JAMF_PKI_PROXY"
        case jpst = "JAMF_PRO_SERVER_TOOLS"
        case sccm = "SCCM_PLUGIN"
        case connect = "CONNECT"
        case composer = "COMPOSER"
        case all = "ALL"

        var description: String {
            switch self {
            case .jamf:
                return "jamf"
            case .adcs:
                return "adcs"
            case .jim:
                return "jim"
            case .jpp:
                return "jpp"
            case .jpst:
                return "jpst"
            case .sccm:
                return "sccm"
            case .connect:
                return "connect"
            case .composer:
                return "composer"
            default:
                return ""
            }
        }

        var friendlyDescription: String {
            switch self {
            case .jamf:
                return "Jamf Pro Installer"
            case .adcs:
                return "Jamf AD CS Connector"
            case .jim:
                return "Jamf Infrastructure Manager"
            case .jpp:
                return "Jamf PKI Proxy"
            case .jpst:
                return "Jamf Pro Server Tools"
            case .sccm:
                return "Jamf SCCM Plugin"
            case .connect:
                return "Jamf Connect"
            case .composer:
                return "Composer"
            default:
                return ""
            }
        }

        var url: String? {
            switch self {
            case .jamf:
                return "https://www.jamf.com/jamf-nation/api/v1/release-versions/products/jamf-pro"
            case .jpp:
                return "https://www.jamf.com/jamf-nation/api/v1/release-versions/products/jamf-pki-proxy"
            case .jpst:
                return "https://www.jamf.com/jamf-nation/api/v1/release-versions/products/jamf-pro-server-tools"
            case .connect:
                return "https://www.jamf.com/jamf-nation/api/v1/release-versions/products/connect"
            case .all:
                return "https://www.jamf.com/jamf-nation/api/v1/assets"
            default:
                return nil
            }
        }

        init?(description: String) {
            switch description.lowercased() {
            case "jamf":
                self = .jamf
            case "adcs":
                self = .adcs
            case "jim":
                self = .jim
            case "jpp":
                self = .jpp
            case "jpst":
                self = .jpst
            case "sccm":
                self = .sccm
            case "connect":
                self = .connect
            case "composer":
                self = .composer
            default:
                return nil
            }
        }

        static var maxDescriptionLength: Int {

            var max: Int = 0

            for type in AssetType.allCases where type.description.count > max {
                max = type.description.count
            }

            return max
        }

        static var maxFriendlyDescriptionLength: Int {

            var max: Int = 0

            for type in AssetType.allCases where type.friendlyDescription.count > max {
                max = type.friendlyDescription.count
            }

            return max
        }
    }

    let type: AssetType
    let releases: [Release]
    var maxVersionLength: Int {
        var max: Int = 0

        for release in releases where release.version.count > max {
            max = release.version.count
        }

        return max
    }
    var maxPlatformsLength: Int {
        var max: Int = 0

        for release in releases where release.platforms.count > max {
            max = release.platforms.count
        }

        return max
    }
}
