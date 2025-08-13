//
//  LocationManager.swift
//  RadarMaps
//
//  Created by Philip Dunker on 21/04/24.
//

import CoreLocation

class LocationManager: NSObject {
  
  private let manager = CLLocationManager()
  
  static let shared = LocationManager()
  
  private var currentStreet = ""
  
  override init() {
    super.init()
    manager.delegate = self
    manager.requestAlwaysAuthorization()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.startUpdatingLocation()
    manager.allowsBackgroundLocationUpdates = true
    
  }
  
  func requestLocation() {
    manager.requestWhenInUseAuthorization()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
    switch status {
      
    case .notDetermined:
      print("DEBUG: Not Determined")
    case .restricted:
      print("DEBUG: Restricted")
    case .denied:
      print("DEBUG: Denied")
    case .authorizedAlways:
      print("DEBUG: Auth always")
    case .authorizedWhenInUse:
      print("DEBUG: Auth when in use")
    @unknown default:
      break
    }
    
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //print("DEBUG: LOCATION UPDATED!")
    
    guard let location = locations.last else { return }
    
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location,
                completionHandler: { (placemarks, error) in
        if error == nil {
          let firstLocation = placemarks?[0]
          self.currentStreet = firstLocation!.name!
          print("self.currentStreet", self.currentStreet)
        }
    })
    
    Manager.shared.SetCurrentLocation(newLocation: location)
    
  }
  
  
  func GetCurrentStreet() -> String {
    return self.currentStreet
  }
  
}
