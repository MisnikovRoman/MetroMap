//
//  SimpleVC.swift
//  MetroMap
//
//  Created by Роман Мисников on 23.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import UIKit
import Alamofire

class SimpleVC: UIViewController {
    
    var metroModel: MetroModel!
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    // Buttons
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        
        guard let startText = startTextField.text else { return }
        guard let endText = endTextField.text else { return }
        
        guard let startIndex = Int(startText) else { return }
        guard let endIndex = Int(endText) else { return }
        
        guard let url = URL(string: URL_METRO_MAP) else { return }
        Alamofire.request(url).responseJSON { (response) in

            // if there is no error
            guard response.error == nil else { return }
            // try to convert received data to dictionary
            guard let json = response.result.value as? Dictionary<String, Any> else { return }
            // try get data
            guard let data = response.data else { return }

            guard let metroMapModel = try? JSONDecoder().decode(MetroModel.self, from: data) else { return }
            self.metroModel = metroMapModel
            let graph = Graph(metroMapModel.stations, metroMapModel.connections)
            guard let minRoutes = graph.searchAllRoutesForPoint(pointIndex: startIndex) else {
                print("-> NO MIN ROUTES")
                return
            }
            guard let newRoute = graph.findRouteInGraph(from: startIndex, to: endIndex, minRoutesFromStart: minRoutes) else { return }
            print(newRoute)
            route = newRoute
            self.tableView.reloadData()
        }
    }
}

extension SimpleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: STATION_CELL) as! StationCell
        
        let stationNumber = route[indexPath.row].id
        let stationName = metroModel.stations[stationNumber].name
        cell.stationNameLbl.text = "\(stationName)"
        cell.timeLbl.text = "\(Int(route[indexPath.row].weight)) мин."
        
        let colorName = metroModel.stations[stationNumber].color
        let color: UIColor
        switch colorName {
        case "blue":
            color = UIColor(red: 66/255, green: 170/255, blue: 255/255, alpha: 1)
        case "purple":
            color = UIColor(red: 139/255, green: 0/255, blue: 255/255, alpha: 1)
        case "orange":
            color = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)
        default:
            color = .black
        }
        cell.lineView.backgroundColor = color
        return cell
    }
}
