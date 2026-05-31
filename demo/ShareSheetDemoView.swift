import SwiftUI
import UniformTypeIdentifiers

struct ShareSheetDemoView: View {
    @State private var showingShareSheet = false
    @State private var showingDocumentPicker = false
    @State private var selectedText = "This is some sample text to share"
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        List {
            Section("Share Text") {
                TextEditor(text: $selectedText)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2))
                    )
                
                Button("Share Text") {
                    showingShareSheet = true
                }
                .buttonStyle(.bordered)
            }
            
            Section("Share Image") {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                }
                
                Button("Select Image") {
                    showingImagePicker = true
                }
                .buttonStyle(.bordered)
                
                if selectedImage != nil {
                    Button("Share Image") {
                        showingShareSheet = true
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Section("Document Sharing") {
                Button("Select Document") {
                    showingDocumentPicker = true
                }
                .buttonStyle(.bordered)
            }
            
            Section("Share Multiple Items") {
                Button("Share Text and Image") {
                    showingShareSheet = true
                }
                .buttonStyle(.bordered)
                .disabled(selectedImage == nil)
            }
        }
        .navigationTitle("Share Sheet Demo")
        .sheet(isPresented: $showingShareSheet) {
            if let image = selectedImage {
                ShareSheet(items: [selectedText, image])
            } else {
                ShareSheet(items: [selectedText])
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.text, .pdf, .image])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            // Handle selected documents
            print("Selected documents: \(urls)")
        }
    }
}

#Preview {
    NavigationStack {
        ShareSheetDemoView()
    }
} 