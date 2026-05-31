import SwiftUI

// MARK: - onChange compatibility

// The two-parameter / zero-parameter `onChange(of:)` closures are iOS 17+.
// On the iOS 16 floor we fall back to the older `onChange(of:perform:)` form.
// This wrapper exposes a single new-value closure that works on every tier.
extension View {
    @ViewBuilder
    func compatOnChange<V: Equatable>(of value: V, perform action: @escaping (V) -> Void) -> some View {
        #if IOS17
        self.onChange(of: value) { _, newValue in action(newValue) }
        #else
        self.onChange(of: value, perform: action)
        #endif
    }
}
