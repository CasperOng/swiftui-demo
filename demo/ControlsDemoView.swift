import SwiftUI

struct ControlsDemoView: View {
    @State private var toggleValue = false
    @State private var sliderValue = 50.0
    @State private var stepperValue = 1
    @State private var selectedDate = Date()
    @State private var selectedColor = Color.blue
    @State private var textInput = ""
    @State private var selectedOption = 0
    @State private var showingColorPicker = false

    let options = ["Option 1", "Option 2", "Option 3"]

    var body: some View {
        List {
            Section("Basic Controls") {
                Toggle("Toggle Switch", isOn: $toggleValue)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Slider: \(Int(sliderValue))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Slider(value: $sliderValue, in: 0...100)
                        .accessibilityLabel("Value slider")
                        .accessibilityValue("\(Int(sliderValue))")
                }

                Stepper("Counter: \(stepperValue)", value: $stepperValue, in: 1...10)
            }

            Section("Date & Time") {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
            }

            Section("Text Input") {
                TextField("Enter text", text: $textInput)
                    .textFieldStyle(.roundedBorder)

                TextEditor(text: $textInput)
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.separator), lineWidth: 0.5)
                    )
            }

            Section("Selection") {
                Picker("Select Option", selection: $selectedOption) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Text(options[index]).tag(index)
                    }
                }
                .pickerStyle(.menu)

                ColorPicker("Select Color", selection: $selectedColor)
            }

            Section("Buttons") {
                Button(action: {}) {
                    Label("Primary Button", systemImage: "star.fill")
                }
                .buttonStyle(.borderedProminent)

                Button(action: {}) {
                    Label("Secondary Button", systemImage: "star")
                }
                .buttonStyle(.bordered)

                Button(role: .destructive, action: {}) {
                    Label("Destructive Button", systemImage: "trash")
                }
            }

            Section("Progress Indicators") {
                ProgressView()
                    .accessibilityLabel("Loading")

                ProgressView(value: 0.7) {
                    Text("Progress")
                } currentValueLabel: {
                    Text("70%")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Controls Demo")
    }
}

#Preview {
    NavigationStack {
        ControlsDemoView()
    }
}
