#!/bin/bash

# BassUp iOS Development Environment Setup Script
# This script sets up a complete iOS development environment

set -e

echo "🚀 Setting up BassUp iOS Development Environment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Xcode is installed
check_xcode() {
    print_status "Checking Xcode installation..."
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode is not installed. Please install Xcode from the App Store."
        exit 1
    fi
    
    XCODE_VERSION=$(xcodebuild -version | head -n 1 | cut -d' ' -f2)
    print_success "Xcode $XCODE_VERSION is installed"
}

# Check if Command Line Tools are installed
check_command_line_tools() {
    print_status "Checking Command Line Tools..."
    if ! xcode-select -p &> /dev/null; then
        print_warning "Command Line Tools not found. Installing..."
        xcode-select --install
        print_status "Please complete the Command Line Tools installation and run this script again."
        exit 1
    fi
    print_success "Command Line Tools are installed"
}

# Install Homebrew
install_homebrew() {
    print_status "Checking Homebrew installation..."
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    print_success "Homebrew is installed"
}

# Install Ruby gems
install_gems() {
    print_status "Installing Ruby gems..."
    
    # Install CocoaPods
    if ! command -v pod &> /dev/null; then
        print_status "Installing CocoaPods..."
        sudo gem install cocoapods
    fi
    
    # Install Fastlane
    if ! command -v fastlane &> /dev/null; then
        print_status "Installing Fastlane..."
        sudo gem install fastlane
    fi
    
    print_success "Ruby gems installed"
}

# Install Homebrew packages
install_brew_packages() {
    print_status "Installing Homebrew packages..."
    
    # Development tools
    brew install swiftlint
    brew install carthage
    brew install --cask visual-studio-code
    
    # Additional useful tools
    brew install git-lfs
    brew install --cask postman
    brew install --cask figma
    
    print_success "Homebrew packages installed"
}

# Setup CocoaPods
setup_cocoapods() {
    print_status "Setting up CocoaPods..."
    
    if [ -f "Podfile" ]; then
        pod install
        print_success "CocoaPods dependencies installed"
    else
        print_warning "No Podfile found. Skipping CocoaPods setup."
    fi
}

# Setup Git hooks
setup_git_hooks() {
    print_status "Setting up Git hooks..."
    
    # Create .git/hooks directory if it doesn't exist
    mkdir -p .git/hooks
    
    # Create pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# Pre-commit hook for iOS development

echo "Running pre-commit checks..."

# Run SwiftLint
if command -v swiftlint &> /dev/null; then
    swiftlint lint --quiet
    if [ $? -ne 0 ]; then
        echo "SwiftLint found violations. Please fix them before committing."
        exit 1
    fi
fi

# Run tests if available
if [ -f "Podfile" ]; then
    xcodebuild test -workspace BassUp.xcworkspace -scheme BassUp -destination 'platform=iOS Simulator,name=iPhone 15 Pro' | xcpretty
fi

echo "Pre-commit checks passed!"
EOF
    
    chmod +x .git/hooks/pre-commit
    print_success "Git hooks configured"
}

# Setup Xcode project (if not exists)
setup_xcode_project() {
    print_status "Checking Xcode project..."
    
    if [ ! -f "BassUp.xcodeproj/project.pbxproj" ]; then
        print_warning "Xcode project not found. You'll need to create it manually:"
        echo "1. Open Xcode"
        echo "2. Create a new iOS App project"
        echo "3. Name it 'BassUp'"
        echo "4. Choose your team and bundle identifier"
        echo "5. Save it in this directory"
    else
        print_success "Xcode project found"
    fi
}

# Create environment file template
create_env_template() {
    print_status "Creating environment file template..."
    
    cat > .env.template << 'EOF'
# Environment Configuration Template
# Copy this file to .env and fill in your values

# App Configuration
APP_BUNDLE_IDENTIFIER=com.yourcompany.bassup
APP_VERSION=1.0.0
APP_BUILD_NUMBER=1

# API Configuration
API_BASE_URL=https://api.bassup.com
API_KEY=your_api_key_here

# Firebase Configuration
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_PROJECT_ID=your_firebase_project_id

# Slack Configuration (for notifications)
SLACK_URL=https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK

# App Store Connect
APP_STORE_CONNECT_API_KEY_ID=your_api_key_id
APP_STORE_CONNECT_API_ISSUER_ID=your_issuer_id
APP_STORE_CONNECT_API_KEY_PATH=path/to/your/api_key.p8

# TestFlight
TESTFLIGHT_APP_ID=your_testflight_app_id
EOF
    
    print_success "Environment template created"
}

# Main setup function
main() {
    echo "=========================================="
    echo "BassUp iOS Development Environment Setup"
    echo "=========================================="
    echo ""
    
    check_xcode
    check_command_line_tools
    install_homebrew
    install_gems
    install_brew_packages
    setup_cocoapods
    setup_git_hooks
    setup_xcode_project
    create_env_template
    
    echo ""
    echo "=========================================="
    print_success "Setup completed successfully!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Create your Xcode project if it doesn't exist"
    echo "2. Copy .env.template to .env and configure your environment"
    echo "3. Open BassUp.xcworkspace in Xcode"
    echo "4. Build and run your project"
    echo ""
    echo "Useful commands:"
    echo "- fastlane test          # Run tests"
    echo "- fastlane lint          # Run SwiftLint"
    echo "- fastlane beta          # Deploy to TestFlight"
    echo "- fastlane release       # Deploy to App Store"
    echo ""
}

# Run main function
main "$@"
