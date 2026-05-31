# Implementation Plan: HIG Compliance + Full Apple UI Design Kit Catalog

## Part 1 — Fix HIG Issues in Existing Views

### 1.1 Global / App-level fixes
- **`demoApp.swift`**: Add `.tint(.blue)` (single accent color, Rule 4.7). Remove deprecated `if #available(iOS 15.0, *)` guard (deployment target is iOS 18). Use `@Environment(\.scenePhase)` properly on the WindowGroup level.
- **`ContentView.swift`**: Add `.navigationBarTitleDisplayMode(.large)` (Rule 2.3). Replace hardcoded `Color.blue.opacity(...)` backgrounds with semantic colors (`Color(.secondarySystemBackground)`). Add accessibility labels to the Face ID button. Use `.listStyle(.insetGrouped)` explicitly (Rule 7.4).
- **`AuthenticationView.swift`**: Replace hardcoded colors (`.orange`, `.blue`) with semantic system colors. Add `.frame(minWidth: 44, minHeight: 44)` to the logo tap target. Add accessibility labels to the hidden skip mechanism. Replace `.cornerRadius()` (deprecated) with `.clipShape(RoundedRectangle(...))`.

### 1.2 Per-view fixes (common patterns across all demo views)
| Issue | Affected Views | Fix |
|-------|---------------|-----|
| `.foregroundColor()` deprecated | All | Replace with `.foregroundStyle()` |
| `.cornerRadius()` deprecated | VStack, HStack, ZStack, Auth, Accessibility, Graphics, StateDataFlow | Replace with `.clipShape(RoundedRectangle(cornerRadius:))` |
| Hardcoded `Color.blue.opacity(0.1)` backgrounds | VStack, HStack, ZStack, Accessibility | Use `Color(.secondarySystemBackground)` |
| Hardcoded `Color.gray.opacity(0.1)` | VStack, HStack, ZStack, Graphics | Use `Color(.tertiarySystemGroupedBackground)` |
| Missing accessibility labels on icon-only buttons | HStack, ZStack (chevron.right buttons) | Add `.accessibilityLabel("More details")` |
| Small touch targets on icon-only buttons | HStack, ZStack | Add `.frame(minWidth: 44, minHeight: 44)` |
| `AnimationsDemoView` — no Reduce Motion support | Animations | Wrap animations with `@Environment(\.accessibilityReduceMotion)` check |
| `ShareSheetDemoView` — uses deprecated `UIImagePickerController` | ShareSheet | Replace with `PhotosUI.PhotosPicker` |
| `ShareSheetDemoView` — uses deprecated `presentationMode` | ShareSheet | Replace with `@Environment(\.dismiss)` |
| `StateDataFlowDemoView` — uses deprecated `.navigationBarItems` | StateDataFlow | Replace with `.toolbar { ToolbarItem(...) }` |
| `NavigationStackDemoView` — uses deprecated `.navigationBarTrailing` | NavigationStack | Replace with `.topBarTrailing` |

### 1.3 Dark Mode audit
- Ensure no hardcoded white/black colors exist
- Verify all custom backgrounds use semantic colors that adapt

---

## Part 2 — New Apple UI Design Kit Demo Views

Each new file goes in `demo/` and is automatically picked up by the synchronized file group. All new views will be wired into `ContentView.swift` via NavigationLinks.

### New Sections & Views:

**Navigation & Presentation**
1. `TabViewDemoView.swift` — Tab bar patterns, badges, SF Symbol filled/outline states
2. `SheetsDemoView.swift` — `.sheet`, `.fullScreenCover`, `.presentationDetents`, `.inspector`
3. `MenusDemoView.swift` — Context menus, pull-down menus, `Menu` button, picker menus

**Input & Forms**
4. `FormsDemoView.swift` — `Form`, `LabeledContent`, validation patterns, grouped sections
5. `SearchableDemoView.swift` — `.searchable`, search suggestions, search scopes, tokens

