//
//  Keychain.swift
//  JADE
//
//  Created by Nindi Gill on 22/10/20.
//

import Foundation

struct Keychain {

    static func read() -> (username: String, password: String)? {

        let query: [String: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: String.identifier,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as [String: Any]

        var item: CFTypeRef?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == noErr else {
            return nil
        }

        // swiftlint:disable:next force_cast
        let coreFoundationDictionary: CFDictionary = item as! CFDictionary

        guard let dictionary: [String: Any] = coreFoundationDictionary as? [String: Any],
            let username: String = dictionary["acct"] as? String,
            let data: Data = dictionary["v_Data"] as? Data,
            let password: String = String(data: data, encoding: .utf8) else {
            return nil
        }

        return (username: username, password: password)
    }

    static func update(username: String, password: String) -> Bool {

        guard let data: Data = password.data(using: .utf8) else {
            return false
        }

        let query: [String: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: String.identifier
        ] as [String: Any]

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, nil)
        let exists: Bool = status == noErr

        if exists {

            let attributes: [String: Any] = [
                kSecAttrAccount: username,
                kSecValueData: data
            ] as [String: Any]

            let status: OSStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            return status == noErr
        } else {

            let attributes: [String: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: String.identifier,
                kSecAttrAccount: username,
                kSecValueData: data
            ] as [String: Any]

            let status: OSStatus = SecItemAdd(attributes as CFDictionary, nil)
            return status == noErr
        }
    }
}
