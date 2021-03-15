//
//  Asset.swift
//  Jade
//
//  Created by Nindi Gill on 3/10/20.
//

import ArgumentParser
import Foundation

struct Asset: Codable {

    enum AssetType: String, Codable, CaseIterable, ExpressibleByArgument {
        case jamf = "jamf"
        case adcs = "adcs"
        case jim = "jim"
        case jpp = "jpp"
        case jpst = "jpst"
        case sccm = "sccm"
        case connect = "connect"
        case composer = "composer"
        case health = "health"
        case all = ""

        var description: String {
            self.rawValue
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
            case .health:
                return "Healthcare Listener"
            default:
                return ""
            }
        }

        var key: String {
            switch self {
            case .jamf:
                return "JAMF_PRO"
            case .adcs:
                return "AD_CS_CONNECTOR"
            case .jim:
                return "INFRASTRUCTURE_MANAGER"
            case .jpp:
                return "JAMF_PKI_PROXY"
            case .jpst:
                return "JAMF_PRO_SERVER_TOOLS"
            case .sccm:
                return "SCCM_PLUGIN"
            case .connect:
                return "CONNECT"
            case .composer:
                return "COMPOSER"
            case .health:
                return "HEALTHCARE_LISTENER"
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

        init?(type: String) {
            switch type {
            case "JAMF_PRO":
                self = .jamf
            case "AD_CS_CONNECTOR":
                self = .adcs
            case "INFRASTRUCTURE_MANAGER":
                self = .jim
            case "JAMF_PKI_PROXY":
                self = .jpp
            case "JAMF_PRO_SERVER_TOOLS":
                self = .jpst
            case "SCCM_PLUGIN":
                self = .sccm
            case "CONNECT":
                self = .connect
            case "COMPOSER":
                self = .composer
            case "HEALTHCARE_LISTENER":
                self = .health
            default:
                return nil
            }
        }
    }

    let type: AssetType
    let releases: [Release]
    var dictionary: [String: Any] {
        [
            "type": type.description,
            "releases": releases.map { $0.dictionary }
        ]
    }
}
