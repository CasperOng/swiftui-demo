//
//  GraphicsEffectsDemoView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view demonstrates various graphics and effects capabilities in SwiftUI.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

struct GraphicsEffectsDemoView: View {
    @State private var blurRadius: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var shadowRadius: CGFloat = 0

    var body: some View {
        List {
            Section("Controls") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Blur: \(Int(blurRadius))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $blurRadius, in: 0...20)
                        .accessibilityLabel("Blur radius")
                        .accessibilityValue("\(Int(blurRadius))")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Opacity: \(Int(opacity * 100))%")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $opacity, in: 0...1)
                        .accessibilityLabel("Opacity")
                        .accessibilityValue("\(Int(opacity * 100)) percent")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Scale: \(String(format: "%.2f", scale))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $scale, in: 0.5...2)
                        .accessibilityLabel("Scale")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Rotation: \(Int(rotation.degrees))°")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $rotation.degrees, in: -180...180)
                        .accessibilityLabel("Rotation")
                        .accessibilityValue("\(Int(rotation.degrees)) degrees")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Shadow: \(Int(shadowRadius))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $shadowRadius, in: 0...20)
                        .accessibilityLabel("Shadow radius")
                }
            }

            Section("Shapes") {
                HStack(spacing: 16) {
                    Circle()
                        .fill(.blue.gradient)
                        .frame(width: 50, height: 50)

                    RoundedRectangle(cornerRadius: 10)
                        .fill(.green.gradient)
                        .frame(width: 50, height: 50)

                    Capsule()
                        .fill(.orange.gradient)
                        .frame(width: 50, height: 30)

                    Ellipse()
                        .fill(.purple.gradient)
                        .frame(width: 50, height: 30)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Four shapes: circle, rounded rectangle, capsule, and ellipse")
            }

            Section("Gradients") {
                HStack(spacing: 16) {
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        Text("Linear")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                RadialGradient(
                                    colors: [.yellow, .orange],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 40
                                )
                            )
                            .frame(width: 80, height: 80)
                        Text("Radial")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                AngularGradient(
                                    colors: [.red, .yellow, .green, .blue, .purple, .red],
                                    center: .center
                                )
                            )
                            .frame(width: 80, height: 80)
                        Text("Angular")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("Effects Preview") {
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.yellow)
                    .blur(radius: blurRadius)
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .rotationEffect(rotation)
                    .shadow(color: .primary.opacity(0.3), radius: shadowRadius)
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .accessibilityLabel("Star with applied effects: blur \(Int(blurRadius)), opacity \(Int(opacity * 100))%, scale \(String(format: "%.1f", scale)), rotation \(Int(rotation.degrees)) degrees")
            }

            Section("Materials") {
                ZStack {
                    LinearGradient(colors: [.blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(spacing: 8) {
                        Text("Ultra Thin Material")
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("Regular Material")
                            .padding(8)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("Thick Material")
                            .padding(8)
                            .background(.thickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Graphics & Effects")
    }
}

#Preview {
    NavigationStack {
        GraphicsEffectsDemoView()
    }
}
