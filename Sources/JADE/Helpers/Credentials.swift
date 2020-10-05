//
//  Credentials.swift
//  JADE
//
//  Created by Nindi Gill on 3/10/20.
//

import Foundation
import KeychainAccess

class Credentials {

    static var authorization: String? {

        let keychain: Keychain = Keychain(service: .identifier)

        guard let username: String = keychain.allKeys().first,
            let password: String = keychain[username],
            let data: Data = "\(username):\(password)".data(using: .utf8) else {
            return nil
        }

        let string: String = "Basic " + data.base64EncodedString()
        return string
    }

    static func update(username: String, password: String) -> Bool {

        let keychain: Keychain = Keychain(service: .identifier)

        do {
            try keychain.removeAll()
            keychain[username] = password
            return true
        } catch {
            print(error)
            return false
        }
    }
}
