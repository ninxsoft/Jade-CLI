//
//  Release.swift
//  JADE
//
//  Created by Nindi Gill on 4/10/20.
//

import Foundation

struct Release {
    let version: String
    let downloads: [Download]
    var platforms: String {
        Array(Set(downloads.map {
            $0.platform.friendlyDescription
        })).sorted().joined(separator: ", ")
    }
}
