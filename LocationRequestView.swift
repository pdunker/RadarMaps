//
//  LocationRequestView.swift
//  RadarMaps
//
//  Created by Philip Dunker on 21/04/24.
//

import SwiftUI

struct LocationRequestView: View {
  var body: some View {
    ZStack {
      Color(.systemBlue)
        .ignoresSafeArea()
      
      VStack() {
        Spacer()
        
        Image(systemName: "paperplane.circle.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 200, height: 200)
          .padding(.bottom, 32)
        
        Text("Your permission is needed to access the GPS coordinates")
          .font(.system(size: 26, weight: .semibold))
          .multilineTextAlignment(.center)
          .padding()
        
        Spacer()
        
        VStack {
          
          Button {
            LocationManager.shared.requestLocation()
          } label: {
            Text("Allow Location")
              .padding()
              .font(.headline)
              .foregroundColor(Color(.systemBlue))
          }
          .frame(width: UIScreen.main.bounds.width)
          .padding(.horizontal, -32)
          .background(Color.white)
          .clipShape(Capsule())
          .padding()
          
          Button {
            exit(0)
          } label: {
            Text("Maybe Later")
              .padding()
              .font(.headline)
              .foregroundColor(.white)
          }
          
        }
        .padding(.bottom, 32)
        
      }
      .foregroundColor(.white)
    }
  }
}

#Preview {
  LocationRequestView()
}
