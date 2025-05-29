//
//  MapImageCardView.swift
//  Barberist
//
//  Created by Shohjahon Rakhmatov on 25/05/25.
//

import SwiftUI
@preconcurrency import MapKit

struct MapImageCardView: View {
    let location: Location
    var name: String?
    var showsUserLocation: Bool
    var zoomLevel: Double
    let clLocation: CLLocationCoordinate2D
    let region: MKCoordinateRegion
    
    @State private var mapImage: UIImage?
    @Environment(\.colorScheme) var colorScheme
    
    init(location: Location, name: String? = nil, showsUserLocation: Bool = false, zoomLevel: Double = 0.02) {
        self.location = location
        self.name = name
        self.showsUserLocation = showsUserLocation
        self.zoomLevel = zoomLevel
        clLocation = CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)
        region = MKCoordinateRegion(center: clLocation, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let mapImage = mapImage {
                    Image(uiImage: mapImage)
                        .resizable()
                        .scaledToFill()
                        .onChange(of: colorScheme) { newScheme in
                            self.mapImage = nil
                        }
                } else {
                    Map(coordinateRegion: .constant(region), interactionModes: [], showsUserLocation: showsUserLocation)
                    .allowsHitTesting(false)
                    .onAppear {
                        takeSnapshot(proxy.size)
                    }
                }
                AnnotationItemView()
            }
        }
    }
    
    func takeSnapshot(_ size: CGSize) {
        let options = MKMapSnapshotter.Options()
        options.region = region
        options.size = size
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if let snapshot = snapshot {
                self.mapImage = snapshot.image
            }
        }
    }

    
    @ViewBuilder func AnnotationItemView(_ size: CGFloat = 32) -> some View {
        MapPinShape()
            .fill(Color.red.gradient)
            .aspectRatio(3/4, contentMode: .fit)
            .frame(height: size)
            .offset(y: size / -2)
    }
}

struct MapPinShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.56172*width, y: 0.975*height))
        path.addCurve(to: CGPoint(x: width, y: 0.375*height), control1: CGPoint(x: 0.69531*width, y: 0.84961*height), control2: CGPoint(x: width, y: 0.5457*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0), control1: CGPoint(x: width, y: 0.16797*height), control2: CGPoint(x: 0.77604*width, y: 0))
        path.addCurve(to: CGPoint(x: 0, y: 0.375*height), control1: CGPoint(x: 0.22396*width, y: 0), control2: CGPoint(x: 0, y: 0.16797*height))
        path.addCurve(to: CGPoint(x: 0.43828*width, y: 0.975*height), control1: CGPoint(x: 0, y: 0.5457*height), control2: CGPoint(x: 0.30469*width, y: 0.84961*height))
        path.addCurve(to: CGPoint(x: 0.56172*width, y: 0.975*height), control1: CGPoint(x: 0.47031*width, y: 1.00488*height), control2: CGPoint(x: 0.52969*width, y: 1.00488*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.5*width, y: 0.25*height))
        path.addCurve(to: CGPoint(x: 0.61785*width, y: 0.28661*height), control1: CGPoint(x: 0.5442*width, y: 0.25*height), control2: CGPoint(x: 0.58659*width, y: 0.26317*height))
        path.addCurve(to: CGPoint(x: 0.66667*width, y: 0.375*height), control1: CGPoint(x: 0.64911*width, y: 0.31005*height), control2: CGPoint(x: 0.66667*width, y: 0.34185*height))
        path.addCurve(to: CGPoint(x: 0.61785*width, y: 0.46339*height), control1: CGPoint(x: 0.66667*width, y: 0.40815*height), control2: CGPoint(x: 0.64911*width, y: 0.43995*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.5*height), control1: CGPoint(x: 0.58659*width, y: 0.48683*height), control2: CGPoint(x: 0.5442*width, y: 0.5*height))
        path.addCurve(to: CGPoint(x: 0.38215*width, y: 0.46339*height), control1: CGPoint(x: 0.4558*width, y: 0.5*height), control2: CGPoint(x: 0.41341*width, y: 0.48683*height))
        path.addCurve(to: CGPoint(x: 0.33333*width, y: 0.375*height), control1: CGPoint(x: 0.35089*width, y: 0.43995*height), control2: CGPoint(x: 0.33333*width, y: 0.40815*height))
        path.addCurve(to: CGPoint(x: 0.38215*width, y: 0.28661*height), control1: CGPoint(x: 0.33333*width, y: 0.34185*height), control2: CGPoint(x: 0.35089*width, y: 0.31005*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.25*height), control1: CGPoint(x: 0.41341*width, y: 0.26317*height), control2: CGPoint(x: 0.4558*width, y: 0.25*height))
        path.closeSubpath()
        return path
    }
}
