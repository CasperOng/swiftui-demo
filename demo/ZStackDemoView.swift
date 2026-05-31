//
//  ZStackDemoView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view demonstrates various ZStack capabilities in SwiftUI.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

struct ZStackDemoView: View {
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0.0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Controls
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Offset: (\(Int(offset.width)), \(Int(offset.height)))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack {
                            Slider(value: $offset.width, in: -100...100, step: 1)
                            Slider(value: $offset.height, in: -100...100, step: 1)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Scale: \(String(format: "%.2f", scale))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Slider(value: $scale, in: 0.5...2.0, step: 0.1)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rotation: \(Int(rotation))°")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Slider(value: $rotation, in: 0...360, step: 1)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Demo Content
                VStack(spacing: 24) {
                    Text("ZStack Demo")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    Text("Layered Stack Example")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    // Interactive Demo
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 300, height: 300)

                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.green.opacity(0.3))
                            .frame(width: 200, height: 200)

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red.opacity(0.4))
                            .frame(width: 100, height: 100)
                            .offset(offset)
                            .scaleEffect(scale)
                            .rotationEffect(.degrees(rotation))
                    }
                    .frame(height: 300)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Interactive ZStack with three layered rectangles. Adjust controls to transform the top layer.")

                    ForEach(1...3, id: \.self) { index in
                        HStack {
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .foregroundStyle(.yellow)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Card \(index)")
                                    .font(.headline)
                                Text("This card demonstrates ZStack layering with a background and content.")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .accessibilityHidden(true)
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityElement(children: .combine)
                    }

                    Text("Try adjusting the offset, scale, and rotation!")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("ZStack")
    }
}

#Preview {
    NavigationStack {
        ZStackDemoView()
    }
}
