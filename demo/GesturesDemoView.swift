import SwiftUI

// MagnifyGesture / RotateGesture are iOS 17+ renames of the older
// MagnificationGesture / RotationGesture (whose value types differ).
#if IOS17
private typealias PinchGesture = MagnifyGesture
private typealias TwistGesture = RotateGesture
#else
private typealias PinchGesture = MagnificationGesture
private typealias TwistGesture = RotationGesture
#endif

struct GesturesDemoView: View {
    @State private var dragOffset: CGSize = .zero
    @State private var magnification: CGFloat = 1.0
    @State private var rotationAngle: Angle = .zero
    @State private var tapCount = 0
    @State private var longPressActive = false
    @State private var lastGesture = "None"

    var body: some View {
        List {
            Section {
                LabeledContent("Last Gesture") {
                    Text(lastGesture)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Tap Gesture") {
                VStack(spacing: 12) {
                    Circle()
                        .fill(.tint)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("\(tapCount)")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        )
                        .onTapGesture {
                            tapCount += 1
                            lastGesture = "Single Tap"
                        }
                        .onTapGesture(count: 2) {
                            tapCount = 0
                            lastGesture = "Double Tap (reset)"
                        }
                        .accessibilityLabel("Tap counter: \(tapCount)")
                        .accessibilityHint("Tap to increment, double tap to reset")

                    Text("Tap to count, double-tap to reset")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Long Press") {
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(longPressActive ? Color.green : Color(.secondarySystemFill))
                        .frame(height: 80)
                        .overlay(
                            Text(longPressActive ? "Activated!" : "Press and hold")
                                .foregroundStyle(longPressActive ? .white : .secondary)
                        )
                        .onLongPressGesture(minimumDuration: 0.5) {
                            longPressActive = true
                            lastGesture = "Long Press"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                longPressActive = false
                            }
                        }
                        .accessibilityLabel("Long press target")
                        .accessibilityHint("Press and hold for half a second to activate")
                        #if IOS17
                        .sensoryFeedback(.impact, trigger: longPressActive)
                        #endif

                    Text("Hold for 0.5 seconds")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("Drag Gesture") {
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.orange.gradient)
                        .frame(width: 80, height: 80)
                        .offset(dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation
                                    lastGesture = "Dragging"
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        dragOffset = .zero
                                    }
                                    lastGesture = "Drag Ended"
                                }
                        )
                        .accessibilityLabel("Draggable square")
                        .accessibilityHint("Drag to move, releases back to center")

                    Text("Drag the square")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .padding(.vertical, 4)
            }

            Section("Magnification (Pinch)") {
                VStack(spacing: 12) {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.purple)
                        .scaleEffect(magnification)
                        .gesture(
                            PinchGesture()
                                .onChanged { value in
                                    #if IOS17
                                    magnification = value.magnification
                                    #else
                                    magnification = value
                                    #endif
                                    lastGesture = "Pinching"
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        magnification = 1.0
                                    }
                                    lastGesture = "Pinch Ended"
                                }
                        )
                        .accessibilityLabel("Pinchable image")

                    Text("Pinch to zoom (use two fingers)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Rotation") {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 50))
                        .foregroundStyle(.tint)
                        .rotationEffect(rotationAngle)
                        .gesture(
                            TwistGesture()
                                .onChanged { value in
                                    #if IOS17
                                    rotationAngle = value.rotation
                                    #else
                                    rotationAngle = value
                                    #endif
                                    lastGesture = "Rotating"
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        rotationAngle = .zero
                                    }
                                    lastGesture = "Rotation Ended"
                                }
                        )
                        .accessibilityLabel("Rotatable icon")

                    Text("Rotate with two fingers")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Gesture Guidelines") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Every custom gesture must have a visible alternative (button or menu)")
                    Text("• Never override system gestures (back swipe, Control Center)")
                    Text("• Provide visual hints for discoverable gestures")
                    Text("• Support assistive alternatives for complex gestures")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Gestures")
    }
}

#Preview {
    NavigationStack {
        GesturesDemoView()
    }
}