**Data & Media**
6. `PhotosPickerDemoView.swift` — `PhotosPicker` (PhotosUI), `TransferableRepresentation`
7. `MapKitDemoView.swift` — `Map`, annotations, `MapCamera`, look-around preview

**Visual Design**
8. `TypographyDemoView.swift` — All 13 built-in text styles, Dynamic Type scaling demo, custom font scaling
9. `ColorSystemDemoView.swift` — All semantic colors, background hierarchy, accent color, P3 gamut, dark/light comparison
10. `SFSymbolsDemoView.swift` — Rendering modes (monochrome, hierarchical, palette, multicolor), weight matching, symbol effects/animations, variable value, search

**Feedback & Interaction**
11. `HapticsDemoView.swift` — `UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator`, `UISelectionFeedbackGenerator` with live triggers
12. `GesturesDemoView.swift` — Tap, long press, drag, magnification, rotation gestures with visual feedback

**System Integration**
13. `WidgetPreviewDemoView.swift` — Shows widget design patterns (static preview since widgets need a separate target)
14. `AppIntentsDemoView.swift` — App Intents / Shortcuts integration patterns
15. `LiveActivityDemoView.swift` — Live Activity / Dynamic Island layout patterns (preview)

**Layout**
16. `GridDemoView.swift` — `LazyVGrid`, `LazyHGrid`, adaptive columns, `ViewThatFits`
17. `ScrollViewDemoView.swift` — `ScrollView`, scroll position, paging, content margins, safe area handling

**Progress & Status**
18. `ProgressGaugeDemoView.swift` — `ProgressView` styles, `Gauge`, circular/linear variants

**Accessibility (expanded)**
19. `DynamicTypeDemoView.swift` — Live preview of all accessibility sizes, layout reflow with `ViewThatFits`

---

## Part 3 — Update ContentView.swift

Reorganize the navigation list into HIG-aligned sections:
- **Authentication** (existing)
- **Layout & Stacks** (VStack, HStack, ZStack, Grid, ScrollView)
- **Navigation & Presentation** (NavigationStack, TabView, Sheets, Menus)
- **Controls & Input** (Controls, Forms, Searchable)
- **Data & Media** (Lists, Charts, PhotosPicker, MapKit)
- **Visual Design** (Typography, Color System, SF Symbols, Graphics & Effects)
- **Animation & Feedback** (Animations, Gestures, Haptics)
- **System Integration** (Notifications, Share Sheet, Widgets, App Intents, Live Activities)
- **Accessibility** (Accessibility, Dynamic Type)
- **State & Data Flow** (existing, cleaned up)

---

## Part 4 — Multi-Version IPA Builds in GitHub Actions

**Goal:** Change `.github/workflows/ios-build.yml` so that a single workflow run produces **three** unsigned IPAs from the same source tree, one per minimum-iOS tier:

| IPA | Minimum iOS (`IPHONEOS_DEPLOYMENT_TARGET`) | Active compilation flag |
|-----|--------------------------------------------|-------------------------|
| `demo-unsigned-iOS18.ipa` | `18.0` | `IOS18` |
| `demo-unsigned-iOS17.ipa` | `17.0` | `IOS17` |
| `demo-unsigned-iOS16.ipa` | `16.0` | `IOS16` |

The iOS 17 and iOS 16 builds must **omit any feature whose API is not available on that minimum version**, so each IPA compiles and installs cleanly on its target OS floor.

### 4.1 Build matrix in the workflow
- Convert the `build` job to use a `strategy.matrix` over the three tiers. Each matrix entry defines:
  - `min_version` (`18.0` / `17.0` / `16.0`)
  - `flag` (`IOS18` / `IOS17` / `IOS16`)
  - `ipa_name` (`demo-unsigned-iOS18.ipa`, etc.)
