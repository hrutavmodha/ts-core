#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

WORKSPACE_DIR="$(pwd)"
DEPOT_TOOLS_DIR="${WORKSPACE_DIR}/depot_tools"
GLOBAL_DEPOT_TOOLS="/home/hrutav-modha/depot_tools"

echo "=== Native TS Browser Setup Script ==="

# 1. Check system requirements
echo "Checking system requirements..."
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install it first."
    exit 1
fi
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 is not installed. Please install it first."
    exit 1
fi

# 2. Check for existing depot_tools
if [ -d "${GLOBAL_DEPOT_TOOLS}" ]; then
    echo "Found existing depot_tools at ${GLOBAL_DEPOT_TOOLS}"
    if [ ! -e "${DEPOT_TOOLS_DIR}" ]; then
        echo "Creating symlink to existing depot_tools..."
        ln -s "${GLOBAL_DEPOT_TOOLS}" "${DEPOT_TOOLS_DIR}"
    else
        echo "depot_tools link/directory already exists in workspace."
    fi
else
    if [ ! -d "${DEPOT_TOOLS_DIR}" ]; then
        echo "Cloning Google depot_tools..."
        git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "${DEPOT_TOOLS_DIR}"
    else
        echo "depot_tools already exists. Skipping clone."
    fi
fi

# 3. Add depot_tools to PATH for this session
export PATH="${DEPOT_TOOLS_DIR}:${PATH}"

# 4. Prepare chromium build directory
CHROMIUM_DIR="${WORKSPACE_DIR}/chromium"
if [ ! -d "${CHROMIUM_DIR}" ]; then
    echo "Creating 'chromium' workspace directory..."
    mkdir -p "${CHROMIUM_DIR}"
fi

cd "${CHROMIUM_DIR}"

# 5. Initialize gclient configuration
if [ ! -f ".gclient" ]; then
    echo "Initializing gclient configuration..."
    gclient config --unmanaged https://chromium.googlesource.com/chromium/src.git
else
    echo ".gclient configuration already exists. Skipping initialization."
fi

echo "========================================================================="
echo "Setup completed successfully!"
echo "Next step: Run the following commands to start the Chromium source fetch:"
echo ""
echo "  export PATH=\"\$(pwd)/depot_tools:\$PATH\""
echo "  cd chromium"
echo "  fetch --no-history chromium"
echo ""
echo "NOTE: The fetch command will download ~30GB+ of data and will take time."
echo "========================================================================="
