# This file contains the fastlane.tools configuration
# You can find the documentation at https://docs.fastlane.tools
#
# For a list of all available actions, check out
#
#     https://docs.fastlane.tools/actions
#
# For a list of all available plugins, check out
#
#     https://docs.fastlane.tools/plugins/available-plugins
#

# Uncomment the line if you want fastlane to automatically update itself
# update_fastlane

default_platform(:ios)

platform :ios do
  desc "Push a new beta build to TestFlight"
  lane :beta do
    setup_ci if is_ci
    
    # Ensure we're on the right branch
    ensure_git_branch(branch: 'develop')
    
    # Increment build number
    increment_build_number(
      build_number: latest_testflight_build_number + 1,
      xcodeproj: "BassUp.xcodeproj"
    )
    
    # Update version if needed
    # increment_version_number(
    #   version_number: '1.0.0',
    #   xcodeproj: "BassUp.xcodeproj"
    # )
    
    # Run tests
    run_tests(
      scheme: "BassUp",
      device: "iPhone 15 Pro",
      clean: true,
      code_coverage: true
    )
    
    # Build the app
    build_ios_app(
      scheme: "BassUp",
      export_method: "app-store",
      configuration: "Release",
      clean: true,
      output_directory: "builds",
      output_name: "BassUp.ipa"
    )
    
    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true,
      skip_submission: true,
      reject_if_possible: true
    )
    
    # Notify team
    slack(
      message: "Successfully uploaded a new build to TestFlight",
      slack_url: ENV["SLACK_URL"],
      channel: "#ios-releases",
      success: true
    )
  end

  desc "Push a new release build to the App Store"
  lane :release do
    setup_ci if is_ci
    
    # Ensure we're on the right branch
    ensure_git_branch(branch: 'main')
    
    # Increment version and build number
    increment_version_number(
      version_number: '1.0.0',
      xcodeproj: "BassUp.xcodeproj"
    )
    
    increment_build_number(
      build_number: latest_testflight_build_number + 1,
      xcodeproj: "BassUp.xcodeproj"
    )
    
    # Run tests
    run_tests(
      scheme: "BassUp",
      device: "iPhone 15 Pro",
      clean: true,
      code_coverage: true
    )
    
    # Build the app
    build_ios_app(
      scheme: "BassUp",
      export_method: "app-store",
      configuration: "Release",
      clean: true,
      output_directory: "builds",
      output_name: "BassUp.ipa"
    )
    
    # Upload to App Store
    upload_to_app_store(
      skip_metadata: false,
      skip_screenshots: false,
      submit_for_review: false,
      automatic_release: false,
      force: true
    )
    
    # Create git tag
    add_git_tag(
      tag: "v#{get_version_number(xcodeproj: 'BassUp.xcodeproj')}"
    )
    
    push_git_tags
    
    # Notify team
    slack(
      message: "Successfully uploaded a new release to App Store Connect",
      slack_url: ENV["SLACK_URL"],
      channel: "#ios-releases",
      success: true
    )
  end

  desc "Run tests"
  lane :test do
    setup_ci if is_ci
    
    run_tests(
      scheme: "BassUp",
      device: "iPhone 15 Pro",
      clean: true,
      code_coverage: true,
      output_directory: "test_output",
      output_style: "raw"
    )
    
    # Generate coverage report
    xccov(
      action: "view",
      scheme: "BassUp",
      output_directory: "coverage"
    )
  end

  desc "Run UI tests"
  lane :ui_test do
    setup_ci if is_ci
    
    run_tests(
      scheme: "BassUpUITests",
      device: "iPhone 15 Pro",
      clean: true,
      only_testing: ["BassUpUITests"]
    )
  end

  desc "Build and archive the app"
  lane :build do
    setup_ci if is_ci
    
    build_ios_app(
      scheme: "BassUp",
      export_method: "development",
      configuration: "Debug",
      clean: true,
      output_directory: "builds",
      output_name: "BassUp.ipa"
    )
  end

  desc "Setup CI environment"
  lane :setup_ci do
    # Install dependencies
    cocoapods
    
    # Install certificates
    sync_code_signing(
      type: "appstore",
      readonly: true
    )
  end

  desc "Code quality checks"
  lane :lint do
    swiftlint(
      mode: :lint,
      config_file: ".swiftlint.yml",
      output_file: "swiftlint-report.xml",
      reporter: "junit"
    )
  end

  desc "Generate documentation"
  lane :docs do
    # Generate documentation using jazzy
    # jazzy(
    #   scheme: "BassUp",
    #   output: "docs"
    # )
  end

  desc "Clean build artifacts"
  lane :clean do
    clean_build_artifacts
    clear_derived_data
  end

  desc "Setup development environment"
  lane :setup do
    # Install CocoaPods dependencies
    cocoapods
    
    # Install SwiftLint
    sh("brew install swiftlint")
    
    # Install Fastlane
    sh("sudo gem install fastlane")
    
    # Setup git hooks
    # sh("cp scripts/pre-commit .git/hooks/")
    # sh("chmod +x .git/hooks/pre-commit")
  end

  desc "Deploy to Firebase App Distribution"
  lane :firebase do
    setup_ci if is_ci
    
    # Build the app
    build_ios_app(
      scheme: "BassUp",
      export_method: "ad-hoc",
      configuration: "Release",
      clean: true,
      output_directory: "builds",
      output_name: "BassUp.ipa"
    )
    
    # Upload to Firebase App Distribution
    firebase_app_distribution(
      app: ENV["FIREBASE_APP_ID"],
      ipa_path: "builds/BassUp.ipa",
      groups: "testers",
      release_notes: "New beta build"
    )
  end

  desc "Create a new feature branch"
  lane :feature do |options|
    branch_name = options[:name]
    UI.user_error!("Please provide a branch name: fastlane feature name:branch_name") unless branch_name
    
    sh("git checkout -b feature/#{branch_name}")
    sh("git push -u origin feature/#{branch_name}")
  end

  desc "Create a new release branch"
  lane :release_branch do |options|
    version = options[:version]
    UI.user_error!("Please provide a version: fastlane release_branch version:1.0.0") unless version
    
    sh("git checkout -b release/v#{version}")
    sh("git push -u origin release/v#{version}")
  end

  desc "Merge release branch to main"
  lane :merge_release do |options|
    version = options[:version]
    UI.user_error!("Please provide a version: fastlane merge_release version:1.0.0") unless version
    
    sh("git checkout main")
    sh("git pull origin main")
    sh("git merge release/v#{version}")
    sh("git push origin main")
    sh("git branch -d release/v#{version}")
    sh("git push origin --delete release/v#{version}")
  end

  # Error handling
  error do |lane, exception, options|
    # Notify team about the error
    slack(
      message: "Fastlane lane '#{lane}' failed: #{exception.message}",
      slack_url: ENV["SLACK_URL"],
      channel: "#ios-releases",
      success: false
    )
  end
end
