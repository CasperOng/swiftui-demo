# CLAUDE.md

This file provides guidance to Claude (claude.ai/code) when working with code in this repository.

## Build & Run

**Build from command line (simulator):**
```bash
xcodebuild \
  -project demo.xcodeproj \
  -scheme demo \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  build
```

**Run tests:**
```bash
xcodebuild test \
  -project demo.xcodeproj \
  -scheme demo \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

**Run a single test class:**
```bash
xcodebuild test \
  -project demo.xcodeproj \
  -scheme demo \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:demoTests/demoTests
```

**Build unsigned IPA (as CI does):**
```bash
xcodebuild \
  -project demo.xcodeproj \
  -scheme demo \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/demo.xcarchive \
  archive \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" DEVELOPMENT_TEAM=""
```

**Requirements:** Xcode 16+, iOS 18+ target, macOS with iOS Simulator.

## Architecture

This is a **SwiftUI catalog/demo app** — a navigable list of self-contained feature screens. There is no backend, no networking, and no shared data model.

### Entry point & navigation
- `demoApp.swift` — `@main` App entry; gates the UI behind `AuthenticationView` using `@AppStorage("isAuthenticated")`
- `AuthenticationView.swift` — Full-screen Face ID / biometric prompt shown on launch
- `ContentView.swift` — Root `NavigationStack` with a sectioned `List` of `NavigationLink`s to every demo screen. Many entries are commented out as placeholders for future screens.

### Demo screens (one file each, flat structure)
Each `*DemoView.swift` in `demo/` is an independent, self-contained SwiftUI view:

| File | Topic |
|---|---|
| `VStackDemoView` / `HStackDemoView` / `ZStackDemoView` | Layout primitives |
| `ControlsDemoView` | Buttons, toggles, sliders, pickers |
| `AnimationsDemoView` | SwiftUI animation APIs |
| `ListsDemoView` | List, ForEach, swipe actions |
| `ChartsDemoView` | Swift Charts framework |
| `NotificationsDemoView` | `UNUserNotificationCenter` local notifications |
| `ShareSheetDemoView` | `UIActivityViewController` via `ShareLink` |
| `GraphicsEffectsDemoView` | Blur, visual effects, drawing |
| `StateDataFlowDemoView` | `@State`, `@Binding`, `@ObservableObject` patterns |
| `AccessibilityDemoView` | Accessibility modifiers, VoiceOver labels |
| `NavigationStackDemoView` | Navigation patterns (currently commented out in ContentView) |

### Extension targets
- `demoacc/` — Account Authentication Modification extension (UIKit, `.xib` + storyboard)
- `demoauth/` — Credential Provider extension (UIKit, `.xib`)
- These are separate Xcode targets and do not share code with the main SwiftUI app.

### Tests
- `demoTests/demoTests.swift` — Unit tests (XCTest)
- `demoUITests/demoUITests.swift` / `demoUITestsLaunchTests.swift` — UI tests (XCUITest)

## Adding a New Demo Screen

1. Create `demo/YourFeatureDemoView.swift` as a self-contained SwiftUI `View`.
2. Uncomment or add a `NavigationLink("Your Feature Demo", destination: YourFeatureDemoView())` in the appropriate section of `ContentView.swift`.

## CI / GitHub Actions

`.github/workflows/ios-build.yml` runs on every push to `main`:
- Archives the app unsigned (`CODE_SIGNING_ALLOWED=NO`)
- Uploads the IPA as a workflow artifact (30-day retention)
- Creates a GitHub pre-release tagged `prerelease-<run_number>`

The workflow uses `macos-15` runners with the latest stable Xcode.
