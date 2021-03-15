//
//  Data+Extension.swift
//  Jade
//
//  Created by Nindi Gill on 9/10/20.
//

import CommonCrypto
import Foundation

extension Data {

    var sha256: String {
        var digest: [UInt8] = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        self.withUnsafeBytes { buffer in
            _ = CC_SHA256(buffer.baseAddress, CC_LONG(buffer.count), &digest)
        }

        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
