//
//  ModelSettings.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//

import SwiftUI

enum Setting {
    case peopleOcclusion
    case objectOcclusion
    
    var label: String {
        get {
            switch self {
            case .peopleOcclusion, .objectOcclusion :
                return "Occlusion"
           
            }
        }
    }
    
    var systemIconName: String {
        get {
            switch self {
            case .peopleOcclusion:
                return "person"
            case .objectOcclusion:
                return "cube.box.fill"
            }
        }
    }
    
}
