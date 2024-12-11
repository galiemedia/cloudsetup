# Cloudsetup

*Cloudsetup* is a script our team occasionally uses to setup a [Debian 12](https://www.debian.org/) server instance for local development.

## About the Script

We wrote this as a simple way to configure Debian for local server or development tasks where other cloud images, initialization tools or playbooks wouldn't fit.  The script will ask questions about which applications or packages should be added, but it's mostly to configure a "blank slate" for whatever is going to be installed in the future.

## How to use this script

- Clone the repository using the command `git clone https://github.com/galiemedia/cloudsetup.git`
- Switch into the cloned directory using `cd ./cloudsetup/`
- Remember to make the script executable with `chmod +x cloudsetup.sh`

## License

*Cloudsetup* is released under the [MIT License](https://opensource.org/licenses/MIT).