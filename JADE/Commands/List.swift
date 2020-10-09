//
//  List.swift
//  JADE
//
//  Created by Nindi Gill on 9/10/20.
//

import Foundation

struct List {

    static func run() {

        guard let assets: [Asset] = Assets.retrieve() else {
            exit(1)
        }

        let border: String.Color = .cyan
        let heading: String.Color = .white
        let pipe: String = "│".color(border)
        let type: String = "Type".padding(toLength: maxDescriptionLength(for: assets), withPad: " ", startingAt: 0).color(heading, bold: true)
        let typeBorder: String = "".padding(toLength: maxDescriptionLength(for: assets) + 2, withPad: "─", startingAt: 0)
        let description: String = "Description".padding(toLength: maxFriendlyDescriptionLength(for: assets), withPad: " ", startingAt: 0).color(heading, bold: true)
        let descriptionBorder: String = "".padding(toLength: maxFriendlyDescriptionLength(for: assets) + 2, withPad: "─", startingAt: 0)
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
            let type: String = asset.type.description.padding(toLength: maxDescriptionLength(for: assets), withPad: " ", startingAt: 0)
            let description: String = asset.type.friendlyDescription.padding(toLength: maxFriendlyDescriptionLength(for: assets), withPad: " ", startingAt: 0)

            if let release: Release = asset.releases.first {
                let version: String = release.version.padding(toLength: versionLength, withPad: " ", startingAt: 0)
                let platforms: String = release.platforms.padding(toLength: platformsLength, withPad: " ", startingAt: 0)
                print(pipe + " \(type) " + pipe + " \(description) " + pipe + " \(version) " + pipe + " \(platforms) " + pipe)

                if asset.releases.count > 1 {
                    let releases: [Release] = Array(asset.releases[1...])

                    for release in releases {
                        let version: String = release.version.padding(toLength: versionLength, withPad: " ", startingAt: 0)
                        let platforms: String = release.platforms.padding(toLength: platformsLength, withPad: " ", startingAt: 0)
                        print(pipe + "".padding(toLength: maxDescriptionLength(for: assets) + 2, withPad: " ", startingAt: 0) +
                            pipe + "".padding(toLength: maxFriendlyDescriptionLength(for: assets) + 2, withPad: " ", startingAt: 0) +
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

        print("╰\(typeBorder)┴\(descriptionBorder)┴\(versionBorder)┴\(platformsBorder)╯\n".color(border))
    }

    private static func maxDescriptionLength(for assets: [Asset]) -> Int {

        var max: Int = 0

        for asset in assets where asset.type.description.count > max {
            max = asset.type.description.count
        }

        return max
    }

    private static func maxFriendlyDescriptionLength(for assets: [Asset]) -> Int {

        var max: Int = 0

        for asset in assets where asset.type.friendlyDescription.count > max {
            max = asset.type.friendlyDescription.count
        }

        return max
    }

    private static func maxVersionLength(for assets: [Asset]) -> Int {

        var max: Int = 0

        for asset in assets {
            for release in asset.releases where release.version.count > max {
                max = release.version.count
            }
        }

        return max
    }

    private static func maxPlatformsLength(for assets: [Asset]) -> Int {

        var max: Int = 0

        for asset in assets {
            for release in asset.releases where release.platforms.count > max {
                max = release.platforms.count
            }
        }

        return max
    }
}
