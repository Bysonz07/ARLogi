//
//  Scene3D.swift
//  skripsiDifa
//
//  Created by Difa N Pratama on 01/01/22.
//

import SwiftUI
import SceneKit

struct Scene3D: View {
    var name: String
    var body: some View {
        VStack{
      
            SceneView(scene: SCNScene(named: "\(name).usdz"), options: [.autoenablesDefaultLighting, .allowsCameraControl])
            // for use action
            
            //setting custom frame
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
            
            Spacer(minLength: 0)
        }
    }
}
//
//struct Scene3D_Previews: PreviewProvider {
//    static var previews: some View {
//        Scene3D()
//    }
//}
