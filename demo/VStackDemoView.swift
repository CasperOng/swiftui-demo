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
    @State private var alignment: HorizontalAlignment = .center
    @State private var showSpacingSlider = false
    
    // Add enum for picker
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
            VStack(spacing: 20) {
                // Controls
                VStack {
                    Toggle("Show Spacing Control", isOn: $showSpacingSlider)
                        .padding()
                    
                    if showSpacingSlider {
                        VStack {
                            Text("Spacing: \(Int(spacing))")
                            Slider(value: $spacing, in: 0...50, step: 1)
                        }
                        .padding()
                    }
                    
                    Picker("Alignment", selection: $selectedAlignment) {
                        ForEach(AlignmentOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onChange(of: selectedAlignment) { oldValue, newValue in
                        alignment = newValue.alignment
                    }
                }
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Demo Content
                VStack(alignment: alignment, spacing: spacing) {
                    // Header
                    Text("VStack Demo")
                        .font(.title)
                        .bold()
                    
                    // Description
                    Text("Vertical Stack Example")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Icons
                    HStack(spacing: 20) {
                        Image(systemName: "arrow.up.and.down")
                            .font(.title)
                        Image(systemName: "arrow.up.and.down.circle")
                            .font(.title)
                        Image(systemName: "arrow.up.and.down.circle.fill")
                            .font(.title)
                    }
                    .foregroundColor(.blue)
                    
                    // Sample Cards
                    ForEach(1...3, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Card \(index)")
                                .font(.headline)
                            Text("This is a sample card in the VStack. It demonstrates how content can be organized vertically.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // Footer
                    Text("Try adjusting the spacing and alignment!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("VStack Demo")
        .onChange(of: spacing) { oldValue, newValue in
            print("Spacing changed from \(oldValue) to \(newValue)")
        }
    }
}

#Preview {
    NavigationStack {
        VStackDemoView()
    }
} 