//
//  ViewController.swift
//  MetroMap
//
//  Created by Роман Мисников on 17.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    // Outlets
    @IBOutlet weak var fromStationTextFiled: UITextField!
    @IBOutlet weak var toStationTextFiled: UITextField!
    
    let pickerView = UIPickerView()
    
    // main functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // set input view to picker view
        fromStationTextFiled.inputView = pickerView
        toStationTextFiled.inputView = pickerView
    }
    
    // Btns press
    @IBAction func searchBtnPressed(_ sender: Any) {
        // safely get data from text fields
        guard let fromStationName = fromStationTextFiled.text else { return }
        guard let toStationName = toStationTextFiled.text else { return }
        
//        guard let fromIndex = MetroModel.names[fromStationName] else { return }
//        guard let toIndex = MetroModel.names[toStationName] else { return }
        
        guard let route = findRouteStrings(start: fromStationName, end: toStationName, graph: MetroModel.graph, names: MetroModel.names) else {
            
            let alert = UIAlertController(title: "Ошибка", message: "От: \(fromStationName) до \(toStationName) маршруты не найдены", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let alert = UIAlertController(title: "Маршрут", message: "От: \(fromStationName) до \(toStationName) кратчайший маршрут: \(route)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension SearchVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // returns the number of 'columns' to display
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MetroModel.names.count
    }
    
    // configure items inside picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MetroModel.names[row]
    }
    
    // handle choose of element
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if fromStationTextFiled.isFirstResponder {
            fromStationTextFiled.text = MetroModel.names[row]
            fromStationTextFiled.resignFirstResponder()
        } else {
            toStationTextFiled.text = MetroModel.names[row]
            toStationTextFiled.resignFirstResponder()
        }
    }
    
}










