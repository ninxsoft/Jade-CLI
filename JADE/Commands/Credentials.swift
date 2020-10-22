//
//  Credentials.swift
//  JADE
//
//  Created by Nindi Gill on 9/10/20.
//

import Foundation

struct Credentials {

    static var authorization: String? {

        guard let credentials: (username: String, password: String) = Keychain.read(),
            let data: Data = "\(credentials.username):\(credentials.password)".data(using: .utf8) else {
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

        guard Keychain.update(username: username, password: password) else {
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
}
