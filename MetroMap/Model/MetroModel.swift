//
//  Graph.swift
//  MetroMap
//
//  Created by Роман Мисников on 17.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

struct MetroModel: Decodable {
    let version: Int
    let city: String
    let stations: [Station]
    let connections: [StationConnection]
}

