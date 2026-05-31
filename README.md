# SwiftUI Demo

A SwiftUI sample app that demonstrates common Apple UI and platform features in one place. The app is organized as a navigable catalog of demos, including layout, controls, animation, charts, notifications, sharing, state handling, accessibility, and graphics effects.

## Features

- Face ID / biometric authentication flow
- SwiftUI layout demos for `VStack`, `HStack`, and `ZStack`
- Controls and animations examples
- Lists and charts examples
- Notifications and share sheet integration
- Graphics and effects demos with blur and visual treatments
- State and data flow examples
- Accessibility demo screens

## Requirements

- Xcode 16 or newer
- iOS 18 or newer
- A Mac running macOS with the iOS simulator installed

## Project Structure

- `demo/` - Main SwiftUI app source
- `demoTests/` - Unit tests
- `demoUITests/` - UI tests
- `demo.xcodeproj/` - Xcode project

## Run Locally

1. Open `demo.xcodeproj` in Xcode.
2. Select the `demo` scheme.
3. Choose an iPhone simulator.
4. Build and run.

You can also build from the command line:

```bash
xcodebuild \
  -project demo.xcodeproj \
  -scheme demo \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  build
```

## GitHub Actions

This project includes a workflow at `.github/workflows/ios-build.yml` that runs on every push and performs a simulator build on GitHub-hosted macOS runners.

## Notes

- The app uses Face ID strings defined in `demo/demo-Info.plist`.
- Some demo screens are commented out in `ContentView.swift` and can be enabled as the project grows.

## License

This project currently does not include a license file in this folder.