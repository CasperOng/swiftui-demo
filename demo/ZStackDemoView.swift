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
            VStack(spacing: 20) {
                // Controls
                VStack {
                    // Offset Control
                    VStack {
                        Text("Offset: (\(Int(offset.width)), \(Int(offset.height)))")
                        HStack {
                            Slider(value: $offset.width, in: -100...100, step: 1)
                            Slider(value: $offset.height, in: -100...100, step: 1)
                        }
                    }
                    .padding()
                    
                    // Scale Control
                    VStack {
                        Text("Scale: \(String(format: "%.2f", scale))")
                        Slider(value: $scale, in: 0.5...2.0, step: 0.1)
                    }
                    .padding()
                    
                    // Rotation Control
                    VStack {
                        Text("Rotation: \(Int(rotation))°")
                        Slider(value: $rotation, in: 0...360, step: 1)
                    }
                    .padding()
                }
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Demo Content
                VStack(spacing: 20) {
                    // Header
                    Text("ZStack Demo")
                        .font(.title)
                        .bold()
                    
                    // Description
                    Text("Layered Stack Example")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Interactive Demo
                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 300, height: 300)
                        
                        // Middle Layer
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.green.opacity(0.3))
                            .frame(width: 200, height: 200)
                        
                        // Foreground
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.red.opacity(0.4))
                            .frame(width: 100, height: 100)
                            .offset(offset)
                            .scaleEffect(scale)
                            .rotationEffect(.degrees(rotation))
                    }
                    .frame(height: 300)
                    
                    // Sample Cards
                    ForEach(1...3, id: \.self) { index in
                        ZStack {
                            // Background
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.1))
                            
                            // Content
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.title2)
                                    .foregroundColor(.yellow)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Card \(index)")
                                        .font(.headline)
                                    Text("This card demonstrates ZStack layering with a background and content.")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                        }
                    }
                    
                    // Footer
                    Text("Try adjusting the offset, scale, and rotation!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("ZStack Demo")
    }
}

#Preview {
    NavigationStack {
        ZStackDemoView()
    }
} 