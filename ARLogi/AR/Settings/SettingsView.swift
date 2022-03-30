//
//  SettingsView.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    
    var body: some View {
        NavigationView{
            SettingsGrid()
                .navigationTitle(Text("Settings"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        self.showSettings.toggle()
                    } label: {
                        Text("Done").bold()
                    }

                }
        }
    }
}

struct SettingsGrid: View {
    @ObservedObject var audioModel = AudioModel()
    @EnvironmentObject var sessionSettings: SessionSettings
    @State private var audioToggle: Bool = false
    private var gridItemLayout = [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 25)]
    
    var body: some View{
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                Text("Occlusion Toggle")
                    .padding(5)
                Text("Occlusion ini dapat membuat objek AR bersembunyi dibelakang benda nyata").font(.caption)
                    .padding(.horizontal,5)
                    .padding(.vertical,3)
                Divider()
                LazyVGrid(columns: gridItemLayout, spacing: 25){
                    SettingsToggleButton(setting: .peopleOcclusion, isOn: $sessionSettings.isPeopleOcclusionEnabled)
                    SettingsToggleButton(setting: .objectOcclusion, isOn: $sessionSettings.isObjectOcclusionEnabled)
                }
                Toggle("Sound", isOn: $audioToggle)
                    .toggleStyle(SwitchToggleStyle(tint: Color("gold")))
                    .padding(5)
                    .onTapGesture {
                        if audioToggle {
                            self.audioModel.playSound()
                        } else {
                            self.audioModel.stopSound()
                        }
                    }
            }
           
        }
        .padding(.top, 35)
    }
}

struct SettingsToggleButton: View {
    let setting: Setting
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            self.isOn.toggle()
            print(("\(#file) - \(setting): \(self.isOn)"))
        } label: {
            VStack {
                Image(systemName: setting.systemIconName)
                    .font(.system(size: 35))
                    .foregroundColor(self.isOn ? .green : Color(UIColor.secondaryLabel))
                    .buttonStyle(PlainButtonStyle())
                
                Text(setting.label)
                    .font(.system(size: 17, weight: .medium, design: .default))
                    .foregroundColor(self.isOn ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
                    .padding(.top, 5)
            }
        }
        .frame(width: 100, height: 100)
        .background(Color(UIColor.secondarySystemFill))
        .cornerRadius(20)

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettings: Binding.constant(true))
    }
}
