//
//  ContentView.swift
//  ARLogi
//
//  Created by Difa N Pratama on 23/12/21.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var modelDeletionManager: DeletionManager
    @State private var isControlVisible: Bool = true
    @State private var showBrowse: Bool = false
    @State private var showSettings: Bool = false
    @State var audioPlayer: AVAudioPlayer!
    //    @AppStorage("needsAppOnboarding") var needsAppOnboarding: Bool = true
    @State private var onBoard: Bool = true
    @State private var opaqueButton: Double = 0
    @State private var show: Bool = true
    var body: some View {
        ZStack (alignment: .bottom){
            if onBoard {
                
                PlayerView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 30.0 ) {
                            onBoard = false
                        }
                    }
                HStack {
                    SkipButton(action: {
                        onBoard = false
                    })
                        .padding(.bottom, 40)
                        .opacity(opaqueButton)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                withAnimation {
                                    opaqueButton = 1
                                }
                                
                            }
                        }
                }
                
            } else {
                if show {
                    PopUpWindow(show: $show)
                } else {
                    ARViewContainer()
                        .onAppear {
                            playSounds("forest.mp3")
                        }
                    if self.placementSettings.selectedModel != nil {
                        PlacementView()
                    } else if self.modelDeletionManager.entitySelectedForDeletion != nil {
                        DeletionView()
                    } else {
                        ControlView(isControlVisible: $isControlVisible, showBrowse: $showBrowse, showSettings: $showSettings)
                    }
                }
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        
        //        HomePage()
    }
    
    func playSounds(_ soundFileName : String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
            fatalError("Unable to find \(soundFileName) in bundle")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print(error.localizedDescription)
        }
        audioPlayer.play()
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SkipButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let action: () -> Void
    var body: some View {
        VStack {
            Button {
                self.action()
            } label: {
                Text("Skip")
                    .foregroundColor(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 5)
                
            }
            .background(Color("krem"))
            .clipShape(Capsule())
            .padding(.horizontal)
            .shadow(color: Color.blue.opacity(0.15), radius: 8, x: 2, y: 6)
            Text("Tekan untuk lewati video")
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .font(.system(size: 10))
                .padding(.vertical, 5)
        }
        
    }
}
