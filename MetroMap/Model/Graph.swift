//
//  Graph.swift
//  MetroMap
//
//  Created by Роман Мисников on 21.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

import Foundation


struct GraphEdge: Decodable {
    var start: String
    var end: String
    var weight: Int
    var oriented: Bool
    
//    init (from start: String, to end: String, weight: Int, oriented: Bool) {
//        self.start = start
//        self.end = end
//        self.weight = weight
//        self.oriented = oriented
//    }
}

class Graph: CustomStringConvertible {
    
    // names of all verteсes
    public private(set) var names: [String] = []
//    // array of edges
//    public private(set) var edges: [GraphEdge] = []
    // result matrix
    public private(set) var matrix: [[Int]] = []
    // for using print(Graph)
    var description: String {
        var desk = ""
        for (index, row) in matrix.enumerated() {
            desk.append("\(names[index]): ")
            for item in row {
                desk.append("\(item) ")
            }
            desk.append("\n")
        }
        return desk
    }
    
    // init with array of Graph edges
    init(edges: [GraphEdge]) {
        
        // add all new names to names array
        for edge in edges {
            // add names to names array
            if !self.names.contains(edge.start){ self.names.append(edge.start) }
            if !self.names.contains(edge.end){ self.names.append(edge.end) }
        }
        
        // create new matrix
        var newMatrix = Array(repeating: Array(repeating: 0, count: names.count), count: names.count)
        
        // add every edge to matrix
        for edge in edges {
            // get indexes of start and end edges
            guard let startIndex = names.index(of: edge.start) else {return}
            guard let endIndex = names.index(of: edge.end) else {return}
            // if graph is not oriented - fill symmetrically
            if !edge.oriented { newMatrix[endIndex][startIndex] = edge.weight }
            newMatrix[startIndex][endIndex] = edge.weight
        }
        
        // save new matrix
        self.matrix = newMatrix
    }
    
//    // build matrix from edges array
//    private func buildMatrix() -> [[Int]]? {
//
//        var matrix = Array(repeating: Array(repeating: 0, count: names.count), count: names.count)
//
//        for item in edges {
//            guard let startIndex = names.index(of: item.start) else { return nil }
//            guard let endIndex = names.index(of: item.end) else { return nil }
//            if !item.oriented { matrix[endIndex][startIndex] = item.weight }
//            matrix[startIndex][endIndex] = item.weight
//        }
//
//        return matrix
//    }
    
//    // add new edge to edges array
//    private func addEdge(_ edge: GraphEdge) {
//
//        let startName = edge.start
//        let endName = edge.start
//
//        // check start and end names are in names array
//        if !names.contains(startName) { names.append(startName) }
//        if !names.contains(endName) { names.append(endName) }
//
//        // add to edges array new element
//        edges.append(edge)
//
//    }
//
//    func addEdges(edgesArray: [GraphEdge]) {
//        // add each edge to array
//        for edge in edges { addEdge(edge) }
//
//        // build matrix for new data
//        if let m = buildMatrix() { matrix = m }
//    }
//
}
