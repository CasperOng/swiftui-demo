//
//  VStackDemoView.swift
//  demo
//
//  Created by Casper Ong
//  Last Updated: April 16, 2025 01:53 UTC+8
//  Version: v1.0.0-alpha.1 (Initial Release)
//  Build: 2025.04.16.0153
//
//  This view demonstrates various VStack capabilities in SwiftUI.
//
//  Copyright © 2025 Casper Ong. All rights reserved.
//

import SwiftUI

struct VStackDemoView: View {
    @State private var spacing: CGFloat = 10
    @State private var showSpacingSlider = false

    private enum AlignmentOption: String, CaseIterable {
        case leading = "Leading"
        case center = "Center"
        case trailing = "Trailing"

        var alignment: HorizontalAlignment {
            switch self {
            case .leading: return .leading
            case .center: return .center
            case .trailing: return .trailing
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
                VStack(alignment: selectedAlignment.alignment, spacing: spacing) {
                    Text("VStack Demo")
                        .font(.headline)
                        .accessibilityAddTraits(.isHeader)

                    Text("Vertical Stack Example")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        Image(systemName: "arrow.up.and.down")
                            .font(.title2)
                        Image(systemName: "arrow.up.and.down.circle")
                            .font(.title2)
                        Image(systemName: "arrow.up.and.down.circle.fill")
                            .font(.title2)
                    }
                    .foregroundStyle(.tint)

                    ForEach(1...3, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Card \(index)")
                                .font(.headline)
                            Text("This is a sample card in the VStack. It demonstrates how content can be organized vertically.")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
        .navigationTitle("VStack Demo")
    }
}

#Preview {
    NavigationStack {
        VStackDemoView()
    }
}
