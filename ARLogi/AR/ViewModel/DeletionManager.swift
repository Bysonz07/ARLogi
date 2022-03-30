//
//  ModelDeletionManager.swift
//  ARF
//
//  Created by Difa N Pratama on 30/01/22.
//

import Foundation
import SwiftUI
import RealityKit

class DeletionManager: ObservableObject {
    @Published var entitySelectedForDeletion: ModelEntity? = nil {
        willSet(newValue) {
            
            // Selecting new EntitySelected for deletion, no prior selection
            if self.entitySelectedForDeletion == nil, let newlySelectedForDeletion = newValue {
                print("Selecting new EntitySelected for deletion, no prior selection")
                
                // Highlight selected entity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedForDeletion.modelDebugOptions = component
            } else if let previouslySelectedForDeletion = self.entitySelectedForDeletion, let newlySelectedForDeletion = newValue {
                // selecting new entityselected for deletion, has prior selection but not confirm deletion
                print("selecting new entityselected for deletion, has prior selection but not confirm deletion")
                
                // UnHighlight previousEntitySelected
                previouslySelectedForDeletion.modelDebugOptions = nil
                
                // Highlight newSelectedEntity
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedForDeletion.modelDebugOptions = component
            } else if newValue == nil {
                // clearing entityselected for deletion
                
                self.entitySelectedForDeletion?.modelDebugOptions = nil
            }
            
            
            
            
        }
    }
    
}
