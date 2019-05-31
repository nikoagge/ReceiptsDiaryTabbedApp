//
//  DatabaseService.swift
//  ReceiptsDiaryTabbedApp 1.0
//
//  Created by Nikolas on 30/05/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import Foundation
import SQLite


class DatabaseService {
    
    
    static let sharedInstance = DatabaseService()
    
    var databaseConnection: Connection!
    
    let receiptsImageDataTable = Table("receiptsImageDataTable")
    let receiptsImageDataTableIdColumn = Expression<Int>("receiptsImageDataTableIdColumn")
    let receiptsImageDataTableImageDataColumn = Expression<Data>("receiptsImageDataTableImageDataColumn")
    
    
    func connectToDatabase() {
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("receiptsDatabase").appendingPathExtension("sqlite3")
            
            let db = try Connection(fileUrl.path)
            
            databaseConnection = db
        } catch {
            
            print(error)
        }
    }
    
    
    private func checkIfReceiptsImageDataTableExist() -> Bool {
        
        var returnValue = Bool()
        
        do {
            
            try self.databaseConnection.scalar(self.receiptsImageDataTable.exists)
            
            returnValue = true
        } catch {
            
            returnValue = false
        }
        
        return returnValue
    }
    
    
    func createReceiptsImageDataTable() {
        
        let createReceiptsImageDataTable = receiptsImageDataTable.create { (table) in
            
            table.column(receiptsImageDataTableIdColumn, primaryKey: true)
            table.column(receiptsImageDataTableImageDataColumn)
        }
        
        do {
            
            try self.databaseConnection.run(createReceiptsImageDataTable)
            
            print("Receipts table created.")
        } catch {
            
            print(error)
        }
    }
    
    
    func insertNewReceiptImageDataRecord(forReceiptImageData receiptImageData: Data) {
        
        if !checkIfReceiptsImageDataTableExist() {
            
            createReceiptsImageDataTable()
        }
        
        let insertReceiptImageDataRecord = self.receiptsImageDataTable.insert(self.receiptsImageDataTableImageDataColumn <- receiptImageData)
        
        do {
            
            try self.databaseConnection.run(insertReceiptImageDataRecord)
        } catch {
            
            print(error)
        }
    }
    
    
    func getAllReceiptImages() -> [UIImage] {
        
        var imagesReturnedArray = [UIImage]()
        
        do {
            
            for receiptsImageDataTableRow in try self.databaseConnection.prepare(receiptsImageDataTable.select(receiptsImageDataTableImageDataColumn)) {
                
                if let imageData = receiptsImageDataTableRow[receiptsImageDataTableImageDataColumn] as? Data {
                    
                    imagesReturnedArray.append(UIImage(data: imageData)!)
                }
            }
        } catch {
            
            print(error)
        }
        
        return imagesReturnedArray
    }
}
