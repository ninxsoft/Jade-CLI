//
//  HTTP.swift
//  Jade
//
//  Created by Nindi Gill on 4/10/20.
//

import Foundation

class HTTP {

    static func sessionID() -> String? {

        guard let url: URL = URL(string: .loginURL),
            let authorization: String = Credentials.authorization else {
            return nil
        }

        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        var performingTask: Bool = true
        var sessionID: String = ""

        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { _, response, error in

            if let error: Error = error {
                print(error.localizedDescription)
                performingTask = false
                return
            }

            guard let response: URLResponse = response,
                let url: URL = response.url,
                let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let responseHeaderFields: [String: String] = httpResponse.allHeaderFields as? [String: String] else {
                performingTask = false
                return
            }

            let cookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: responseHeaderFields, for: url)

            for cookie in cookies where cookie.name == .cookieName {
                sessionID = cookie.value
            }

            performingTask = false
        }

        task.resume()

        while performingTask {
            sleep(1)
        }

        guard !sessionID.isEmpty else {
            return nil
        }

        return sessionID
    }

    static func assets(using sessionID: String) -> [Asset] {

        let cookieJar: HTTPCookieStorage = HTTPCookieStorage.shared
        let key: String = .cookieName
        let responseHeaderFields: [String: String] = ["Set-Cookie": "\(key)=\(sessionID)"]

        var assets: [Asset] = []

        for type in Asset.AssetType.allCases {

            var performingTask: Bool = true

            guard let urlString: String = type.url,
                let url: URL = URL(string: urlString) else {
                performingTask = false
                continue
            }

            let cookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: responseHeaderFields, for: url)
            cookieJar.setCookies(cookies, for: url, mainDocumentURL: url)

            let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { data, response, error in

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

                guard let data: Data = data else {
                    performingTask = false
                    return
                }

                let array: [Asset] = getAssets(type: type, from: data)

                for item in array where !assets.map({ $0.type }).contains(item.type) {
                    assets.append(item)
                }

                performingTask = false
            }

            task.resume()

            while performingTask {
                sleep(1)
            }
        }

        return assets.sorted { $0.type.friendlyDescription < $1.type.friendlyDescription }
    }

    private static func getAssets(type: Asset.AssetType, from data: Data) -> [Asset] {

        var assets: [Asset] = []

        do {
            if let dictionary: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                if type == .all {
                    if let remainingAssets: [Asset] = getAssets(from: dictionary) {
                        assets.append(contentsOf: remainingAssets)
                    }
                } else {
                    if let asset: Asset = getAsset(type: type, from: dictionary) {
                        assets.append(asset)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }

        return assets
    }

    private static func getAsset(type: Asset.AssetType, from dictionary: [String: Any]) -> Asset? {

        guard let dataArray: [[String: Any]] = dictionary["data"] as? [[String: Any]] else {
            return nil
        }

        var releases: [Release] = []

        for dataDictionary in dataArray {

            guard let releaseVersionsArray: [[String: Any]] = dataDictionary["releaseVersions"] as? [[String: Any]] else {
                continue
            }

            for releaseVersionDictionary in releaseVersionsArray {

                guard let version: String = releaseVersionDictionary["version"] as? String,
                    let downloadLinksArray: [[String: Any]] = releaseVersionDictionary["downloadLinks"] as? [[String: Any]] else {
                    continue
                }

                var downloadLinks: [DownloadLink] = []

                for downloadLinkDictionary in downloadLinksArray {

                    guard let platformString: String = downloadLinkDictionary["type"] as? String,
                        let platform: DownloadLink.Platform = DownloadLink.Platform(platform: platformString),
                        let url: String = downloadLinkDictionary["url"] as? String,
                        let checksum: String = downloadLinkDictionary["checksum"] as? String else {
                        continue
                    }

                    let downloadLink: DownloadLink = DownloadLink(platform: platform, url: url, checksum: checksum)
                    downloadLinks.append(downloadLink)
                }

                guard !downloadLinks.isEmpty else {
                    continue
                }

                let release: Release = Release(version: version, downloadLinks: downloadLinks)
                releases.append(release)
            }
        }

        guard !releases.isEmpty else {
            return nil
        }

        let asset: Asset = Asset(type: type, releases: releases)
        return asset
    }

    private static func getAssets(from dictionary: [String: Any]) -> [Asset]? {

        guard let dataArray: [[String: Any]] = dictionary["data"] as? [[String: Any]] else {
            return nil
        }

        var assets: [Asset] = []

        for dataDictionary in dataArray {

            guard let typeString: String = dataDictionary["type"] as? String,
                let type: Asset.AssetType = Asset.AssetType(type: typeString),
                let version: String = dataDictionary["version"] as? String,
                let downloadsArray: [[String: Any]] = dataDictionary["downloads"] as? [[String: Any]] else {
                continue
            }

            var downloadLinks: [DownloadLink] = []

            for downloadDictionary in downloadsArray {

                guard let platformString: String = downloadDictionary["type"] as? String,
                    let platform: DownloadLink.Platform = DownloadLink.Platform(platform: platformString),
                    let url: String = downloadDictionary["url"] as? String,
                    let checksum: String = downloadDictionary["checksum"] as? String else {
                    continue
                }

                let downloadLink: DownloadLink = DownloadLink(platform: platform, url: url, checksum: checksum)
                downloadLinks.append(downloadLink)
            }

            guard !downloadLinks.isEmpty else {
                continue
            }

            let release: Release = Release(version: version, downloadLinks: downloadLinks)
            let asset: Asset = Asset(type: type, releases: [release])
            assets.append(asset)
        }

        return assets
    }
}
