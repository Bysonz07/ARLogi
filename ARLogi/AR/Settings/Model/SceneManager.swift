//
//  SceneManager.swift
//  ARLogi
//
//  Created by Difa N Pratama on 03/02/22.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit

//MARK: - Persistance
class SceneManager: ObservableObject {
    @Published var isPersistanceAvailable: Bool = false
    // Keep track of anchorentities (w/modelEntities) in the scene
    @Published var anchorEntities: [AnchorEntity] = []
    
    
}
