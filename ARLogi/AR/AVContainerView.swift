//
//  AVContainerView.swift
//  skripsiDifa
//
//  Created by Difa N Pratama on 31/01/22.
//

import SwiftUI
import UIKit
import AVKit

class AudioModel: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    @Published var current: String = ""
    
    var audioFiles = "forest.mp3"
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: audioFiles, withExtension: nil) else {
            fatalError("Unable to find \(audioFiles) in bundle")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func stopSound() {
        // Stop AVAudioPlayer
        audioPlayer?.stop()
    }
}

class UIVideoPlayer: UIView {
    
    var playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let url = URL(string: "https://github.com/Bysonz07/ARLogi/blob/Bysonz07-patch-2/newARLogiOpening-720.mp4?raw=true") else { return }
        
        let player = AVPlayer(url: url)
        player.play()
        playerLayer.player = player
        playerLayer.player = player
        playerLayer.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resizeAspectFill.rawValue)
        layer.addSublayer(playerLayer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
}

struct PlayerView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVideoPlayer {
        return UIVideoPlayer()
    }
    
    func updateUIView(_ uiView: UIVideoPlayer, context: Context) {
        
    }
}

struct PopUpWindow: View {
    @Environment(\.colorScheme) var colorScheme : ColorScheme
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            if show {
                // PopUp background color
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                
                // PopUp Window
                VStack(alignment: .center, spacing: 0) {
                    
                    Text("Cara Pemakaian")
                        .frame(maxWidth: .infinity)
                        .frame(height: 45, alignment: .center)
                        .font(Font.system(size: 23, weight: .semibold))
                        .foregroundColor(Color.black)
                    VStack(alignment: .leading) {
                        Text("1. Pilih Koleksi pada Tab Bar Browser \(Image(systemName: "building.columns"))")
                            .foregroundColor(Color.black)
                            .padding(5)
                        Divider()
                        HStack {
                            Spacer()
                            Rectangle()
                            .strokeBorder(Color.yellow, lineWidth: 3)
                            .frame(width: 101, height: 101, alignment: .center)
                            .padding(5)
                            Spacer()
                        }
                        Text("2. Arahkan kamera dan bounding box hingga semua sisi terhubung seperti persegi diatas")
                            .foregroundColor(Color.black)
                            .padding(5)
                        Divider()
                        Text("3. Tekan tombol checklist dan 3D Model yang dipilih akan muncul")
                            .foregroundColor(Color.black)
                            .padding(5)
                        
                        Divider()
                        Text("4. 3D Model yang telah muncul dapat anda pindahkan, putar, atau atur ukurannya")
                            .foregroundColor(Color.black)
                            .padding(3)
                    }
                    
                    
                    
                    Button {
                        self.show.toggle()
                    } label: {
                        Text("Mengerti")
                            .padding(2)
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color("krem"))
                    .cornerRadius(10)
                    
                    
                }
                .padding()
                //                .frame(maxWidth: 500)
                .border(Color.white, width: 2)
                .background(Color.white)
                .cornerRadius(20)
                
            }
        }
    }
}
