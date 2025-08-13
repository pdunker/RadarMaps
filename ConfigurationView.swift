//
//  ConfigurationView.swift
//  RadarMaps
//
//  Created by Philip Dunker on 23/04/24.
//

import SwiftUI
import Combine

struct ConfigurationView: View {
  
  @Binding var show: Bool
  
  @State private var radarsInRange = String(Manager.shared.radarsInRange)
  @State private var closeDist =  String(Manager.shared.closeDist)
  @State private var tooCloseDist = String(Manager.shared.tooCloseDist)
  @State private var threshold = String(Manager.shared.threshold)
  @State private var checkSameStreet = Manager.shared.checkSameStreet

  private let textFieldsWidth : CGFloat = 100
  
    var body: some View {
        
        VStack() {
          
          Text("Configurações")
            .font(.system(size: 28, weight: .semibold))
            .multilineTextAlignment(.center)
            .padding()
          
          VStack(alignment: .leading, spacing: 25) {
          
            VStack(alignment: .leading) {
              Text("Exibir radares em um raio de")
                .padding(.bottom, -5)
              HStack {
                TextField("\(Manager.shared.radarsInRangeDefault)", text: $radarsInRange)
                  .keyboardType(.decimalPad)
                  .frame(width: self.textFieldsWidth)
                  .padding(5)
                  .overlay(
                    RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.gray)
                  )
                Text("quilômetros")
              }
            }
            
            VStack(alignment: .leading) {
              Text("Primeiro aviso sonoro a")
                .padding(.bottom, -5)
              HStack{
                TextField("\(Manager.shared.closeDistDefault)", text: $closeDist)
                  .keyboardType(.numberPad)
                  .frame(width: self.textFieldsWidth)
                  .padding(5)
                  .overlay(
                    RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.gray)
                  )
                Text("metros")
              }
            }
            
            VStack(alignment: .leading) {
              Text("Segundo aviso a sonoro a")
                .padding(.bottom, -5)
              HStack {
                TextField("\(Manager.shared.tooCloseDistDefault)", text: $tooCloseDist)
                  .keyboardType(.numberPad)
                  .frame(width: self.textFieldsWidth)
                  .padding(5)
                  .overlay(
                    RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.gray)
                  )
                Text("metros")
              }
            }
            
            VStack(alignment: .leading) {
              Text("Limiar para nova verificação:")
                .padding(.bottom, -5)
              HStack{
                TextField("\(Manager.shared.thresholdDefault)", text: $threshold)
                  .keyboardType(.numberPad)
                  .frame(width: self.textFieldsWidth)
                  .padding(5)
                  .overlay(
                    RoundedRectangle(cornerRadius: 5)
                      .stroke(Color.gray)
                  )
                /*
                  .onReceive(Just(threshold)) { newValue in
                    print("onReceive(Just(threshold)) { newValue", newValue)
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                      self.threshold = filtered
                    }
                  }
                 */
                Text("metros")
              }
            }
            
            VStack(alignment: .leading) {
              Toggle(isOn: $checkSameStreet) {
                Text("Avisar apenas radares na mesma via:")
              }
            }
            
          }.padding()
          
          Spacer()
          
          VStack {
            
            Button {
              Manager.shared.SetConfigurations(
                radarsInRange: self.radarsInRange,
                closeDist: self.closeDist,
                tooCloseDist: self.tooCloseDist,
                threshold: self.threshold,
                checkSameStreet: self.checkSameStreet)
              show = false
            } label: {
              Text("Salvar")
                .padding()
                .font(.headline)
                .foregroundColor(Color(.white))
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.horizontal, -32)
            .background(Color(.systemBlue))
            .clipShape(Capsule())
            .padding()
            
            Button {
              show = false
            } label: {
              Text("Voltar")
                .padding()
                .font(.headline)
                .foregroundColor(.gray)
            }
          }
          .padding(.bottom, 32)
          
        }
    }
}

#Preview {
  ConfigurationView(show: .constant(true))
}
