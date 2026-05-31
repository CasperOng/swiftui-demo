import SwiftUI
import PhotosUI

struct ShareSheetDemoView: View {
    @State private var selectedText = "This is some sample text to share"
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var selectedUIImage: UIImage?

    var body: some View {
        List {
            Section("Share Text") {
                TextEditor(text: $selectedText)
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                ShareLink(item: selectedText) {
                    Label("Share Text", systemImage: "square.and.arrow.up")
                }
            }

            Section("Share Image") {
                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .accessibilityLabel("Selected photo")
                }

                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Select Photo", systemImage: "photo.on.rectangle")
                }

                if let uiImage = selectedUIImage {
                    let transferable = Image(uiImage: uiImage)
                    ShareLink(
                        item: transferable,
                        preview: SharePreview("Shared Image", image: transferable)
                    ) {
                        Label("Share Image", systemImage: "square.and.arrow.up")
                    }
                }
            }

            Section("Share URL") {
                if let url = URL(string: "https://developer.apple.com/xcode/swiftui/") {
                    ShareLink(item: url) {
                        Label("Share SwiftUI Link", systemImage: "link")
                    }
                }
            }

            Section("Share Multiple Items") {
                ShareLink(
                    items: ["First item to share", "Second item to share"]
                ) { item in
                    SharePreview(item)
                } label: {
                    Label("Share Multiple Texts", systemImage: "square.and.arrow.up.on.square")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Share Sheet")
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedUIImage = uiImage
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShareSheetDemoView()
    }
}
