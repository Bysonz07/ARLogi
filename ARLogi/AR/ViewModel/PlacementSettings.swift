//
//  PlacementSettings.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    //When the user select a model in BrowseView, this property is set.
    @Published var selectedModel: Model? {
        willSet(newValue){
            print("Setting selected Model to \(String(describing: newValue?.name))")
        }
    }
    
    //When the user taps confirm in PlacementView, the value of selectedModelis assigned to confirmed Model
    @Published var confirmedModel: Model? {
        willSet(newValue){
            guard let model = newValue else {
                print("Clearing confirmed model")
                return
            }
            
            print("Setting confirmed \(model.name)")
        
        }
    }
    
    //This property retains the cancellable for our SceneEvents.Update subscriber. 
    var sceneObserver: Cancellable?
}
