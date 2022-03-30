//
//  Model.swift
//  ARF
//
//  Created by Difa N Pratama on 07/11/21.
//

import Foundation
import SwiftUI
import RealityKit
import Combine

enum ModelCategory: String, CaseIterable, Codable{
    case fossil
    case mineral
    case igneous
    var label: String {
        get {
            switch self {
            case .fossil:
                return "Fosil"
            case .mineral:
                return "Mineral"
            case .igneous:
                return "Igneous Rock"
            }
        }
    }
    
}

class Model {
    var title: String
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(title: String, name: String, category: ModelCategory, scaleCompensation: Float = 1.0 ){
        self.title = title
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    //TODO: Create a method to async load modelEntity
    func asyncLoadEntity(){
        let fileName = self.name + ".usdz"
        
        //Bundle nill, because the bundle is already inside the name bundle
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                
                switch loadCompletion{
                case.failure(let error): print("Unable to load modelEntity for \(fileName). Error: \(error.localizedDescription)")
                case.finished:
                    break
                }
                
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelEntity for \(self.name) has been loaded")
            })


    }
}

struct Models {
    var all: [Model] = []
    init() {
        // fossil
        let tRex = Model(title:"TRex", name: "tRex", category: .fossil, scaleCompensation: 0.0005)
        let biora = Model(title: "Gajah Biora", name: "biora", category: .fossil, scaleCompensation: 0.2)
        let bubalus = Model(title: "Bubalus Palaeokerabau", name: "bubalus", category: .fossil, scaleCompensation: 1.0)
        let badak = Model(title: "Menoceras", name: "badak", category: .fossil, scaleCompensation: 0.2)
        self.all += [biora, bubalus, badak, tRex]
        
        // mineral
        let amethyst = Model(title: "Amethyst", name: "amethyst", category: .mineral, scaleCompensation: 0.2)
        let azurite = Model(title: "Azurite", name: "azurite", category: .mineral, scaleCompensation: 0.2)
        let sulfur = Model(title: "Belerang", name: "belerang", category: .mineral, scaleCompensation: 0.05)
        self.all += [amethyst,azurite,sulfur]
        
        // igneous
        let andesit = Model(title: "Andesit", name: "andesit", category: .igneous, scaleCompensation: 4.0)
        let basal = Model(title: "Basal", name: "basal", category: .igneous, scaleCompensation: 1)
        let pumice = Model(title: "Batu Apung", name: "batuApung", category: .igneous, scaleCompensation: 1.0)
        let dasit = Model(title: "Dasit", name: "dasit", category: .igneous, scaleCompensation: 1.0)
        self.all += [andesit,basal,dasit,pumice]
        
    }
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter({$0.category == category})
    }
    
//    func getFilter(category: String) -> [Model] {
//        return all.filter({$0.category.rawValue == "Table"})
//    }
    
}
