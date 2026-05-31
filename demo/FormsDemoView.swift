import SwiftUI

struct FormsDemoView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var agreeToTerms = false
    @State private var notificationsEnabled = true
    @State private var selectedPlan = "Free"
    @State private var birthDate = Date()
    @State private var bio = ""
    @State private var showingValidation = false

    let plans = ["Free", "Pro", "Enterprise"]

    private var isEmailValid: Bool {
        email.isEmpty || email.contains("@")
    }

    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && isEmailValid && !password.isEmpty && password.count >= 8 && agreeToTerms
    }

    var body: some View {
        Form {
            Section {
                Text("Forms use the grouped inset style by default. Each section groups related controls with an optional header and footer.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Personal Information") {
                TextField("Full Name", text: $name)
                    .textContentType(.name)
                    .autocorrectionDisabled()

                TextField("Email Address", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                if !isEmailValid {
                    Label("Please enter a valid email address", systemImage: "exclamationmark.triangle")
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                SecureField("Password (8+ characters)", text: $password)
                    .textContentType(.newPassword)

                DatePicker("Date of Birth", selection: $birthDate, displayedComponents: .date)
            }

            Section("About") {
                TextField("Bio", text: $bio, axis: .vertical)
                    .lineLimit(3...6)
            }

            Section("Preferences") {
                Picker("Plan", selection: $selectedPlan) {
                    ForEach(plans, id: \.self) { plan in
                        Text(plan).tag(plan)
                    }
                }

                Toggle("Push Notifications", isOn: $notificationsEnabled)

                LabeledContent("Account Type") {
                    Text(selectedPlan)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Toggle("I agree to the Terms of Service", isOn: $agreeToTerms)
            } footer: {
                Text("You must agree to the terms before creating an account.")
            }

            Section {
                Button {
                    showingValidation = true
                } label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Forms")
        .alert("Form Submitted", isPresented: $showingValidation) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Account for \(name) would be created with the \(selectedPlan) plan.")
        }
    }
}

#Preview {
    NavigationStack {
        FormsDemoView()
    }
}
