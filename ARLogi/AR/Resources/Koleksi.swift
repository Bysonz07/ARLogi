//
//  Batu.swift
//  skripsiDifa
//
//  Created by Difa N Pratama on 07/01/22.
//

import Foundation
import SwiftUI

struct Koleksi: Hashable, Codable, Identifiable {
    var id : Int
    var name : String
    var category: Category
    enum Category: String, CaseIterable, Codable{
        case batu = "Batu"
        case fossil = "Fossil"
    }
    var image : String
    var description : String
    
    var getImage: Image {
        Image(image)
    }
}
