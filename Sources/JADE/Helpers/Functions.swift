//
//  Functions.swift
//  JADE
//
//  Created by Nindi Gill on 4/10/20.
//

import Foundation

class Functions {

    static func help() {
        let string: String = """
        \(String.appName) - Jamf Asset Downloader Extreme

        Usage: \(String.appName) [-h] | [-v] | [-c] | [-l] | [-d] [-t] [-r] [-p] [-o]

        Options:
          -h, --help\t\tDisplay help / this usage message
          -v, --version\t\tDisplay the version of \(String.appName)
          -c, --credentials\tInteractively add / update username
          \t\t\tand password credentials to keychain
          -l, --list\t\tList all assets available to download
          -d, --download\tDownload an asset from Jamf Nation

        Download Options:
          -t, --type\t\tDownload types (depending on availability):
          \t\t\tjamf (Jamf Pro Installer)
          \t\t\tadcs (Jamf AD CS Connector)
          \t\t\tjim (Jamf Infrastructure Manager)
          \t\t\tjpp (Jamf PKI Proxy)
          \t\t\tjpst (Jamf Pro Server Tools)
          \t\t\tsccm (Jamf SCCM Plugin)
          \t\t\tconnect (Jamf Connect)
          \t\t\tcomposer (Composer)
          \t\t\thealth (Healthcare Listener)
          \t\t\tDefault: jamf

          -r, --release\t\tRelease version
          \t\t\tDefault: latest

          -p, --platform\tDownload platforms (depending on availability):
          \t\t\tmac (Mac binaries and DMGs)
          \t\t\twindows (Windows binaries and MSIs)
          \t\t\tlinux (Linux binaries and .run files)
          \t\t\tmanual (Manual archives)
          \t\t\tredhat (RedHat RPM installers)
          \t\t\tubuntu (Ubuntu DEB installers)
          \t\t\tDefault: mac

          -o, --output\t\tOutput directory
          \t\t\tDefault: ~/Downloads/

        """
        print(string)
    }

    static func version() {
        print("\(String.appName) \(String.appVersion)")
    }

    static func credentials() {

        var username: String = ""
        var password: String = ""

        while username.isEmpty {

            print("Enter your Jamf Nation Email Address or Username: ", terminator: "")

            guard let string: String = readLine(strippingNewline: true) else {
                print("\nERROR: There was an error entering your Email Address or Username")
                exit(1)
            }

            username = string
        }

        print("")

        while password.isEmpty {

            guard let string: UnsafeMutablePointer<Int8> = getpass("Enter your Jamf Nation Password: ") else {
                print("\nERROR: There was an error entering your Password")
                exit(1)
            }

            password = String(cString: string)
        }

        guard Credentials.update(username: username, password: password) else {
            print("\nERROR: There was an error updating credentials in keychain")
            exit(1)
        }

        print("\nVerifying credentials...")

        guard let _: String = HTTP.sessionID() else {
            print("\nERROR: There was an error connecting to Jamf Nation")
            exit(1)
        }

        print("\nSuccessfully updated credentials in keychain")
    }

    static func list() {

        guard let assets: [Asset] = assets() else {
            exit(1)
        }

        let border: String.Color = .cyan
        let heading: String.Color = .white
        let pipe: String = "│".color(border)
        let type: String = "Type".padding(toLength: Asset.AssetType.maxDescriptionLength, withPad: " ", startingAt: 0).color(heading, bold: true)
        let typeBorder: String = "".padding(toLength: Asset.AssetType.maxDescriptionLength + 2, withPad: "─", startingAt: 0)
        let description: String = "Description".padding(toLength: Asset.AssetType.maxFriendlyDescriptionLength, withPad: " ", startingAt: 0).color(heading, bold: true)
        let descriptionBorder: String = "".padding(toLength: Asset.AssetType.maxFriendlyDescriptionLength + 2, withPad: "─", startingAt: 0)
        let versionLength: Int = maxVersionLength(for: assets)
        let version: String = "Versions".padding(toLength: versionLength, withPad: " ", startingAt: 0).color(heading, bold: true)
        let versionBorder: String = "".padding(toLength: versionLength + 2, withPad: "─", startingAt: 0)
        let platformsLength: Int = maxPlatformsLength(for: assets)
        let platforms: String = "Platform(s)".padding(toLength: platformsLength, withPad: " ", startingAt: 0).color(heading, bold: true)
        let platformsBorder: String = "".padding(toLength: platformsLength + 2, withPad: "─", startingAt: 0)

        print("\nThe following assets are available to download:\n")
        print("╭\(typeBorder)┬\(descriptionBorder)┬\(versionBorder)┬\(platformsBorder)╮".color(border))
        print(pipe + " \(type) " + pipe + " \(description) " + pipe + " \(version) " + pipe + " \(platforms) " + pipe)
        print("├\(typeBorder)┼\(descriptionBorder)┼\(versionBorder)┼\(platformsBorder)┤".color(border))

        for (index, asset) in assets.enumerated() {
            let type: String = asset.type.description.padding(toLength: Asset.AssetType.maxDescriptionLength, withPad: " ", startingAt: 0)
            let description: String = asset.type.friendlyDescription.padding(toLength: Asset.AssetType.maxFriendlyDescriptionLength, withPad: " ", startingAt: 0)

            if let release: Release = asset.releases.first {
                let version: String = release.version.padding(toLength: versionLength, withPad: " ", startingAt: 0)
                let platforms: String = release.platforms.padding(toLength: platformsLength, withPad: " ", startingAt: 0)
                print(pipe + " \(type) " + pipe + " \(description) " + pipe + " \(version) " + pipe + " \(platforms) " + pipe)

                if asset.releases.count > 1 {
                    let releases: [Release] = Array(asset.releases[1...])

                    for release in releases {
                        let version: String = release.version.padding(toLength: versionLength, withPad: " ", startingAt: 0)
                        let platforms: String = release.platforms.padding(toLength: platformsLength, withPad: " ", startingAt: 0)
                        print(pipe + "".padding(toLength: Asset.AssetType.maxDescriptionLength + 2, withPad: " ", startingAt: 0) +
                            pipe + "".padding(toLength: Asset.AssetType.maxFriendlyDescriptionLength + 2, withPad: " ", startingAt: 0) +
                            pipe + " \(version) " +
                            pipe + " \(platforms) " +
                            pipe)
                    }
                }
            }

            if index < assets.count - 1 {
                print("├\(typeBorder)┼\(descriptionBorder)┼\(versionBorder)┼\(platformsBorder)┤".color(border))
            }
        }

        print("╰\(typeBorder)┴\(descriptionBorder)┴\(versionBorder)┴\(platformsBorder)╯".color(border))
    }

