//
//  Jade.swift
//  JADE
//
//  Created by Nindi Gill on 9/10/20.
//

import ArgumentParser
import Foundation

struct RuntimeError: Error, CustomStringConvertible {
    var description: String

    init(_ description: String) {
        self.description = description
    }
}

struct Jade: ParsableCommand {
    static let configuration: CommandConfiguration = CommandConfiguration(abstract: String.abstract, discussion: String.discussion)

    @Flag(name: .shortAndLong, help: """
    Interactively add / update username
    and password credentials to keychain.
    """)
    var credentials: Bool = false

    @Flag(name: .shortAndLong, help: """
    List all assets available to download.
    """)
    var list: Bool = false

    @Flag(name: .shortAndLong, help: """
    Download an asset from Jamf Nation.
    """)
    var download: Bool = false

    @Option(name: .shortAndLong, help: """
    Download types (depending on availability):
    jamf (Jamf Pro Installer)
    adcs (Jamf AD CS Connector)
    jim (Jamf Infrastructure Manager)
    jpp (Jamf PKI Proxy)
    jpst (Jamf Pro Server Tools)
    sccm (Jamf SCCM Plugin)
    connect (Jamf Connect)
    composer (Composer)
    health (Healthcare Listener)
    """)
    var type: Asset.AssetType = .jamf

    @Option(name: .shortAndLong, help: """
    Release version
    """)
    var release: String = "latest"

    @Option(name: .shortAndLong, help: """
    Download platforms (depending on availability):
    mac (Mac binaries and DMGs)
    windows (Windows binaries and MSIs)
    linux (Linux binaries and .run files)
    manual (Manual archives)
    redhat (RedHat RPM installers)
    ubuntu (Ubuntu DEB installers)
    """)
    var platform: DownloadLink.Platform  = .mac

    @Option(name: .shortAndLong, help: """
    Output directory
    """)
    var output: String = NSHomeDirectory() + "/Downloads/"

    @Flag(name: .shortAndLong, help: "Display the version of jade.")
    var version: Bool = false

    mutating func run() throws {

        if credentials {
            Credentials.run()
        } else if list {
            List.run()
        } else if download {
            Download.run(type: type, releaseVersion: release, platform: platform, output: output)
        } else if version {
            Version.run()
        }
    }
}
