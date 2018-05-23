//
//  StationConnection.swift
//  test-graph
//
//  Created by Роман Мисников on 23.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

struct StationConnection: Decodable {
    let startId: Int
    let endId: Int
    let weight: Double
    let oriented: Bool
}
