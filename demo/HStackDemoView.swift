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
    @State private var alignment: VerticalAlignment = .center
    @State private var showSpacingSlider = false
    
    // Add enum for picker
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
                VStack(spacing: 20) {
                    // Header
                    Text("HStack Demo")
                        .font(.title)
                        .bold()
                    
                    // Description
                    Text("Horizontal Stack Example")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Icons
                    HStack(spacing: 20) {
                        Image(systemName: "arrow.left.and.right")
                            .font(.title)
                        Image(systemName: "arrow.left.and.right.circle")
                            .font(.title)
                        Image(systemName: "arrow.left.and.right.circle.fill")
                            .font(.title)
                    }
                    .foregroundColor(.blue)
                    
                    // Sample Cards
                    ForEach(1...3, id: \.self) { index in
                        HStack(alignment: alignment, spacing: spacing) {
                            // Icon
                            Image(systemName: "star.fill")
                                .font(.title2)
                                .foregroundColor(.yellow)
                            
                            // Content
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Card \(index)")
                                    .font(.headline)
                                Text("This is a sample card in the HStack. It demonstrates how content can be organized horizontally.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Action Button
                            Button(action: {}) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
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
        .navigationTitle("HStack Demo")
        .onChange(of: spacing) { oldValue, newValue in
            print("Spacing changed from \(oldValue) to \(newValue)")
        }
    }
}

#Preview {
    NavigationStack {
        HStackDemoView()
    }
} 