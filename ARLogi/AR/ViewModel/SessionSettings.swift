//
//  SessionSettings.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//

import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
 }
