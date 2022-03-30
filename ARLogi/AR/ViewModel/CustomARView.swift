//
//  CustomARView.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//
import RealityKit
import ARKit
import FocusEntity
import SwiftUI
import Combine

class CustomARView: ARView {
    
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    var deletionManager: DeletionManager
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings, deletionManager: DeletionManager) {
        self.sessionSettings = sessionSettings
        self.deletionManager = deletionManager
        
        super.init(frame: frameRect)
        focusEntity = FocusEntity(on: self, focus: .classic)
        //Run Session
        configure()
        //Initialize Update for Occlusion,LiDar
        self.initializeSettings()
        //Subscribe Setup
        self.setupSubscribers()
        
        // Enable LongPress + Enable Object Deletion
        self.enableObjectDeletion()
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame: ) has not been implemented")
    }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Plane Detection
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        session.run(config)
    }
    
    private func initializeSettings() {
        self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
        self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)
        
    }
    
    //MARK: - Subscribing Session Settings
    private func setupSubscribers() {
        self.peopleOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled.sink{ [weak self]
            isEnabled in
            self?.updatePeopleOcclusion(isEnabled: isEnabled)
        }
        self.objectOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled.sink{ [weak self]
            isEnabled in
            self?.updateObjectOcclusion(isEnabled: isEnabled)
        }
       
    }
    
    private func updatePeopleOcclusion(isEnabled: Bool) {
        print("\(#file): isPeopleOcclusionEnabled is now \(isEnabled)")
        //Not every iPhone or iPad have this feature so need to use Guard
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            return
        }
        
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        } else {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        self.session.run(configuration)
        
    }
    
    private func updateObjectOcclusion(isEnabled: Bool) {
        print("\(#file): isObjectOcclusionEnabled is now \(isEnabled)")
        
        if self.environment.sceneUnderstanding.options.contains(.occlusion){
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            self.environment.sceneUnderstanding.options.insert(.occlusion)
        }
        
    }
    
}

//MARK: - Object Deletion Methos

extension CustomARView {
    func enableObjectDeletion() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer ) {
        let location = recognizer.location(in: self)
        
        // Check the location of entity that nearest from user touch location
        if let entity = self.entity(at: location) as? ModelEntity {
            deletionManager.entitySelectedForDeletion = entity
        }
    }
}
