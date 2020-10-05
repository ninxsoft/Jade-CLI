//
//  main.swift
//  JADE
//
//  Created by Nindi Gill on 3/10/20.
//

import Foundation

// the fun starts here
print("")

guard CommandLine.arguments.count > 1 else {
    Functions.help()
    exit(0)
}

let flag: String = CommandLine.arguments[1]

switch flag {
case "-h", "--help":
    Functions.help()
case "-v", "--version":
    Functions.version()
case "-c", "--credentials":
    Functions.credentials()
case "-l", "--list":
    Functions.list()
case "-d", "--download":
    Functions.download()
default:
    Functions.help()
}

exit(0)
