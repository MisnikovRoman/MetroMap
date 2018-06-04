//
//  Graph.swift
//  test-graph
//
//  Created by Роман Мисников on 23.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

class Graph: CustomStringConvertible {
    
    // MARK: - Propeties
    // main matrix
    var matrix: Matrix<Double>
    
    // count of verteces
    var count: Int { return matrix.columns }
    
    var description: String {
        var text = ""
        let cnt = matrix.columns
        for i in 0..<cnt {
            text.append("\(i): ")
            if let rowDouble = matrix.getRow(index: i) {
                text.append("\(rowDouble)\n")
            }
        }
        return text
    }
    
    // MARK: - Initialization
    // init with received data (stations and connections)
    init(_ stations: [Station], _ connections: [StationConnection]) {
        // create matrix with station.count strings (NxN)
        let newMatrix = Matrix(columns: stations.count, rows: stations.count, with: 0.0)
        // fill matrix with connections
        for connection in connections {
            let start = connection.startId
            let end = connection.endId
            if !connection.oriented { newMatrix[start, end] = connection.weight }
            newMatrix[end, start] = connection.weight
        }
        self.matrix = newMatrix
    }
    
    // MARK: - Search methods
    // This method will return all min weight from entered point index to all other
    func searchAllRoutesForPoint(pointIndex: Int) -> [Double]? {
        
        guard pointIndex < count else { return [] }
        guard pointIndex >= 0 else { return [] }
        
        // array of minimal routes from start point
        guard var routesFromSearchPoint = matrix.getRow(index: pointIndex) else { return nil }
        // check if row contains non zero element
        let rowIsEmpty = routesFromSearchPoint.contains { $0 != 0 }
        guard rowIsEmpty else { return nil }
        // if in array is 0 -> route length = infinity (max of Int)
        for (index, value) in routesFromSearchPoint.enumerated() where value == 0 {
            routesFromSearchPoint[index] = 99999
        }
        // array of checked vertexes in graph (проверенные вершины)
        var checkedVertex = Array(repeating: false, count: matrix.columns)
        // mark start point as checked
        checkedVertex[pointIndex] = true
        // print(checkedVertex)
        
        while(checkedVertex.contains(false)) {
            
            // find min in "routesFromSearchPoint" and get it's index
            var minimum: Double = 99999
            var minimumIndex: Int?
            // search minimum of unchecked vertexes
            for (index, value) in routesFromSearchPoint.enumerated() where !checkedVertex[index] {
                if value < minimum {
                    minimum = value
                    minimumIndex = index
                }
            }
            
            // check if we found minimum in array
            guard let minIndex = minimumIndex else { break }
            
            // all neighbors of checking minimum vertex
            guard let row = matrix.getRow(index: minIndex) else { break }
            
            for (index, value) in row.enumerated() where value != 0{
                // if we found shorter route - save it
                if (minimum + value) < routesFromSearchPoint[index] {
                    routesFromSearchPoint[index] = minimum + value
                }
            }
            checkedVertex[minIndex] = true
        }
        
        // in case of unexpected break of while
        guard !checkedVertex.contains(false) else { return nil }
        return routesFromSearchPoint
    }
    
    // find route from entered array of minimum routes (result of func searchAllRoutesForPoint())
    func findRouteInGraph(from start: Int, to end: Int, minRoutesFromStart: [Double]) -> [(id: Int, weight: Double)]? {
        
        // check if have route to end
        guard minRoutesFromStart[end] != 99999 else { return nil }
        // create copy of array
        var minRoutes = minRoutesFromStart
        // erase number in start
        minRoutes[start] = 0
        // start vertex number (we are moving from end to start)
        var stepItem = end
        // full route
        var route:[Int] = [stepItem]
        var weights:[Double] = []
        
        while (stepItem != start) {
            
            // how much steps are from current position (stepItem) to start
            let valueOfRouteToStart = minRoutes[stepItem]
            
            // column in which we will find 1 step from end to start
            guard let column = matrix.getColumn(index: stepItem) else { return nil }
            
            for (index, value) in column.enumerated() where value != 0 {
                
                if minRoutes[index] == valueOfRouteToStart - value {
                    route.append(index)
                    weights.append(value)
                    stepItem = index
                    break
                }
            }
        }
        // reverse array
        let stationsOnRoute: [Int] = route.reversed()
        // reverse weights
        var stationWeights: [Double] = weights.reversed()
        // ⚠️ comment to have time beetween stations (not from start)
        for i in 1..<stationWeights.count { stationWeights[i] += stationWeights[i-1] }
        // try get 1st element
        guard let startId = stationsOnRoute.first else { return nil }
        // create result array
        var result: [(Int, Double)] = [(startId, 0.0)]
        // fill result array
        for i in 0..<stationWeights.count {
            result.append((stationsOnRoute[i+1], stationWeights[i]))
        }
        
        return result
    }
}
