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
        ScrollView {
            VStack(spacing: 20) {
                // Controls
                VStack {
                    Group {
                        VStack {
                            Text("Blur: \(Int(blurRadius))")
                            Slider(value: $blurRadius, in: 0...20)
                        }
                        
                        VStack {
                            Text("Opacity: \(Int(opacity * 100))%")
                            Slider(value: $opacity, in: 0...1)
                        }
                        
                        VStack {
                            Text("Scale: \(String(format: "%.2f", scale))")
                            Slider(value: $scale, in: 0.5...2)
                        }
                        
                        VStack {
                            Text("Rotation: \(Int(rotation.degrees))°")
                            Slider(value: $rotation.degrees, in: -180...180)
                        }
                        
                        VStack {
                            Text("Shadow: \(Int(shadowRadius))")
                            Slider(value: $shadowRadius, in: 0...20)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                // Demo Content
                VStack(spacing: 20) {
                    // Shapes Demo
                    Group {
                        Text("Shapes")
                            .font(.title)
                            .bold()
                        
                        HStack(spacing: 20) {
                            Circle()
                                .fill(.blue)
                                .frame(width: 50, height: 50)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.green)
                                .frame(width: 50, height: 50)
                            
                            Capsule()
                                .fill(.orange)
                                .frame(width: 50, height: 30)
                            
                            Ellipse()
                                .fill(.purple)
                                .frame(width: 50, height: 30)
                        }
                    }
                    
                    // Gradients Demo
                    Group {
                        Text("Gradients")
                            .font(.title)
                            .bold()
                        
                        HStack(spacing: 20) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    RadialGradient(
                                        colors: [.yellow, .orange],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 50
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    AngularGradient(
                                        colors: [.red, .yellow, .green, .blue, .purple, .red],
                                        center: .center
                                    )
                                )
                                .frame(width: 100, height: 100)
                        }
                    }
                    
                    // Effects Demo
                    Group {
                        Text("Effects")
                            .font(.title)
                            .bold()
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.yellow)
                            .blur(radius: blurRadius)
                            .opacity(opacity)
                            .scaleEffect(scale)
                            .rotationEffect(rotation)
                            .shadow(radius: shadowRadius)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
        }
        .navigationTitle("Graphics & Effects")
    }
}

#Preview {
    NavigationStack {
        GraphicsEffectsDemoView()
    }
} 