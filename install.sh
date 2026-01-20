#!/bin/bash

set -e

# Version to install
VERSION="v0.0.1"
BINARY_NAME="rentops"
REPO="rentops/binaries"

# Detect OS and Arch
OS="$(uname -s)"
ARCH="$(uname -m)"

if [ "$OS" != "Linux" ] || [ "$ARCH" != "x86_64" ]; then
    echo "RENTOPS INSTALLER"
    echo "----------------------"
    echo "Detected System: $OS / $ARCH"
    echo ""
    echo "Pre-built binaries are currently available for Linux x86_64 only."
    echo ""
    echo "To install on your system, please build from source:"
    echo "1. Ensure Rust is installed (https://rustup.rs)"
    echo "2. Clone the repository: git clone https://github.com/rentops/cli"
    echo "3. Build and install: cargo install --path ."
    echo ""
    echo "For full instructions, visit: https://github.com/rentops/cli"
    exit 1
fi

OS_TYPE="linux"
ARCH_TYPE="amd64"

# Construct Asset Name
# Format: linux-amd64-v0.0.1
# Note: Ensure you upload assets with these exact names to GitHub Releases
ASSET_NAME="${OS_TYPE}-${ARCH_TYPE}-${VERSION}"

echo "RENTOPS INSTALLER"
echo "----------------------"
echo "Detected: ${OS_TYPE} / ${ARCH_TYPE}"
echo "Target:   ${VERSION}"
echo "Repo:     ${REPO}"

# Download URL
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${ASSET_NAME}"

# Install Directory
INSTALL_DIR="/usr/local/bin"
TARGET_PATH="${INSTALL_DIR}/${BINARY_NAME}"

# Check permissions
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Sudo permissions required to install to ${INSTALL_DIR}"
    SUDO="sudo"
else
    SUDO=""
fi

echo "Downloading from: ${DOWNLOAD_URL}..."

# Download using curl
# We download directly to the final binary name 'rentops'
if command -v curl >/dev/null 2>&1; then
    $SUDO curl -L "${DOWNLOAD_URL}" -o "${TARGET_PATH}"
else
    echo "Error: curl is required."
    exit 1
fi

echo "🔒 Verifying integrity..."
# Basic check to see if we got a binary or an HTML error page
if grep -q "<html" "${TARGET_PATH}"; then
    echo "  Error: Download failed (404 Not Found or Access Denied)."
    echo "   Please check if release ${VERSION} exists on GitHub for ${ASSET_NAME}."
    $SUDO rm "${TARGET_PATH}"
    exit 1
fi

# Make executable
echo "Making executable..."
$SUDO chmod +x "${TARGET_PATH}"

echo ""
echo "Your Installation is Complete!"
echo "   Run 'rentops help' to get started."
echo "   Visit https://rentops.davidnzube.xyz/docs"
echo ""
