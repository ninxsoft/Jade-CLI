//
//  Credentials.swift
//  JADE
//
//  Created by Nindi Gill on 9/10/20.
//

import Foundation
import KeychainAccess

struct Credentials {

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

    static func run() {

        var username: String = ""
        var password: String = ""

        while username.isEmpty {

            print("Enter your Jamf Nation Email Address or Username: ", terminator: "")

            guard let string: String = readLine(strippingNewline: true) else {
                print("\nERROR - There was an error entering your Email Address or Username.\n")
                exit(1)
            }

            username = string
        }

        print("")

        while password.isEmpty {

            guard let string: UnsafeMutablePointer<Int8> = getpass("Enter your Jamf Nation Password: ") else {
                print("\nERROR - There was an error entering your Password.\n")
                exit(1)
            }

            password = String(cString: string)
        }

        guard update(username: username, password: password) else {
            print("\nERROR - There was an error updating credentials in keychain.\n")
            exit(1)
        }

        print("\nVerifying credentials...")

        guard let _: String = HTTP.sessionID() else {
            print("\nERROR - There was an error connecting to Jamf Nation.\n")
            exit(1)
        }

        print("\nSuccessfully updated credentials in keychain.\n")
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
