//
//  RadarData.swift
//  RadarMaps
//
//  Created by Philip Dunker on 21/04/24.
//

import Foundation
import MapKit
import AVFoundation

struct Radar: Identifiable {
  let id: Int
  let latitude: Double
  let longitude: Double
  let limit: Int
  var street: String
}

class Manager : ObservableObject {
  
  @Published var currLocation: CLLocation?
  private var lastLocation: CLLocation?
  
  private var audioPlayer: AVAudioPlayer?
  
  let radarsInRangeDefault = 5.0
  var radarsInRange: Double
  
  let closeDistDefault = 600
  var closeDist: Int
  
  let tooCloseDistDefault = 60
  var tooCloseDist: Int
  
  let thresholdDefault = 15
  var threshold: Int
  
  var checkSameStreet = true
  
  private var closerRadars = [Int: Bool]()
  private var tooCloseRadars = [Int: Bool]()
  
  static let shared = Manager()
  private init() {
    
    self.radarsInRange = self.radarsInRangeDefault
    self.closeDist = self.closeDistDefault
    self.tooCloseDist = self.tooCloseDistDefault
    self.threshold = self.thresholdDefault
    
    LocationManager.shared.requestLocation()
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Error Initializing AVAudioSession")
    }
  }
  

  func SetConfigurations(radarsInRange: String, closeDist: String, tooCloseDist: String, threshold: String, checkSameStreet: Bool) {
    print("New Config: radarsInRange: \(radarsInRange), closeDist: \(closeDist), tooCloseDist: \(tooCloseDist), threshold: \(threshold), checkSameStreet: \(checkSameStreet)")
    let radarsInRangeAux = radarsInRange.replacingOccurrences(of: ",", with: ".")
    self.radarsInRange = Double(radarsInRangeAux) ?? self.radarsInRangeDefault
    self.closeDist = Int(closeDist) ?? self.closeDistDefault
    self.tooCloseDist = Int(tooCloseDist) ?? self.tooCloseDistDefault
    self.threshold = Int(threshold) ?? self.thresholdDefault
    self.checkSameStreet = checkSameStreet
  }
  
  
  func SetCurrentLocation(newLocation: CLLocation) {
    //print("DEBUG: SetCurrentLocation")
    
    if self.currLocation != nil {
      let moved = self.currLocation?.distance(from: newLocation)
      if moved! < Double(self.threshold) {
        return
      }
    }
    
    self.lastLocation = self.currLocation
    self.currLocation = newLocation
    
    if self.lastLocation == nil {
      return
    }
    
    let nearbyRadars = getNearbyRadars()
    
    let currStreet = LocationManager.shared.GetCurrentStreet()
    print("currStreet", currStreet)
    // near
    // -22,9867
    // -43,2271
    // far
    // -22,9865
    // -43,2265
    
    var hasRadarClose = false
    var hasRadarTooClose = false
    for radar in nearbyRadars {
      let radarLocation = CLLocation(latitude: radar.latitude, longitude: radar.longitude)
      let lastDist = self.lastLocation?.distance(from: radarLocation)
      let currDist = self.currLocation?.distance(from: radarLocation)
      
      let gettingCloser = currDist! < lastDist!
      
      let isClose = currDist! <= Double(self.closeDist)
      
      var isSameStreet = true
      if self.checkSameStreet {
        isSameStreet = currStreet.contains(radar.street)
      }
      //print("isSameStreet, radar.street", isSameStreet,  radar.street)
      if gettingCloser && isClose && isSameStreet {
        
        let isTooClose = currDist! <= Double(self.tooCloseDist)
        
        if isTooClose && tooCloseRadars[radar.id] != true {
          tooCloseRadars[radar.id] = true
          hasRadarTooClose = true
          print("Radar \(radar.id) TOO close | currDist \(currDist!) | radar.street \(radar.street)")
        }
        else if closerRadars[radar.id] != true {
          hasRadarClose = true
          closerRadars[radar.id] = true
          print("Radar \(radar.id) close | currDist \(currDist!) | radar.street \(radar.street)")
        }

        
      } else {
        closerRadars[radar.id] = nil
        tooCloseRadars[radar.id] = nil
      }

      //print("Radar \(radar.id) at currDist \(currDist!) | gettingCloser, isClose, tooClose", gettingCloser,  closerRadars[radar.id], tooCloseRadars[radar.id])
      
    }
    
    if (hasRadarTooClose) {
      PlaySound(sound: "radar_too_close")
    }
    else if(hasRadarClose) {
      PlaySound(sound: "radar_close")
    }
    //print("Radar \(radars[0].id): lastDist \(String(describing: lastDist?.magnitude)) currDist \(String(describing: currDist?.magnitude))")
  
    /*
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(radarLocation,
                completionHandler: { (placemarks, error) in
        if error == nil {
          let firstLocation = placemarks?[0]
          print("Radar \(radar.id): \(firstLocation!.name ?? "No description")")
        }
    })
     */
  }
  
  func getNearbyRadars () -> [Radar] {
    let distanceMeters = Double(self.radarsInRange*1000)
    if self.currLocation == nil {
      return RadarTable.radars
    }
    var nearbyRadars = [Radar]()
    for radar in RadarTable.radars {
      let radarLocation = CLLocation(latitude: radar.latitude, longitude: radar.longitude)
      let currDist = self.currLocation?.distance(from: radarLocation)
      if currDist! <= distanceMeters {
        nearbyRadars.append(radar)
      }
    }
    print("nearbyRadars: \(nearbyRadars.count)")
    return nearbyRadars
  }
  
  
  func PlaySound(sound: String) {
    guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
      print("Sound file \(sound) not found!") // show alert
      return
    }
    do {
      //try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
      try AVAudioSession.sharedInstance().setActive(true)
      audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      guard let player = audioPlayer else {
        print("Couldn't setup AVAudioPlayer!")  // show alert
        return
      }
      player.play()
    }
    catch let error {
      print("Error playing sound:")
      print(error.localizedDescription)
    }
  }
  
}
