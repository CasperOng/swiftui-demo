import SwiftUI

struct AnimationsDemoView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isAnimating = false
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        List {
            Section("Basic Animations") {
                VStack(spacing: 20) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.yellow)
                        .rotationEffect(.degrees(rotation))
                        .scaleEffect(scale)
                        .offset(x: offset)
                        .opacity(opacity)
                        .accessibilityLabel("Animated star")

                    Button("Animate") {
                        withAnimation(reduceMotion ? nil : .spring(response: 0.5, dampingFraction: 0.5)) {
                            rotation += 360
                            scale = scale == 1 ? 1.5 : 1
                            offset = offset == 0 ? 50 : 0
                            opacity = opacity == 1 ? 0.5 : 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            Section("Transition Animations") {
                VStack {
                    if isAnimating {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.tint)
                            .frame(height: 100)
                            .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
                    }

                    Button(isAnimating ? "Hide" : "Show") {
                        withAnimation(reduceMotion ? .none : .spring()) {
                            isAnimating.toggle()
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            Section("Gesture Animations") {
                VStack(spacing: 12) {
                    Circle()
                        .fill(.green.gradient)
                        .frame(width: 100, height: 100)
                        .scaleEffect(scale)
                        .gesture(
                            DragGesture()
                                .onChanged { _ in
                                    withAnimation(reduceMotion ? nil : .spring()) {
                                        scale = 1.2
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(reduceMotion ? nil : .spring()) {
                                        scale = 1
                                    }
                                }
                        )
                        .accessibilityLabel("Draggable circle")
                        .accessibilityHint("Drag to see scale animation")

                    Text("Drag to animate")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            Section {
                if reduceMotion {
                    Label("Reduce Motion is enabled. Animations are simplified.", systemImage: "accessibility")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Timeline Animations") {
                TimelineView(.animation(paused: reduceMotion)) { timeline in
                    Canvas { context, size in
                        let time = timeline.date.timeIntervalSinceReferenceDate
                        context.translateBy(x: size.width / 2, y: size.height / 2)
                        context.rotate(by: .degrees(time * 30))

                        let rect = CGRect(x: -20, y: -20, width: 40, height: 40)
                        context.fill(Path(ellipseIn: rect), with: .color(.blue))
                    }
                    .frame(height: 200)
                    .accessibilityLabel("Rotating ellipse animation")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Animations")
    }
}

#Preview {
    NavigationStack {
        AnimationsDemoView()
    }
}
