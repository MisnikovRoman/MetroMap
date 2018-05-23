//
//  SimpleVC.swift
//  MetroMap
//
//  Created by Роман Мисников on 23.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import UIKit

class SimpleVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
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
