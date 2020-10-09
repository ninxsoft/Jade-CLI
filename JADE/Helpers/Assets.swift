//
//  Assets.swift
//  JADE
//
//  Created by Nindi Gill on 9/10/20.
//

import Foundation

struct Assets {

    static func retrieve() -> [Asset]? {

        print("\nConnecting to Jamf Nation...")

        guard let sessionID: String = HTTP.sessionID() else {
            print("\nERROR - There was an error connecting to Jamf Nation.")
            print("\nUse '\(String.appName) -c' or '\(String.appName) --credentials' to update your credentials, and try again.\n")
            return nil
        }

        print("\nRetrieving asset catalog from Jamf Nation...")

        let assets: [Asset] = HTTP.assets(using: sessionID)

        guard !assets.isEmpty else {
            print("\nERROR - There was an error retrieving the asset catalog from Jamf Nation.\n")
            return nil
        }

        return assets
    }
}
