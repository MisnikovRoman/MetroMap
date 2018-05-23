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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    // Buttons
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        
        guard let url = URL(string: URL_METRO_MAP) else { return }
        Alamofire.request(url).responseJSON { (response) in

            print(response.error)
            
//            // if there is no error
//            guard response.error == nil else { return }
//            // try to convert received data to dictionary
//            guard let json = response.result.value as? Dictionary<String, Any> else { return }
//            // try get data
//            guard let data = response.data else { return }
//
//            guard let metroMapModel = try? JSONDecoder().decode(MetroModel.self, from: data) else { return }
//            self.metroModel = metroMapModel

        }
    }
}

extension SimpleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: STATION_CELL) as! StationCell
        
        return cell
    }
    
    
}
