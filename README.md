# Jade CLI - Jamf Asset Downloader Extreme

A Mac command-line tool that automatically downloads your Jamf assets:

![Example](Readme%20Resources/Example.png)

## :warning::warning::warning: Jade CLI does not currently work as the authentication workflow relies on JavaScript :warning::warning::warning:

* See [#3 Not getting latest assets](https://github.com/ninxsoft/Jade-CLI/issues/3) for more details
* Please get involved / contact me [directly](mailto:nindi@ninxsoft.com) if you believe you can assist
* You can find the **GUI** (working) version of Jade [here](https://github.com/ninxsoft/Jade)

## Features

* [x] List and download the following Jamf assets:
  * Jamf Pro
  * Jamf AD CS Connector
  * Jamf Infrastructure Manager
  * Jamf PKI Proxy
  * Jamf Pro Server Tools
  * Jamf SCCM Plugin
  * Jamf Connect
  * Composer
  * Healthcare Listener
  **Note:** Availability will vary based on your Jamf subscription(s)
* Optionally export list as **JSON**, **Property List** or **YAML**
* [x] Download Jamf assets for the following platforms (where applicable):
  * Mac
  * Linux
  * Windows
  * Manual
  * RedHat
  * Ubuntu
* [x] Credentials are stored in your keychain

## Usage

```bash
OVERVIEW: Jamf Asset Downloader Extreme

A Mac command-line tool to automate the downloading of your Jamf Nation assets.

USAGE: jade [--credentials] [--list] [--export <export>] [--format <format>] [--download] [--type <type>] [--release <release>] [--platform <platform>] [--output <output>] [--version]

OPTIONS:
  -c, --credentials       Interactively add / update username
                          and password credentials to keychain.
  -l, --list              List all assets available to download.
  -e, --export <export>   Optionally export the list to a file.
  -f, --format <format>   Format of the list to export:
                          json
                          plist
                          yaml
  -d, --download          Download an asset from Jamf Nation.
  -t, --type <type>       Download types (depending on availability):
                          jamf (Jamf Pro Installer)
                          adcs (Jamf AD CS Connector)
                          jim (Jamf Infrastructure Manager)
                          jpp (Jamf PKI Proxy)
                          jpst (Jamf Pro Server Tools)
                          sccm (Jamf SCCM Plugin)
                          connect (Jamf Connect)
                          composer (Composer)
                          health (Healthcare Listener) (default: jamf)
  -r, --release <release> Release version (default: latest)
  -p, --platform <platform>
                          Download platforms (depending on availability):
                          mac (Mac binaries and DMGs)
                          windows (Windows binaries and MSIs)
                          linux (Linux binaries and .run files)
                          manual (Manual archives)
                          redhat (RedHat RPM installers)
                          ubuntu (Ubuntu DEB installers) (default: mac)
  -o, --output <output>   Output directory (default: ~/Downloads/)
  -v, --version           Display the version of jade.
  -h, --help              Show help information.
```

## Examples

```bash
# Add username and password to keychain
jade --credentials

# List all available Jamf Assets - will vary depending on your Jamf subscription
jade --list

# List + Export to a JSON file:
jade --list --export "/path/to/export.json" --format json

# List + Export to a Property List:
jade --list --export "/path/to/export.plist" --format plist

# List + Export to a YAML file:
jade --list --export "/path/to/export.yaml" --format yaml

# Download the default asset:
# Jamf Pro Installer, latest version, Mac
jade --download

# Download the latest version of Jamf Connect
jade --download --type connect

# Download a particular release version of the Jamf Pro Installer
jade --download --type jamf --release 10.0.0

# Download the latest Jamf Pro Installer for Linux
jade --download --type jamf --platform linux

# Download a particular release version of the Jamf Pro Server Tools
# for Windows, to a custom directory
jade --download --type jpst --release 2.7.3 --platform windows --output "/path/to/custom/directory"
```

## Build Requirements

* Swift **5.3**.
* Runs on macOS Yosemite **10.10** and later.

## Download

Grab the latest version of **Jade** from the [releases page](https://github.com/ninxsoft/Jade-CLI/releases).

## Credits / Thank You

* Project created and maintained by Nindi Gill ([ninxsoft](https://github.com/ninxsoft)).
* Apple ([apple](https://github.com/apple)) for [Swift Argument Parser](https://github.com/apple/swift-argument-parser), used to perform command line argument and flag operations.
* JP Simard ([@jpsim](https://github.com/jpsim)) for [Yams](https://github.com/jpsim/Yams), used to export YAML.
* Eric Boyd ([@ericjboyd](https://twitter.com/ericjboyd)) for assistance with adding Healthcare Listener.

## Version History

* 1.3
  * Added ability to export list as **JSON**, **Property List** or **YAML**

* 1.2.1
  * Removed [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) dependency
  * Fixed some download links that would not display / download

* 1.2
  * Checksums are now validated
  * Better detection of command line arguments
  * Code cleanup

* 1.1
  * Added support for Healthcare Listener
  * Minor tweaks to text formatting

* 1.0
  * Initial release

## License

> Copyright © 2021 Nindi Gill
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.
