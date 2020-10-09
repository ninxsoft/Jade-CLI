//
//  Release.swift
//  JADE
//
//  Created by Nindi Gill on 4/10/20.
//

import Foundation

struct Release {
    let version: String
    let downloadLinks: [DownloadLink]
    var platforms: String {
        Array(Set(downloadLinks.map {
            $0.platform.friendlyDescription
        })).sorted().joined(separator: ", ")
    }
}
