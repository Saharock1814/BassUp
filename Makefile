# BassUp iOS Development Makefile
# Common commands for iOS development

.PHONY: help setup install test lint clean build archive beta release docs

# Default target
help:
	@echo "BassUp iOS Development Commands"
	@echo "================================"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  setup     - Run the complete setup script"
	@echo "  install   - Install CocoaPods dependencies"
	@echo ""
	@echo "Development:"
	@echo "  test      - Run unit tests"
	@echo "  ui-test   - Run UI tests"
	@echo "  lint      - Run SwiftLint"
	@echo "  build     - Build the project"
	@echo "  clean     - Clean build artifacts"
	@echo ""
	@echo "Deployment:"
	@echo "  archive   - Archive the app"
	@echo "  beta      - Deploy to TestFlight"
	@echo "  release   - Deploy to App Store"
	@echo ""
	@echo "Documentation:"
	@echo "  docs      - Generate documentation"
	@echo ""
	@echo "Git Workflow:"
	@echo "  feature   - Create a new feature branch"
	@echo "  release-branch - Create a new release branch"
	@echo "  merge-release - Merge release branch to main"

# Setup and installation
setup:
	@echo "🚀 Setting up BassUp iOS development environment..."
	@chmod +x scripts/setup.sh
	@./scripts/setup.sh

install:
	@echo "📦 Installing CocoaPods dependencies..."
	@pod install

# Testing
test:
	@echo "🧪 Running unit tests..."
	@fastlane test

ui-test:
	@echo "🎨 Running UI tests..."
	@fastlane ui_test

# Code quality
lint:
	@echo "🔍 Running SwiftLint..."
	@fastlane lint

# Building
build:
	@echo "🔨 Building project..."
	@fastlane build

clean:
	@echo "🧹 Cleaning build artifacts..."
	@fastlane clean

# Archiving
archive:
	@echo "📦 Archiving app..."
	@fastlane build

# Deployment
beta:
	@echo "🚀 Deploying to TestFlight..."
	@fastlane beta

release:
	@echo "🏪 Deploying to App Store..."
	@fastlane release

# Documentation
docs:
	@echo "📚 Generating documentation..."
	@fastlane docs

# Git workflow
feature:
	@echo "🌿 Creating feature branch..."
	@read -p "Enter feature name: " name; \
	fastlane feature name:$$name

release-branch:
	@echo "🏷️ Creating release branch..."
	@read -p "Enter version (e.g., 1.0.0): " version; \
	fastlane release_branch version:$$version

merge-release:
	@echo "🔄 Merging release branch..."
	@read -p "Enter version (e.g., 1.0.0): " version; \
	fastlane merge_release version:$$version

# Development helpers
open:
	@echo "📱 Opening Xcode workspace..."
	@open BassUp.xcworkspace

simulator:
	@echo "📱 Opening iOS Simulator..."
	@open -a Simulator

# Code formatting
format:
	@echo "🎨 Formatting code..."
	@swiftlint autocorrect

# Dependencies
update-pods:
	@echo "🔄 Updating CocoaPods dependencies..."
	@pod update

outdated-pods:
	@echo "📋 Checking for outdated pods..."
	@pod outdated

# Firebase
firebase-deploy:
	@echo "🔥 Deploying to Firebase App Distribution..."
	@fastlane firebase

# Environment
env-setup:
	@echo "⚙️ Setting up environment..."
	@if [ ! -f .env ]; then \
		cp .env.template .env; \
		echo "Created .env file from template. Please configure it with your values."; \
	else \
		echo ".env file already exists."; \
	fi

# Security
security-scan:
	@echo "🔒 Running security scan..."
	@if command -v xcodebuild &> /dev/null; then \
		xcodebuild -workspace BassUp.xcworkspace -scheme BassUp -configuration Release clean build | grep -i "warning\|error"; \
	else \
		echo "Xcode not found. Please install Xcode first."; \
	fi

# Performance
performance-test:
	@echo "⚡ Running performance tests..."
	@if [ -d "BassUpTests" ]; then \
		xcodebuild test -workspace BassUp.xcworkspace -scheme BassUp -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:BassUpTests/PerformanceTests | xcpretty; \
	else \
		echo "Performance tests not found."; \
	fi

# Backup
backup:
	@echo "💾 Creating backup..."
	@tar -czf "backup-$(date +%Y%m%d-%H%M%S).tar.gz" --exclude='.git' --exclude='Pods' --exclude='builds' --exclude='DerivedData' .

# Restore
restore:
	@echo "📥 Restoring from backup..."
	@if [ -z "$(BACKUP_FILE)" ]; then \
		echo "Please specify backup file: make restore BACKUP_FILE=backup-20231201-120000.tar.gz"; \
	else \
		tar -xzf "$(BACKUP_FILE)"; \
	fi

# Statistics
stats:
	@echo "📊 Project statistics..."
	@echo "Swift files: $$(find . -name "*.swift" -not -path "./Pods/*" | wc -l | tr -d ' ')"
	@echo "Lines of code: $$(find . -name "*.swift" -not -path "./Pods/*" -exec wc -l {} + | tail -1 | awk '{print $$1}')"
	@echo "Test files: $$(find . -name "*Tests.swift" -not -path "./Pods/*" | wc -l | tr -d ' ')"
	@echo "Dependencies: $$(grep -c "^  pod" Podfile || echo "0")"

# Quick development cycle
dev-cycle: clean install test lint build
	@echo "✅ Development cycle completed!"

# Full release cycle
release-cycle: clean install test lint build beta
	@echo "✅ Release cycle completed!"
