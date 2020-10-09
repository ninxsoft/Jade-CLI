//
//  Download.swift
//  JADE
//
//  Created by Nindi Gill on 4/10/20.
//

import Foundation

struct Download {

    static func run(type: Asset.AssetType, releaseVersion: String, platform: DownloadLink.Platform, output: String) {

        var isDirectory: ObjCBool = false

        guard FileManager.default.fileExists(atPath: output, isDirectory: &isDirectory),
            isDirectory.boolValue else {
            print("\nERROR - Invalid output directory '\(output)'.\n")
            exit(1)
        }

        guard let assets: [Asset] = Assets.retrieve() else {
            exit(1)
        }

        var proposedRelease: Release?
        var proposedDownloadLink: DownloadLink?

        for asset in assets where asset.type == type {

            if releaseVersion == "latest" {
                proposedRelease = asset.releases.first
            } else {
                for release in asset.releases where release.version == releaseVersion {
                    proposedRelease = release
                }
            }
        }

        guard let release: Release = proposedRelease else {
            print("\nERROR - Unable to find asset '\(type.friendlyDescription) version \(releaseVersion) (\(platform.friendlyDescription))'.")
            print("\nUse '\(String.appName) -l' or '\(String.appName) --list' to view all available types, releases and platforms.\n")
            exit(1)
        }

        for downloadLink in release.downloadLinks where downloadLink.platform == platform {
            proposedDownloadLink = downloadLink
        }

        guard let downloadLink: DownloadLink = proposedDownloadLink else {
            print("\nERROR - Unable to find asset '\(type.friendlyDescription) version \(releaseVersion) (\(platform.friendlyDescription))'.")
            print("\nUse '\(String.appName) -l' or '\(String.appName) --list' to view all available types, releases and platforms.\n")
            exit(1)
        }

        performDownload(downloadLink: downloadLink, type: type, release: release, platform: platform, output: output)
    }

    private static func performDownload(downloadLink: DownloadLink, type: Asset.AssetType, release: Release, platform: DownloadLink.Platform, output: String) {

        print("\nDownloading '\(type.friendlyDescription) version \(release.version) (\(platform.friendlyDescription))'...")

        var destination: String = output

        if let last: Character = output.last, last != "/" {
            destination += "/"
        }

        destination += downloadLink.url.filename()

        guard let source: String = download(url: downloadLink.url) else {
            print("\nERROR - There was an error downloading '\(type.friendlyDescription) version \(release.version) (\(platform.friendlyDescription))'.\n")
            exit(1)
        }

        print("\nValidating checksum...")

        guard let checksum: String = checksum(path: source) else {
            print("\nERROR - There was an error retrieving the checksum for '\(source)'.\n")
            exit(1)
        }

        if checksum != downloadLink.checksum {
            print("\nERROR - Checksum mismatch: '\(checksum)', expected '\(downloadLink.checksum)'.\n")
            exit(1)
        }

        guard move(source: source, destination: destination) else {
            print("\nERROR - There was an error moving '\(source)' to '\(destination)'.\n")
            exit(1)
        }

        print("\nSuccessfully downloaded '\(destination)'.\n")
    }

    private static func download(url string: String) -> String? {

        guard let url: URL = URL(string: string) else {
            return nil
        }

        var performingTask: Bool = true
        var destination: String?
        let task: URLSessionDownloadTask = URLSession.shared.downloadTask(with: url) { url, response, error in

            if let error: Error = error {
                print(error.localizedDescription)
                performingTask = false
                return
            }

            guard let response: URLResponse = response,
                let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                performingTask = false
                return
            }

            guard let url: URL = url else {
                performingTask = false
                return
            }

            destination = url.path
            performingTask = false
        }

        task.resume()

        while performingTask {
            sleep(1)
        }

        return destination
    }

    private static func checksum(path: String) -> String? {

        let url: URL = URL(fileURLWithPath: path)

        do {
            let data: Data = try Data(contentsOf: url)
            return data.sha256
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private static func move(source: String, destination: String) -> Bool {

        do {

            if FileManager.default.fileExists(atPath: destination) {
                try FileManager.default.removeItem(atPath: destination)
            }

            try FileManager.default.moveItem(atPath: source, toPath: destination)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
