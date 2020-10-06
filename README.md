
# JADE - Jamf Asset Downloader Extreme

A Mac command-line tool to automate the downloading of your [Jamf Nation](https://www.jamf.com/jamf-nation/) assets:

![Example](Readme%20Resources/Example.png)

## Features

*   [x] List all available Jamf assets for download

    **Note:** Availability based upon your Jamf Subscription

*   [x] Download the following Jamf assets
    *   Jamf Pro Installer
    *   Jamf AD CS Connector
    *   Jamf Infrastructure Manager
    *   Jamf PKI Proxy
    *   Jamf Pro Server Tools
    *   Jamf SCCM Plugin
    *   Jamf Connect
    *   Composer

    **Note:** Availability based upon your Jamf Subscription
*   [x] Download Jamf assets for the following platforms (where applicable):
    *   Mac
    *   Linux
    *   Windows
    *   Manual
    *   RedHat
    *   Ubuntu

*   [x] Credentials are stored in your keychain - and not in a property list!

## Usage

```bash
jade - Jamf Asset Downloader Extreme

Usage: jade [-h] | [-v] | [-c] | [-l] | [-d] [-t] [-r] [-p] [-o]

Options:
  -h, --help           Display help / this usage message
  -v, --version        Display the version of jade
  -c, --credentials    Interactively add / update username
                       and password credentials to keychain
  -l, --list           List all assets available to download
  -d, --download       Download an asset from Jamf Nation

Download Options:
  -t, --type           Download types:
                       jamf (Jamf Pro Installer)
                       adcs (Jamf AD CS Connector)
                       jim (Jamf Infrastructure Manager)
                       jpp (Jamf PKI Proxy)
                       jpst (Jamf Pro Server Tools)
                       sccm (Jamf SCCM Plugin)
                       connect (Jamf Connect)
                       composer (Composer)
                       Default: jamf

  -r, --release        Release version
                       Default: latest

  -p, --platform       Download platforms:
                       mac (Mac binaries and DMGs)
                       windows (Windows binaries and MSIs)
                       linux (Linux binaries and .run files)
                       manual (Manual archives)
                       redhat (RedHat RPM installers)
                       ubuntu (Ubuntu DEB installers)
                       Default: mac

  -o, --output         Output directory
                       Default: ~/Downloads
```

## Examples

```bash
# Add username and password to keychain
jade --credentials

# List all available Jamf Assets
# (will vary depending on your Jamf subscription)
jade --list

# Download the default asset
# (Jamf Pro Installer, latest version, Mac)
jade --download

# Download the latest version of Jamf Connect
jade --download --type connect

# Download a particular release version of the Jamf Pro Installer
jade --download --type jamf --release 10.0.0

# Download the latest Jamf Pro Installer for Linux
jade --download --type jamf --platform linux

# Download a particular release version of the Jamf Pro Server Tools
# for Windows, to a custom directory
jade --download --type jpst --release 2.7.3 --platform windows --output ~/Desktop
```

## Build Requirements

*   Swift **5.3**.
*   Runs on macOS Yosemite **10.10** and later.

## Download

Grab the latest version of **JADE** from the [releases page](https://github.com/ninxsoft/JADE/releases).

## Credits / Thank You

*   Project created and maintained by Nindi Gill ([ninxsoft](https://github.com/ninxsoft)).
*   Kishikawa Katsumi ([kishikawakatsumi](https://github.com/kishikawakatsumi)) for [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess), used to read and update keychain credentials.

## Version History

*   1.0
    *   Initial release

## License

    Copyright © 2020 Nindi Gill

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
