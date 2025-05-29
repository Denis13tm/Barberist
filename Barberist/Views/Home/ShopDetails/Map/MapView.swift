//
//  MapView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/9/25.
//

import SwiftUI
import MapKit
import CoreLocation

//struct MapView: View {
//    let shop: Shop
//    @Environment(\.dismiss) var dismiss
//
//    var region: MKCoordinateRegion {
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(
//                latitude: shop.lat ?? 41.3111,
//                longitude: shop.long ?? 69.2797
//            ),
//            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        )}
//
//
//    var body: some View {
//        NavigationStack {
//            Map(initialPosition: .region(region)) {
//                if let lat = shop.lat, let long = shop.long {
//                    Marker(shop.name ?? "Shop", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
//                }
//            }
//            .ignoresSafeArea()
//            .navigationTitle(shop.name ?? "Barbershop")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button("Yopish") {
//                        dismiss()
//                    }
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    MapView(shop: Shop())
//}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last?.coordinate
    }
}

struct ShopMapView: View {
    let shop: Shop
    @ObservedObject private var locationManager = LocationService.shared
    @Environment(\.dismiss) var dismiss
    @State private var mapRegion: MKCoordinateRegion

    // --- ADD THIS ---
    struct MapMarkerItem: Identifiable {
        let id = UUID()
        let title: String
        let coordinate: CLLocationCoordinate2D
    }
    var markers: [MapMarkerItem] {
        var items: [MapMarkerItem] = []
        if let lat = shop.lat, let long = shop.long {
            items.append(MapMarkerItem(title: shop.name ?? "Shop", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long)))
        }
        if let userCoord = locationManager.userCoordinate {
            items.append(MapMarkerItem(title: "Sizning joylashuvingiz", coordinate: userCoord))
        }
        return items
    }
    // ---

    init(shop: Shop) {
        self.shop = shop
        if let lat = shop.lat, let long = shop.long {
            _mapRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long),
                                                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        } else {
            _mapRegion = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.3111, longitude: 69.2797),
                                                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        }
    }

    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $mapRegion, annotationItems: markers) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    VStack {
                        if item.title == "Sizning joylashuvingiz" {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "mappin")
                                .font(.title)
                                .foregroundColor(.accentColor)
                        }
                        Text(item.title)
                            .font(.caption2)
                            .padding(2)
                            .background(.thinMaterial)
                            .cornerRadius(4)
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    if let userCoord = locationManager.userCoordinate {
                        withAnimation(.easeInOut) {
                            mapRegion = MKCoordinateRegion(center: userCoord, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                        }
                    }
                }) {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.accentColor)
                        .padding()
                        .background(.ultraThinMaterial, in: Circle())
                        .shadow(radius: 3)
                }
                .padding(.trailing, 24)
                .padding(.top, 48)
            }
            .navigationTitle("Xaritada ko‘rish")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Yopish") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ShopMapView(shop: Shop.mock)
}

struct MapMarkerItem: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
}
