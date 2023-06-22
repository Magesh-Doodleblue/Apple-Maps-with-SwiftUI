
import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @EnvironmentObject var viewModel: MapViewModel
    @StateObject private var locationManager = LocationManager()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
//        mapView.showsUserLocation = true     //--> used to track the user location....
//        mapView.userTrackingMode = .follow        //--> used to follow the user location....
//        mapView.delegate = context.coordinator    //--> used to get the user location....
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)          //--> used to add gesture in map....
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let cityName = viewModel.location
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
            if let placemark = placemarks?.first {
                if let location = placemark.location {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    annotation.title = cityName
                    uiView.addAnnotation(annotation)

                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 10000)
                    uiView.setRegion(region, animated: true)

                    // Pass the latitude and longitude to the view model
                    viewModel.latitude = String(location.coordinate.latitude)
                    viewModel.longitude = String(location.coordinate.longitude)
                }
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                guard let mapView = gestureRecognizer.view as? MKMapView else {
                    return
                }
                
                let locationInView = gestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
                let point = MKPointAnnotation()
                point.coordinate = coordinate
                self.parent.viewModel.latitude = "\(coordinate.latitude)"
                self.parent.viewModel.longitude = "\(coordinate.longitude)"
                
                // Reverse geocoding to get the address
                let geocoder = CLGeocoder()
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if let placemark = placemarks?.first {
                        if let address = placemark.name {
                            DispatchQueue.main.async {
                                self.parent.viewModel.location = address
                            }
                        }
                    }
                }
            }
        }
    }
    // MARK: - Location Manager
    class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
        private let locationManager = CLLocationManager()

        override init() {
            super.init()
            locationManager.delegate = self
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // Handle location updates if needed
        }
    }
}



    //    func makeUIView(context: Context) -> MKMapView {
    //        let mapView = MKMapView(frame: UIScreen.main.bounds)
    //        mapView.showsUserLocation = true
    //        mapView.userTrackingMode = .follow
    //        mapView.delegate = context.coordinator
    //        return mapView
    //    }
