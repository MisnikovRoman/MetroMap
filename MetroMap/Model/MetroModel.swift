//
//  Graph.swift
//  MetroMap
//
//  Created by Роман Мисников on 17.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

class MetroModel {

    static let instance = MetroModel()
    
    private let spbEdges = [
        GraphEdge(from: "Петроградская", to: "Горьковская", weight: 4, oriented: false),
        GraphEdge(from: "Горьковская", to: "Невский проспект", weight: 5, oriented: false)
    ]
    
    var graph: Graph { return Graph(edges: spbEdges) }
    
    
}

