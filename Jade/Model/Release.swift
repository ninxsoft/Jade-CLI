//
//  Release.swift
//  Jade
//
//  Created by Nindi Gill on 4/10/20.
//

import Foundation

struct Release: Codable {
    let version: String
    let downloadLinks: [DownloadLink]
    var platforms: String {
        Array(Set(downloadLinks.map {
            $0.platform.friendlyDescription
        })).sorted().joined(separator: ", ")
    }
    var dictionary: [String: Any] {
        [
            "version": version,
            "downloads": downloadLinks.map { $0.dictionary }
        ]
    }
}
