import SwiftUI
import MapKit

struct MapKitDemoView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedMapStyle: MapStyleOption = .standard
    @State private var showingUserLocation = false

    enum MapStyleOption: String, CaseIterable {
        case standard = "Standard"
        case satellite = "Satellite"
        case hybrid = "Hybrid"
    }

    struct PointOfInterest: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
        let icon: String
    }

    let landmarks: [PointOfInterest] = [
        PointOfInterest(name: "Apple Park", coordinate: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090), icon: "building.2"),
        PointOfInterest(name: "Infinite Loop", coordinate: CLLocationCoordinate2D(latitude: 37.3318, longitude: -122.0312), icon: "mappin"),
        PointOfInterest(name: "Stanford University", coordinate: CLLocationCoordinate2D(latitude: 37.4275, longitude: -122.1697), icon: "graduationcap"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Map
            Map(position: $position) {
                ForEach(landmarks) { landmark in
                    Annotation(landmark.name, coordinate: landmark.coordinate) {
                        Image(systemName: landmark.icon)
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.tint, in: Circle())
                    }
                }
            }
            .mapStyle(mapStyle)
            .mapControls {
                MapCompass()
                MapScaleView()
                MapPitchToggle()
            }
            .frame(height: 350)

            // Controls
            List {
                Section("Map Style") {
                    Picker("Style", selection: $selectedMapStyle) {
                        ForEach(MapStyleOption.allCases, id: \.self) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Camera Presets") {
                    Button("Apple Park") {
                        withAnimation {
                            position = .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            ))
                        }
                    }

                    Button("Bay Area Overview") {
                        withAnimation {
                            position = .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 37.4, longitude: -122.1),
                                span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
                            ))
                        }
                    }

                    Button("Show All Landmarks") {
                        withAnimation {
                            position = .automatic
                        }
                    }
                }

                Section("Features") {
                    LabeledContent("Annotations") {
                        Text("\(landmarks.count) landmarks")
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent("Controls") {
                        Text("Compass, Scale, Pitch")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("MapKit")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var mapStyle: MapStyle {
        switch selectedMapStyle {
        case .standard: return .standard
        case .satellite: return .imagery
        case .hybrid: return .hybrid
        }
    }
}

#Preview {
    NavigationStack {
        MapKitDemoView()
    }
}
