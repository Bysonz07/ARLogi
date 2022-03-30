//
//  DeletionView.swift
//  ARF
//
//  Created by Difa N Pratama on 30/01/22.
//

import Foundation
import SwiftUI

struct DeletionView: View {
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var modelDeletionManager: DeletionManager
    
    var body: some View {
        HStack {
            Spacer()
            // Cancel Deletion
            DeletionButton(systemIconName: "xmark.circle.fill") {
                self.modelDeletionManager.entitySelectedForDeletion = nil
            }
            
            Spacer()
            
            // Deletion
            DeletionButton(systemIconName: "trash") {
                print("Confirmation Deletion")
                
                guard let anchor = self.modelDeletionManager.entitySelectedForDeletion?.anchor else { return }
                
                let anchoringIdentifier = anchor.anchorIdentifier
                if let index = self.sceneManager.anchorEntities.firstIndex(where: { $0.anchorIdentifier == anchoringIdentifier
                }) {
                    print("Deleting anchor entity with id: \(String(describing: anchoringIdentifier))")
                    self.sceneManager.anchorEntities.remove(at: index)
                }
                
                anchor.removeFromParent() //Delete the entity
                self.modelDeletionManager.entitySelectedForDeletion = nil
            }
            
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

struct DeletionButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            self.action()
        } label: {
            Image(systemName: systemIconName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 75, height: 75)

    }
}


 
