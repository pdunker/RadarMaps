//
//  ContentView.swift
//  RadarMaps
//
//  Created by Philip Dunker on 21/04/24.
//

import SwiftUI
import MapKit
import BackgroundTasks
import FirebaseAnalytics

/*
 Coordinates:
 MRK: -22,9623 | -43,201
 
 Lagoa Close
 -22.970968 | -43.207100
 Lagoa Too Close (< 200)
 -22.972 | -43.207
 
 Leblon (1 radar bem perto)
 -22,987
 -43,228
 */

struct ContentView: View {
  
  @ObservedObject var manager = Manager.shared
  
  @State private var showConfig = false
  
  @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
  
  var body: some View {
    Group {
      if manager.currLocation == nil {
        LocationRequestView()
      } else
      if showConfig {
        ConfigurationView(show: $showConfig)
      } else {
        Map(position: $cameraPosition) {
          UserAnnotation()
          
          ForEach(Manager.shared.getNearbyRadars()) { radar in
            Marker("",
                   monogram: Text("\(radar.limit)"),
                   coordinate: CLLocationCoordinate2DMake(radar.latitude, radar.longitude))
          }
          
        }
        .mapControls {
          MapCompass()
          MapUserLocationButton()
        }
        .safeAreaInset(edge: .top) {
          HStack {
            Button {
              showConfig = true
            } label: {
              Label("", systemImage: "gearshape.fill")
            }
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
            Spacer()
          }
          .padding()
        }
        //.analyticsScreen(name: "RadarMapView")
      }
    }
  }
}

#Preview {
    ContentView()
}

