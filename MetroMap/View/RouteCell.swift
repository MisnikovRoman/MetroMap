//
//  RouteCell.swift
//  MetroMap
//
//  Created by Роман Мисников on 04.06.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {

    @IBOutlet weak var resultLbl: UILabel!
    
    func setupCell(with data: String) { resultLbl.text = data }
    
}
