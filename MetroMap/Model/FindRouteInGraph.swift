//
//  FindRoute.swift
//  MetroMap
//
//  Created by Роман Мисников on 17.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import UIKit

func searchAllRoutesForPoint(pointIndex: Int, graph: Matrix<Int>) -> [Int]? {
    
    guard pointIndex < graph.columns else { return [] }
    guard pointIndex >= 0 else { return [] }
    
    // array of minimal routes from start point
    guard var routesFromSearchPoint = graph.getRow(index: pointIndex) else { return nil }
    // if in array is 0 -> route length = infinity (max of Int)
    for (index, value) in routesFromSearchPoint.enumerated() where value == 0 {
        routesFromSearchPoint[index] = Int.max
    }
    // array of checked vertexes in graph (проверенные вершины)
    var checkedVertex = Array(repeating: false, count: graph.columns)
    // mark start point as checked
    checkedVertex[pointIndex] = true
    // print(checkedVertex)
    
    while(checkedVertex.contains(false)) {
        
        // find min in "routesFromSearchPoint" and get it's index
        var minimum: Int = Int.max
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
        guard let row = graph.getRow(index: minIndex) else { break }
        
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
func findRouteInGraph(from start: Int, to end: Int, minRoutesFromStart: inout [Int], graph: Matrix<Int>) -> [Int]? {
    
    minRoutesFromStart[start] = 0
    // start vertex number
    var stepItem = end
    // full route
    var route:[Int] = [stepItem]
    
    while (stepItem != start) {
        
        // how much steps are from current position (stepItem) to start
        let valueOfRouteToStart = minRoutesFromStart[stepItem]
        
        // column in which we will find 1 step from end to start
        guard let column = graph.getColumn(index: stepItem) else { return nil }
        
        for (index, value) in column.enumerated() where value != 0 {
            
            if minRoutesFromStart[index] == valueOfRouteToStart - value {
                route.append(index)
                stepItem = index
            }
        }
    }
    
    return route.reversed()
}

func findRouteStrings(start: String, end: String, graph: Matrix<Int>, names: [String]) -> [String]? {
    
    // check avaibility of names
    guard let startIndex = names.index(of: start) else { return nil }
    guard let endIndex = names.index(of: end) else { return nil }
    guard startIndex < graph.columns else { return nil }
    guard endIndex < graph.columns else { return nil }
    guard startIndex >= 0 else { return nil }
    guard endIndex >= 0 else { return nil }
    
    // find all routes from start
    guard var routes = searchAllRoutesForPoint(pointIndex: startIndex, graph: graph) else { return nil }
    // find route end -> start and reverse it
    guard let route = findRouteInGraph(from: startIndex, to: endIndex, minRoutesFromStart: &routes, graph: graph) else { return nil }
    
    // get names from indexes route
    var namedRoute: [String] = []
    for stationNumber in route {
        let name = names[stationNumber]
        namedRoute.append(name)
    }
    
    return namedRoute
}

