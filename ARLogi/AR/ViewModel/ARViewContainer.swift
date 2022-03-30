//
//  ARViewContainer.swift
//  skripsiDifa
//
//  Created by Difa N Pratama on 30/01/22.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer : UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var deletionManager: DeletionManager
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero, sessionSettings: sessionSettings, deletionManager: deletionManager)
        //Subscribe to SceneEvents.Update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            
            // Call Update scene method
            self.updateScene(for: arView)
            // Call updatePersistance
            self.updatePersistanceAvailability(for: arView)
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        
    }
    
    private func updateScene(for arView: CustomARView){
        //Only display focusEntity when the user has selected a model for placement
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        //Add model to scene if confirmed for placement
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity{
            //Done: Call Place method
            self.place(modelEntity, in: arView)
            
            self.placementSettings.confirmedModel = nil //To reset the confirmed Model, or it will update per frame -> crash
        }
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView){
        
        //1. Clone model entity. This creates an identical copy of modelEntity and references the same model. This also allows us to have multiple models of the same asset in our scene.
        let clonedEntity = modelEntity.clone(recursive: true)
        //2. Enabled translation and rotation gestures.
        clonedEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation, .scale], for: clonedEntity)
        //3. Create an anchorEntity and add cloneEntity to the anchorEntity.
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        //4. Add the anchorEntity to the arView.scene
        arView.scene.addAnchor(anchorEntity)
        
        // Update anchorEntity to sceneManager
        self.sceneManager.anchorEntities.append(anchorEntity)
        
        print("Add Model Entity to Scene")
    }
    
}

extension ARViewContainer{
    private func updatePersistanceAvailability(for arView: ARView) {
        guard let currentFrame = arView.session.currentFrame else {
            print("ARFrame not available")
            return
        }
        
        switch currentFrame.worldMappingStatus {
        case .mapped, .extending:
            self.sceneManager.isPersistanceAvailable = !self.sceneManager.anchorEntities.isEmpty // check one ar object is placed and set the scene manager to true
        default:
            self.sceneManager.isPersistanceAvailable = false
        }
        
    }
}
