//
//  ControlView.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//

import SwiftUI

struct ControlView: View {
    @Binding var isControlVisible: Bool
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack {
            ControlVisibilityToggleButton(isControlVisible: $isControlVisible)
            Spacer()
            if isControlVisible {
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings)
            }
        }
    }
}

//MARK: - Visibility
struct ControlVisibilityToggleButton : View {
    @Binding var isControlVisible: Bool
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Color.black.opacity(0.25)
                Button {
                    print("Control Toogle Button Press")
                    self.isControlVisible.toggle()
                } label: {
                    Image(systemName: self.isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }

            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top, 45)
        .padding(.trailing, 20)
    }
}

//MARK: - ControlButton Bar
struct ControlButtonBar : View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sceneManager: SceneManager
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    var body: some View {
        HStack {
            //Trash
            ControlButton(systemIconName: "trash", buttonName: "Delete") {
                print("Trash Button Press")
                // Remove all entity in scene
                for anchorEntity in self.sceneManager.anchorEntities {
                    print("Removing entity with id: \(String(describing: anchorEntity.anchorIdentifier))")
                    anchorEntity.removeFromParent()
                }
            }
            
            Spacer()
            //Browse
            ControlButton(systemIconName: "building.columns", buttonName: "Browse") {
                print("Browse Button Press")
                self.showBrowse.toggle()
            }.sheet(isPresented: $showBrowse) {
                //TODO: - BrowseView
                BrowseView(showBrowse: $showBrowse)
            }
            
            Spacer()
            //Setting
            ControlButton(systemIconName: "slider.horizontal.3", buttonName: "Setting") {
                print("Setting Button Press")
                self.showSettings.toggle()
            }.sheet(isPresented: $showSettings) {
                SettingsView(showSettings: $showSettings)
            }

            
        }
        .frame(maxWidth: 500)
        .padding(30)
        .background(Color("krem"))
    }
}

struct ControlButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let systemIconName: String
    let buttonName: String
    let action: () -> Void
    var body : some View {
        Button {
            self.action()
        } label: {
            VStack(alignment: .center) {
                Image(systemName: systemIconName)
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                Text(buttonName)
                    .font(.system(size: 10))
                    .foregroundColor(Color.white)
            }
            
        }
        .frame(width: 50, height: 50)
    }
}


//
//struct ControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        ControlView(isControlVisible: Binding.constant(true))
//    }
//}