- In the **Archive App** step, pass both the deployment-target override and the matching compilation condition to `xcodebuild`:
  ```bash
  IPHONEOS_DEPLOYMENT_TARGET=${{ matrix.min_version }} \
  SWIFT_ACTIVE_COMPILATION_CONDITIONS="$SWIFT_ACTIVE_COMPILATION_CONDITIONS ${{ matrix.flag }}"
  ```
  (Keep the existing `CODE_SIGNING_ALLOWED=NO` / `CODE_SIGN_IDENTITY=""` / `DEVELOPMENT_TEAM=""` overrides.)
- Make every per-tier output path unique (archive path, Payload dir, IPA name, log name) so the three matrix legs don't clobber each other.
- Upload each IPA as its own artifact named after the tier (`demo-unsigned-ipa-iOS18`, `-iOS17`, `-iOS16`). The lowest tier still gets archived; keep the existing 30-day / 7-day retention split.

### 4.2 Update the release job
- The `release` job must download **all three** IPA artifacts and attach all of them to the single GitHub pre-release (`prerelease-<run_number>`).
- Use `download-artifact` with a pattern/`merge-multiple` so every tier's IPA lands in `./release/`, then list all three under `files:` in `softprops/action-gh-release`.

### 4.3 Feature omission via compilation conditions
For each new and existing view, **wrap version-gated features** so they disappear when their flag is absent. Pattern:

```swift
// Available iOS 18+ only — excluded from the iOS 17 / iOS 16 IPAs
#if IOS18
// symbol effects, mesh gradients, ScrollPosition, etc.
#endif
```

- In `ContentView.swift`, wrap each `NavigationLink` to a version-gated screen in the matching `#if`, so screens that can't compile on a lower floor are simply not listed (and not built) for that IPA.
- Where a feature is only *partially* unavailable, prefer the `#if` flag to fully omit it rather than leaving a broken/empty screen.
- Keep using runtime `if #available(...)` only for in-range graceful degradation; use the `#if IOSxx` flags for hard omission of whole features/screens.

### 4.4 Feature → minimum-version map (omit when below the floor)
Anything listed here must be `#if`-gated out of the IPAs that don't meet its minimum:

| Feature / API | Min iOS | Built in | Omitted from |
|---------------|--------:|----------|--------------|
| Symbol effects (`.symbolEffect`, variable value), mesh gradients, `ScrollPosition`/scroll-position APIs | 18.0 | iOS18 | iOS17, iOS16 |
| `.inspector`, `MapKit` `Map` w/ `MapCamera` + look-around, `.searchable` scopes/tokens, App Intents view patterns | 17.0 | iOS18, iOS17 | iOS16 |
| `presentationDetents`, `PhotosPicker`/`Transferable`, `Gauge`, Live Activity / Dynamic Island previews | 16.0+ | all three | none (baseline) |

> Reconfirm each API's true minimum against current docs while implementing — the table is the starting contract, not the final word. If a screen has no supportable subset on a given floor, omit the whole screen for that tier.

---

## Execution Order

1. Fix all HIG issues in existing views (Part 1)
2. Create new demo views in batches (Part 2)
3. Rewrite `ContentView.swift` with the full catalog (Part 3)
4. Add `#if IOS18 / IOS17 / IOS16` gates around version-specific features and their NavigationLinks (Part 4.3 / 4.4)
5. Rework `.github/workflows/ios-build.yml` into the 3-tier build matrix and multi-IPA release (Part 4.1 / 4.2)
6. Build and verify compilation **for each tier** (set the deployment target + flag locally and archive once per tier before pushing)

---

## Notes
- iOS 18 build can use all latest APIs (symbol effects, `presentationDetents`, `ScrollPosition`, etc.); the iOS 17 and iOS 16 builds drop whatever exceeds their floor via the `#if IOSxx` flags from Part 4.
- The single source tree produces all three IPAs — there are no separate branches or targets; the difference is only the deployment target + active compilation condition passed by the matrix.
- Project uses `PBXFileSystemSynchronizedRootGroup` — no pbxproj edits needed for new files
- All views will use semantic colors, proper text styles, 44pt touch targets, accessibility labels, and Reduce Motion support by default