    static func download() {

        var type: Asset.AssetType = .jamf
        var version: String = "latest"
        var platform: Download.Platform = .mac
        var output: String = NSHomeDirectory() + "/Downloads/"

        for (index, argument) in CommandLine.arguments.enumerated() {

            // ignore the first two arguments, ignore odd arguments
            guard index > 1, index % 2 == 0 else {
                continue
            }

            guard ["-t", "--type", "-r", "--release", "-p", "--platform", "-o", "--output"].contains(argument) else {
                print("Unknown option: \(argument)\n")
                help()
                exit(1)
            }

            guard CommandLine.arguments.count > index + 1 else {
                print("Missing value for option: \(argument)\n")
                help()
                exit(1)
            }

            let string: String = CommandLine.arguments[index + 1]

            switch argument {
            case "-t", "--type":

                guard let value: Asset.AssetType = Asset.AssetType(description: string) else {
                    print("Invalid type: \(string)\n")
                    help()
                    exit(1)
                }

                type = value
            case "-r", "--release":
                version = string
            case "-p", "--platform":

                guard let value: Download.Platform = Download.Platform(description: string) else {
                    print("Invalid platform: \(string)\n")
                    help()
                    exit(1)
                }

                platform = value
            case "-o", "--output":
                var isDirectory: ObjCBool = false

                guard FileManager.default.fileExists(atPath: string, isDirectory: &isDirectory),
                    isDirectory.boolValue else {
                    print("Invalid output directory: \(string)\n")
                    help()
                    exit(1)
                }

                output = string

                if let last: Character = output.last, last != "/" {
                    output += "/"
                }
            default:
                break
            }
        }

        download(type: type, version: version, platform: platform, output: output)
    }

    private static func download(type: Asset.AssetType, version: String, platform: Download.Platform, output: String) {

        guard let assets: [Asset] = assets() else {
            exit(1)
        }

        var match: Bool = false

        for asset in assets where asset.type == type {

            var proposedRelease: Release?

            if version == "latest" {
                proposedRelease = asset.releases.first
            } else {
                for release in asset.releases where release.version == version {
                    proposedRelease = release
                }
            }

            guard let release: Release = proposedRelease else {
                print("\nUnable to find asset: \(asset.type.friendlyDescription) version \(version) (\(platform.friendlyDescription))")
                print("\nUse '\(String.appName) -l' or '\(String.appName) --list' to view all available types, releases and platforms\n")
                exit(1)
            }

            for download in release.downloads where download.platform == platform {
                match = true
                print("\nDownloading: \(type.friendlyDescription) version \(release.version) (\(platform.friendlyDescription))...")

                let name: String = download.url.filename()
                let path: String = output + name

                if HTTP.download(url: download.url, checksum: download.checksum, path: path) {
                    print("\nSuccessfully downloaded: \(path)")
                } else {
                    print("\nERROR: There was an error downloading: \(type.friendlyDescription) version \(version) (\(platform.friendlyDescription))")
                    exit(1)
                }
            }
        }

        if !match {
            print("\nUnable to find asset: \(type.friendlyDescription) version \(version) (\(platform.friendlyDescription))")
            print("\nUse '\(String.appName) -l' or '\(String.appName) --list' to view all available types, releases and platforms\n")
            help()
            exit(1)
        }
    }

    private static func assets() -> [Asset]? {

        print("Connecting to Jamf Nation...")

        guard let sessionID: String = HTTP.sessionID() else {
            print("\nERROR: There was an error connecting to Jamf Nation")
            print("\nUse '\(String.appName) -c' or '\(String.appName) --credentials' to update your credentials, and try again\n")
            help()
            return nil
        }

        print("\nRetrieving asset catalog from Jamf Nation...")

        let assets: [Asset] = HTTP.assets(using: sessionID)

        guard !assets.isEmpty else {
            print("\nERROR: There was an error retrieving the asset catalog from Jamf Nation")
            return nil
        }

        return assets
    }

    private static func maxVersionLength(for assets: [Asset]) -> Int {

        var max: Int = 0

        for asset in assets where asset.maxVersionLength > max {
            max = asset.maxVersionLength
        }

        return max
    }

    private static func maxPlatformsLength(for assets: [Asset]) -> Int {

        var max: Int = 0

        for asset in assets where asset.maxPlatformsLength > max {
            max = asset.maxPlatformsLength
        }

        return max
    }
}
