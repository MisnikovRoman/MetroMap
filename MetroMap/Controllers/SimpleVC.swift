//
//  SimpleVC.swift
//  MetroMap
//
//  Created by Роман Мисников on 23.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

class SimpleVC: UIViewController {
    
    // Variables
    var metroModel: MetroModel!
    let startDropDown = DropDown()
    let endDropDown = DropDown()
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupDropDown()
    }
    
    // search methods
    func setupDropDown() {
        
        // set anchor
        startDropDown.anchorView = startTextField
        endDropDown.anchorView = endTextField
        
        // data sources
        startDropDown.dataSource = SearchModel.instance.foundedStations
        endDropDown.dataSource = SearchModel.instance.foundedStations
        
        // disable shadow
        startDropDown.shadowColor = .clear
        endDropDown.shadowColor = .clear
        
        // add opacity
        startDropDown.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.7)
        endDropDown.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 0.7)
        
        // offset from top
        startDropDown.bottomOffset = CGPoint(x: 0, y:(startDropDown.anchorView?.plainView.bounds.height)! + 8)
        endDropDown.bottomOffset = CGPoint(x: 0, y:(endDropDown.anchorView?.plainView.bounds.height)! + 8)
        
        // press handle
        startDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.startTextField.text = item
            SearchModel.instance.resetSearch()
        }
        
        // press handle
        endDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.endTextField.text = item
            SearchModel.instance.resetSearch()
        }
        
    }
    
    // Данный метод наследуется от класса UIResponder классом UIViewController, а затем нашим классом ViewController (ViewController:UIViewController:UIResponder)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // hide keyboard when view is touched
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
    }
    
    // UI Actions
    @IBAction func searchBtnPressed(_ sender: UIBarButtonItem) {
        
        guard let startText = startTextField.text else { return }
        guard let endText = endTextField.text else { return }
        
//        guard let startIndex = Int(startText) else { return }
//        guard let endIndex = Int(endText) else { return }
        
        // create new service
        let metroService = MapService()
        metroService.loadMapData { (model, error) in
            
            // check optionals
            guard error == nil else { print(error!.localizedDescription); return }
            guard let model = model else { return }
            
            // find station index from station name
            guard let startIndex = model.findStationIndex(byName: startText) else {
                let alert = UIAlertController(title: "Error", message: "Didn't find start station", preferredStyle: .alert)
                let action = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let endIndex = model.findStationIndex(byName: endText) else {
                let alert = UIAlertController(title: "Error", message: "Didn't find end station", preferredStyle: .alert)
                let action = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            // save model
            self.metroModel = model
            
            // create graph
            let graph = Graph(model.stations, model.connections)
            guard let minRoutes = graph.searchAllRoutesForPoint(pointIndex: startIndex) else {
                print("-> NO MIN ROUTES")
                return
            }
            
            // search routes
            guard let newRoute = graph.findRouteInGraph(from: startIndex, to: endIndex, minRoutesFromStart: minRoutes) else { return }
            print(newRoute)
            
            // save route
            route = newRoute
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func textFieldDidEdited(_ sender: UITextField) {
        
        var dropDown: DropDown!
        var searchTF: UITextField!
        
        if sender == startTextField {
            dropDown = startDropDown
            searchTF = startTextField
        } else {
            dropDown = endDropDown
            searchTF = endTextField
        }
        
        guard let search = searchTF.text, search != "" else { return }
        SearchModel.instance.searchText(search)
        
        dropDown.dataSource = SearchModel.instance.foundedStations
        if dropDown.isHidden { dropDown.show() }
        
    }
    
    
}

extension SimpleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return route.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        if row == 0 {
            guard let routeTime = route.last?.weight, routeTime > 0 else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ROUTE_CELL) as! RouteCell
            cell.setupCell(with: "\(Int(routeTime)) мин.")
            return cell
        } else {
            guard row > 0, row <= route.count else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: STATION_CELL) as! StationCell
            
            let stationNumber = route[row-1].id
            let stationName = metroModel.stations[stationNumber].name
            cell.stationNameLbl.text = "\(stationName)"
            cell.timeLbl.text = "\(Int(route[row-1].weight)) мин."
            
            let colorName = metroModel.stations[stationNumber].color
            let color: UIColor
            switch colorName {
            case "blue":
                color = UIColor(red: 66/255, green: 170/255, blue: 255/255, alpha: 1)
            case "purple":
                color = UIColor(red: 139/255, green: 0/255, blue: 255/255, alpha: 1)
            case "orange":
                color = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)
            case "red" :
                color = UIColor(red: 255/255, green: 36/255, blue: 0/255, alpha: 1)
            case "green" :
                color = UIColor(red: 0/255, green: 165/255, blue: 80/255, alpha: 1)
            case "brown" :
                color = UIColor(red: 149/255, green: 80/255, blue: 12/255, alpha: 1)
            default:
                color = .black
            }
            cell.lineView.backgroundColor = color
            return cell
        }
    }
}
