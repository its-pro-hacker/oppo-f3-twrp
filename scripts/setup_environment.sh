#!/bin/bash
# setup_environment.sh - Setup Build Environment
# OPPO F3 (CPH1609) - MediaTek MT6750

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "[$timestamp] [$level] $message"
}

# Error handling
error_exit() {
    log "ERROR" "$1"
    exit 1
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        log "WARNING" "Running as root is not recommended"
        read -p "Continue anyway? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check operating system
check_os() {
    log "INFO" "Checking operating system..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log "INFO" "Linux detected"
        
        # Check distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            log "INFO" "Distribution: $NAME $VERSION"
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        log "INFO" "Windows (MSYS/Cygwin) detected"
        log "WARNING" "Some features may not work on Windows"
    else
        log "WARNING" "Unsupported operating system: $OSTYPE"
    fi
}

# Install dependencies
install_dependencies() {
    log "INFO" "Installing dependencies..."
    
    # Check if apt-get is available
    if command -v apt-get &> /dev/null; then
        log "INFO" "Using apt-get for package installation"
        
        # Update package list
        sudo apt-get update
        
        # Install required packages
        sudo apt-get install -y \
            git-core \
            gnupg \
            flex \
            bison \
            build-essential \
            zip \
            curl \
            zlib1g-dev \
            gcc-multilib \
            g++-multilib \
            libc6-dev-i386 \
            libncurses5 \
            lib32ncurses5-dev \
            x11proto-core-dev \
            libx11-dev \
            lib32z1-dev \
            libgl1-mesa-dev \
            libxml2-utils \
            xsltproc \
            unzip \
            fontconfig \
            python3 \
            python3-pip \
            libssl-dev \
            ccache \
            libncurses-dev \
            lib32ncurses-dev \
            lib32stdc++6
            
    elif command -v yum &> /dev/null; then
        log "INFO" "Using yum for package installation"
        
        sudo yum install -y \
            git \
            gcc \
            gcc-c++ \
            make \
            flex \
            bison \
            zip \
            unzip \
            curl \
            wget \
            zlib-devel \
            openssl-devel \
            ncurses-devel \
            python3 \
            ccache
            
    elif command -v pacman &> /dev/null; then
        log "INFO" "Using pacman for package installation"
        
        sudo pacman -S --needed \
            git \
            gcc \
            make \
            flex \
            bison \
            zip \
            unzip \
            curl \
            wget \
            zlib \
            openssl \
            ncurses \
            python \
            ccache
            
    else
        log "WARNING" "No supported package manager found"
        log "INFO" "Please install dependencies manually"
    fi
    
    log "INFO" "Dependencies installed"
}

# Install repo tool
install_repo() {
    log "INFO" "Installing repo tool..."
    
    # Check if repo is already installed
    if command -v repo &> /dev/null; then
        log "INFO" "repo tool already installed"
        return
    fi
    
    # Create bin directory
    mkdir -p ~/.bin
    
    # Download repo
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
    chmod a+x ~/.bin/repo
    
    # Add to PATH
    echo 'export PATH="$HOME/.bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.bin:$PATH"
    
    log "INFO" "repo tool installed"
}

# Setup ccache
setup_ccache() {
    log "INFO" "Setting up ccache..."
    
    # Create ccache directory
    mkdir -p ~/.ccache
    
    # Set ccache size
    ccache -M 50G
    
    # Set environment variables
    echo 'export USE_CCACHE=1' >> ~/.bashrc
    echo 'export CCACHE_DIR=~/.ccache' >> ~/.bashrc
    echo 'export CCACHE_EXEC="$(which ccache)"' >> ~/.bashrc
    
    export USE_CCACHE=1
    export CCACHE_DIR=~/.ccache
    export CCACHE_EXEC="$(which ccache)"
    
    log "INFO" "ccache setup completed"
}

# Setup Android SDK
setup_android_sdk() {
    log "INFO" "Setting up Android SDK..."
    
    # Check if Android SDK is already installed
    if [ -d "$HOME/Android/Sdk" ]; then
        log "INFO" "Android SDK already installed"
        return
    fi
    
    # Create SDK directory
    mkdir -p "$HOME/Android/Sdk"
    
    # Download command line tools
    cd "$HOME/Android/Sdk"
    
    # Download latest command line tools
    curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip commandlinetools.zip
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    
    # Set environment variables
    echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.bashrc
    echo 'export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bashrc
    
    export ANDROID_HOME="$HOME/Android/Sdk"
    export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
    
    # Accept licenses
    yes | sdkmanager --licenses
    
    # Install required packages
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
    
    log "INFO" "Android SDK setup completed"
}

# Setup Java
setup_java() {
    log "INFO" "Setting up Java..."
    
    # Check if Java is already installed
    if command -v java &> /dev/null; then
        local java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
        log "INFO" "Java already installed: $java_version"
        return
    fi
    
    # Install OpenJDK 8
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y openjdk-8-jdk
    elif command -v yum &> /dev/null; then
        sudo yum install -y java-1.8.0-openjdk-devel
    elif command -v pacman &> /dev/null; then
        sudo pacman -S jdk8-openjdk
    fi
    
    # Set JAVA_HOME
    local java_home=$(dirname $(dirname $(readlink -f $(which java))))
    echo "export JAVA_HOME=$java_home" >> ~/.bashrc
    export JAVA_HOME=$java_home
    
    log "INFO" "Java setup completed"
}

# Setup Python
setup_python() {
    log "INFO" "Setting up Python..."
    
    # Check if Python 3 is already installed
    if command -v python3 &> /dev/null; then
        local python_version=$(python3 --version | cut -d' ' -f2)
        log "INFO" "Python 3 already installed: $python_version"
        return
    fi
    
    # Install Python 3
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y python3 python3-pip
    elif command -v yum &> /dev/null; then
        sudo yum install -y python3 python3-pip
    elif command -v pacman &> /dev/null; then
        sudo pacman -S python python-pip
    fi
    
    log "INFO" "Python setup completed"
}

# Main function
main() {
    log "INFO" "=========================================="
    log "INFO" "OPPO F3 (CPH1609) Build Environment Setup"
    log "INFO" "MediaTek MT6750 - Android 6.0.1"
    log "INFO" "=========================================="
    
    # Check if running as root
    check_root
    
    # Check operating system
    check_os
    
    # Install dependencies
    install_dependencies
    
    # Install repo tool
    install_repo
    
    # Setup ccache
    setup_ccache
    
    # Setup Java
    setup_java
    
    # Setup Python
    setup_python
    
    # Setup Android SDK
    setup_android_sdk
    
    log "INFO" "=========================================="
    log "INFO" "Environment setup completed successfully!"
    log "INFO" "=========================================="
    log "INFO" "Next steps:"
    log "INFO" "1. Run: source ~/.bashrc"
    log "INFO" "2. Run: ./scripts/build_twrp.sh"
    log "INFO" "=========================================="
}

# Run main function
main "$@"
