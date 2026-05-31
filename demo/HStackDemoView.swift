//
//  HStackDemoView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view demonstrates various HStack capabilities in SwiftUI.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

struct HStackDemoView: View {
    @State private var spacing: CGFloat = 10
    @State private var showSpacingSlider = false

    private enum AlignmentOption: String, CaseIterable {
        case top = "Top"
        case center = "Center"
        case bottom = "Bottom"

        var alignment: VerticalAlignment {
            switch self {
            case .top: return .top
            case .center: return .center
            case .bottom: return .bottom
            }
        }
    }

    @State private var selectedAlignment: AlignmentOption = .center

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Controls
                VStack(spacing: 16) {
                    Toggle("Show Spacing Control", isOn: $showSpacingSlider)

                    if showSpacingSlider {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Spacing: \(Int(spacing))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Slider(value: $spacing, in: 0...50, step: 1)
                        }
                    }

                    Picker("Alignment", selection: $selectedAlignment) {
                        ForEach(AlignmentOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                // Demo Content
                VStack(spacing: 24) {
                    Text("HStack Demo")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    Text("Horizontal Stack Example")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        Image(systemName: "arrow.left.and.right")
                            .font(.title2)
                        Image(systemName: "arrow.left.and.right.circle")
                            .font(.title2)
                        Image(systemName: "arrow.left.and.right.circle.fill")
                            .font(.title2)
                    }
                    .foregroundStyle(.tint)

                    ForEach(1...3, id: \.self) { index in
                        HStack(alignment: selectedAlignment.alignment, spacing: spacing) {
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .foregroundStyle(.yellow)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Card \(index)")
                                    .font(.headline)
                                Text("This is a sample card in the HStack. It demonstrates how content can be organized horizontally.")
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
                        .accessibilityLabel("Card \(index)")
                    }

                    Text("Try adjusting the spacing and alignment!")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("HStack")
    }
}

#Preview {
    NavigationStack {
        HStackDemoView()
    }
}
