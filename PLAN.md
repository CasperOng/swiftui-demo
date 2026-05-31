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

## Execution Order

1. Fix all HIG issues in existing views (Part 1)
2. Create new demo views in batches (Part 2)
3. Rewrite `ContentView.swift` with the full catalog (Part 3)
4. Build and verify compilation

---

## Notes
- iOS 18 deployment target means we can use all latest APIs (symbol effects, `presentationDetents`, `ScrollPosition`, etc.)
- Project uses `PBXFileSystemSynchronizedRootGroup` — no pbxproj edits needed for new files
- All views will use semantic colors, proper text styles, 44pt touch targets, accessibility labels, and Reduce Motion support by default
