//
//  Graph.swift
//  MetroMap
//
//  Created by Роман Мисников on 17.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

var route: [(id: Int, weight: Double)] = []

struct MetroModel: Decodable {
    let version: Double
    let city: String
    let stations: [Station]
    let connections: [StationConnection]
}

