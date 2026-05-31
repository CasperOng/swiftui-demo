import SwiftUI
import PhotosUI

struct PhotosPickerDemoView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImage: Image?
    @State private var selectedImages: [Image] = []

    var body: some View {
        List {
            Section {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a Photo", systemImage: "photo.on.rectangle")
                }

                if let selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .accessibilityLabel("Selected photo")
                }
            } header: {
                Text("Single Selection")
            } footer: {
                Text("PhotosPicker provides a system-standard interface for selecting photos and videos. It respects the user's privacy settings without requiring full photo library access.")
            }

            Section("Multiple Selection") {
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
                    Label("Select Photos (max 5)", systemImage: "photo.on.rectangle.angled")
                }

                if !selectedImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<selectedImages.count, id: \.self) { index in
                                selectedImages[index]
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .accessibilityLabel("\(selectedImages.count) photos selected")
                }
            }

            Section("Filter Options") {
                PhotosPicker(selection: $selectedItem, matching: .screenshots) {
                    Label("Screenshots Only", systemImage: "camera.viewfinder")
                }

                PhotosPicker(selection: $selectedItem, matching: .panoramas) {
                    Label("Panoramas Only", systemImage: "pano")
                }

                PhotosPicker(selection: $selectedItem, matching: .videos) {
                    Label("Videos Only", systemImage: "video")
                }

                PhotosPicker(selection: $selectedItem, matching: .not(.videos)) {
                    Label("Exclude Videos", systemImage: "photo")
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("PhotosPicker")
        .compatOnChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
        .compatOnChange(of: selectedItems) { newItems in
            Task {
                var images: [Image] = []
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        images.append(Image(uiImage: uiImage))
                    }
                }
                selectedImages = images
            }
        }
    }
}

#Preview {
    NavigationStack {
        PhotosPickerDemoView()
    }
}
