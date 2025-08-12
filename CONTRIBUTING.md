# Contributing to BassUp

Thank you for your interest in contributing to BassUp! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Xcode 15.0+** (Latest stable version)
- **macOS 13.0+** (Ventura or later)
- **iOS 17.0+** as deployment target
- **Swift 5.9+**
- **Git** for version control

### Development Environment Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/BassUp.git
   cd BassUp
   ```

2. **Run the setup script**
   ```bash
   make setup
   ```
   This will install all necessary dependencies and configure your development environment.

3. **Install dependencies**
   ```bash
   make install
   ```

4. **Open the project in Xcode**
   ```bash
   make open
   ```

## 📋 Development Workflow

### Branch Strategy

We follow a feature branch workflow:

- `main` - Production-ready code
- `develop` - Integration branch for features
- `feature/*` - Feature development branches
- `release/*` - Release preparation branches
- `hotfix/*` - Critical bug fixes

### Creating a Feature

1. **Create a feature branch**
   ```bash
   make feature
   # Enter feature name when prompted
   ```

2. **Make your changes**
   - Follow the coding standards below
   - Write tests for new functionality
   - Update documentation as needed

3. **Run quality checks**
   ```bash
   make dev-cycle
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

5. **Push and create a pull request**
   ```bash
   git push origin feature/your-feature-name
   ```

### Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, etc.)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks

**Examples:**
```
feat(auth): add biometric authentication
fix(ui): resolve layout issues on iPhone SE
docs(readme): update installation instructions
test(network): add unit tests for API client
```

## 🎯 Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and use SwiftLint for automated enforcement.

#### Key Principles:

1. **Naming**
   - Use clear, descriptive names
   - Follow Swift naming conventions
   - Use camelCase for variables and functions
   - Use PascalCase for types

2. **Code Organization**
   - Group related functionality together
   - Use extensions to organize code
   - Keep files under 500 lines
   - Use MARK comments for organization

3. **Documentation**
   - Document all public APIs
   - Use Swift documentation comments
   - Include usage examples

#### Example:

```swift
/// A service for handling user authentication.
///
/// This service provides methods for user login, logout, and session management.
/// It supports both traditional username/password and biometric authentication.
///
/// ## Usage
/// ```swift
/// let authService = AuthenticationService()
/// try await authService.login(username: "user", password: "pass")
/// ```
public class AuthenticationService {
    
    // MARK: - Properties
    
    private let networkClient: NetworkClient
    private let keychainService: KeychainService
    
    // MARK: - Initialization
    
    public init(networkClient: NetworkClient = .shared,
                keychainService: KeychainService = .shared) {
        self.networkClient = networkClient
        self.keychainService = keychainService
    }
    
    // MARK: - Public Methods
    
    /// Authenticates a user with username and password.
    ///
    /// - Parameters:
    ///   - username: The user's username
    ///   - password: The user's password
    /// - Returns: An authentication token
    /// - Throws: `AuthenticationError` if login fails
    public func login(username: String, password: String) async throws -> String {
        // Implementation
    }
}
```

### Architecture

We follow the **MVVM (Model-View-ViewModel)** architecture pattern:

- **Models** - Data structures and business logic
- **Views** - UI components (SwiftUI)
- **ViewModels** - Presentation logic and state management
- **Services** - External dependencies and API calls

### Testing

#### Test Structure

- **Unit Tests** - Test individual components in isolation
- **Integration Tests** - Test component interactions
- **UI Tests** - Test user interface flows

#### Testing Guidelines

1. **Test Coverage**
   - Aim for 80%+ code coverage
   - Test all public APIs
   - Test error conditions

2. **Test Naming**
   ```swift
   func test_whenUserLogsInWithValidCredentials_thenAuthenticationSucceeds()
   func test_whenUserLogsInWithInvalidCredentials_thenAuthenticationFails()
   ```

3. **Test Organization**
   ```swift
   class AuthenticationServiceTests: XCTestCase {
       
       // MARK: - Properties
       
       private var sut: AuthenticationService!
       private var mockNetworkClient: MockNetworkClient!
       
       // MARK: - Setup & Teardown
       
       override func setUp() {
           super.setUp()
           mockNetworkClient = MockNetworkClient()
           sut = AuthenticationService(networkClient: mockNetworkClient)
       }
       
       override func tearDown() {
           sut = nil
           mockNetworkClient = nil
           super.tearDown()
       }
       
       // MARK: - Tests
       
       func test_whenUserLogsInWithValidCredentials_thenAuthenticationSucceeds() {
           // Given
           let username = "testuser"
           let password = "testpass"
           
           // When
           // Then
       }
   }
   ```

## 🔧 Development Tools

### Available Commands

```bash
# Setup and installation
make setup          # Complete environment setup
make install        # Install dependencies

# Development
make test           # Run unit tests
make ui-test        # Run UI tests
make lint           # Run SwiftLint
make build          # Build project
make clean          # Clean build artifacts

# Deployment
make beta           # Deploy to TestFlight
make release        # Deploy to App Store

# Git workflow
make feature        # Create feature branch
make release-branch # Create release branch
make merge-release  # Merge release branch

# Utilities
make open           # Open Xcode workspace
make format         # Format code
make stats          # Project statistics
```

### Code Quality Tools

- **SwiftLint** - Code style enforcement
- **Fastlane** - Automation and deployment
- **CocoaPods** - Dependency management
- **Git hooks** - Pre-commit quality checks

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Environment**
   - iOS version
   - Device model
   - App version
   - Xcode version

2. **Steps to reproduce**
   - Clear, step-by-step instructions
   - Expected vs actual behavior

3. **Additional information**
   - Screenshots or screen recordings
   - Console logs
   - Crash reports

## 💡 Feature Requests

When requesting features:

1. **Describe the problem**
   - What issue does this solve?
   - Who would benefit from this?

2. **Propose a solution**
   - How should this work?
   - Any design considerations?

3. **Consider alternatives**
   - Are there existing solutions?
   - What are the trade-offs?

## 📝 Pull Request Guidelines

### Before Submitting

1. **Run quality checks**
   ```bash
   make dev-cycle
   ```

2. **Update documentation**
   - Update README if needed
   - Add inline documentation
   - Update API documentation

3. **Test thoroughly**
   - Run all tests
   - Test on different devices
   - Test edge cases

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] UI tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

## 🏷️ Release Process

### Creating a Release

1. **Create release branch**
   ```bash
   make release-branch
   # Enter version when prompted
   ```

2. **Prepare release**
   - Update version numbers
   - Update changelog
   - Final testing

3. **Deploy**
   ```bash
   make release
   ```

4. **Merge to main**
   ```bash
   make merge-release
   ```

## 📞 Getting Help

- **Issues** - Use GitHub issues for bugs and feature requests
- **Discussions** - Use GitHub discussions for questions and ideas
- **Documentation** - Check the README and inline documentation

## 📄 License

By contributing to BassUp, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to BassUp! 🎉
