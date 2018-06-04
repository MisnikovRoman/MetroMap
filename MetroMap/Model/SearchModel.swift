//
//  SearchModel.swift
//  test-searchFunc
//
//  Created by Роман Мисников on 24.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

class SearchModel {
    
    static let instance = SearchModel()
    
    let stations = [
        "Автово", "Адмиралтейская", "Академическая", "Балтийская", "Бухарестская", "Василеостровская", "Владимирская", "Волковская", "Выборгская", "Горьковская", "Гостиный двор", "Гражданский проспект", "Девяткино", "Достоевская", "Елизаровская", "Звёздная", "Звенигородская", "Кировский завод", "Комендантский проспект", "Крестовский остров", "Купчино", "Ладожская", "Ленинский проспект", "Лесная", "Лиговский проспект", "Ломоносовская", "Маяковская", "Международная", "Московская", "Московские ворота", "Нарвская", "Невский проспект", "Новочеркасская", "Обводный канал", "Обухово", "Озерки", "Парк Победы", "Парнас", "Петроградская", "Пионерская", "Площадь Александра Невского 1", "Площадь Александра Невского 2", "Площадь Восстания", "Площадь Ленина", "Площадь Мужества", "Политехническая", "Приморская", "Пролетарская", "Проспект Большевиков", "Проспект Ветеранов", "Проспект Просвещения", "Пушкинская", "Рыбацкое", "Садовая", "Сенная площадь", "Спасская", "Спортивная", "Старая Деревня", "Технологический институт 1", "Технологический институт 2", "Удельная", "Улица Дыбенко", "Фрунзенская", "Чёрная речка", "Чернышевская", "Чкаловская", "Электросила"
    ]
    
    var foundedStations: [String] = []
    
    var lastSearchText = "x"

    func resetSearch() {
        lastSearchText = "x"
        foundedStations = []
    }
    
    func searchText(_ text: String) {
        // if field is blank - erase field
        if (text == "") { foundedStations = []; lastSearchText = "x"}
        
        // findAllSequences(input: searchText, array: stations, coincidenceCoefficient: 0.8)
        let smallSearchText = text.lowercased()
        // get 1st characters
        guard let firstSearchChar = smallSearchText.first else { return }
        guard let firstCharInLast = lastSearchText.first else { return }
        
        // if we entered 1 new symbol from right
        if smallSearchText.contains(lastSearchText), firstSearchChar == firstCharInLast, smallSearchText.count > lastSearchText.count {
            // no need to erase founded items
            for (index, name) in foundedStations.enumerated().reversed() {
                if !name.lowercased().contains(smallSearchText) {
                    foundedStations.remove(at: index)
                    let deleteIndexPath = IndexPath(row: index, section: 0)
                    // tableView.deleteRows(at: [deleteIndexPath], with: .top)
                }
            }
        } else {
            // erase all founded stations
            foundedStations = []
            // search throw all station and find
            for name in stations {
                if name.lowercased().contains(smallSearchText) {
                    // add founded station
                    foundedStations.append(name)
                }
            }
        }
        // save last search
        lastSearchText = smallSearchText
    }
}
