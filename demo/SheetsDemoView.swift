import SwiftUI

struct SheetsDemoView: View {
    @State private var showingSheet = false
    @State private var showingFullScreen = false
    @State private var showingConfirmation = false
    @State private var showingPopover = false
    #if IOS17
    @State private var showingInspector = false
    #endif
    @State private var selectedDetent: PresentationDetent = .medium

    var body: some View {
        List {
            Section {
                Button("Standard Sheet") {
                    showingSheet = true
                }

                Button("Full Screen Cover") {
                    showingFullScreen = true
                }
            } header: {
                Text("Sheets")
            } footer: {
                Text("iOS provides several modal presentation styles. Use modality sparingly — only when the user must complete or abandon a focused task.")
            }

            Section("Confirmation Dialog") {
                Button("Show Confirmation Dialog") {
                    showingConfirmation = true
                }
            }

            Section("Popover") {
                Button("Show Popover") {
                    showingPopover = true
                }
                .popover(isPresented: $showingPopover) {
                    VStack(spacing: 12) {
                        Text("Popover Content")
                            .font(.headline)
                        Text("Popovers are ideal for brief, contextual information on iPad. On iPhone they present as sheets.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .modifier(CompactPopoverAdaptation())
                }
            }

            #if IOS17
            Section("Inspector") {
                Button("Show Inspector") {
                    showingInspector = true
                }
            }
            #endif

            Section("Presentation Detents") {
                LabeledContent("Current Detent") {
                    Text(detentLabel)
                        .font(.caption)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Sheets & Modals")
        .sheet(isPresented: $showingSheet) {
            DemoSheetContent(title: "Sheet", description: "Sheets slide up from the bottom. Users can swipe down to dismiss. Use .presentationDetents to control height.")
                .presentationDetents([.medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showingFullScreen) {
            NavigationStack {
                List {
                    Section {
                        Text("Full Screen Cover")
                            .font(.headline)
                        Text("Full screen covers cannot be dismissed by swiping. Always provide a close button.")
                            .foregroundStyle(.secondary)
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Full Screen")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { showingFullScreen = false }
                    }
                }
            }
        }
        .confirmationDialog("Choose an Action", isPresented: $showingConfirmation, titleVisibility: .visible) {
            Button("Save") { }
            Button("Duplicate") { }
            Button("Delete", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Confirmation dialogs present a set of choices related to the current context.")
        }
        #if IOS17
        .inspector(isPresented: $showingInspector) {
            List {
                Section("Inspector") {
                    Text("Inspectors show supplementary content alongside the main view.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Section("Properties") {
                    LabeledContent("Width", value: "320pt")
                    LabeledContent("Position", value: "Trailing")
                }
            }
            .listStyle(.insetGrouped)
            .inspectorColumnWidth(min: 280, ideal: 320, max: 400)
        }
        #endif
    }

    private var detentLabel: String {
        switch selectedDetent {
        case .medium: return "Medium"
        case .large: return "Large"
        default: return "Custom"
        }
    }
}

// Popover compact adaptation is iOS 16.4+; degrade gracefully on the 16.0 floor.
private struct CompactPopoverAdaptation: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.4, *) {
            content.presentationCompactAdaptation(.popover)
        } else {
            content
        }
    }
}

private struct DemoSheetContent: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let description: String

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .foregroundStyle(.secondary)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SheetsDemoView()
    }
}
