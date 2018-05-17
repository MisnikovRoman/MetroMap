//
//  Matrix.swift
//  test-wave-algoritm
//
//  Created by Роман Мисников on 09.05.2018.
//  Copyright © 2018 Роман Мисников. All rights reserved.
//

import Foundation

class Matrix<T> {
      
    var matrix:[[T]] = []
    public private(set) var rows: Int = 0
    public private(set) var columns: Int = 0
    
    // конструктор
    init (columns: Int, rows: Int, with repeatingElement: T) {
        
        self.columns = columns
        self.rows = rows
        
        // create single row with "columns" elements
        let row = Array(repeating: repeatingElement, count: columns)
        // create array of "row"-s
        let matrix = Array(repeating: row, count: rows)
        
        self.matrix = matrix
    }

    // инициализация сразу матрицей
    init (_ matrix: [[T]]) {

        guard matrix.count > 0 else { return }
        guard matrix[0].count > 0 else { return }
        
        self.matrix = matrix
        self.rows = matrix.count
        self.columns = matrix[0].count
    }
    
    // add subscripting to allow access to matrix by matrix[i] OR matrix[i][j]
    subscript(column: Int, row: Int) -> T {
        
        get {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            return matrix[row][column]
        }
        set {
            assert(indexIsValid(column: column, row: row), "Index out of range")
            matrix[row][column] = newValue
        }
    }
    
    subscript(point: Point) -> T {
    
        get {
            assert(indexIsValid(column: point.x, row: point.y), "Index out of range")
            return matrix[point.y][point.x]
        }
        set {
            assert(indexIsValid(column: point.x, row: point.y), "Index out of range")
            matrix[point.y][point.x] = newValue
        }
    }
    
    // test entered index
    func indexIsValid(column: Int, row: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    // вывод значений матрицы в консоль
    func printSimpleMatrix() {
        for item in matrix {
            print(item)
        }
    }
    
    // взять отдельный столбец
    func getColumn(index: Int) -> [T]? {
        
        guard index < columns else { return nil }
        guard index >= 0 else { return nil }
        
        var result: [T] = []
        
        for i in 0..<columns {
            result.append(self[index, i])
        }
        
        return result
    }
    
    // взять отдельную строку
    func getRow(index: Int) -> [T]? {
        
        guard index < rows else { return nil }
        guard index >= 0 else { return nil }
        
        return matrix[index]
    }
    
    func printFormatMatrix(number: Int) {
        // Example: printFormatMatrix(number: 3)
        //    -1 -1 -1 -1 -1 -1
        //    -1  0  0  0  0 -1
        //    -1  0  0  0  0 -1
        //    -1 -1 -1 -1 -1 -1
        
        for i in 0..<rows {
            for j in 0..<columns{
                let temp = matrix[i][j]
                let stringTemp = "\(temp)"
                let charCnt = stringTemp.count
                
                guard number >= charCnt else { return }
                let spacesCnt = number - charCnt
                let outNumber = String(Array(repeating: " ", count: spacesCnt)) + stringTemp 
                
                print(outNumber, separator: " ", terminator: "")
            }
            print("\n", terminator: "")
        }
    
    
    
    
    }
    
    
}
