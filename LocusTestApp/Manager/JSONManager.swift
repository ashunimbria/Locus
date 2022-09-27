//
//  JSONManager.swift
//  LocusTestApp
//
//  Created by Ashish Nimbria on 26/09/22.
//

import Foundation

protocol DataManager {
    func readLocalJSONFile(forName name: String) -> Data?
    func parse<T: Decodable>(jsonData: Data, resultType: T.Type) -> [T]?
}

class JSONManager: DataManager {
    
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    func parse<T: Decodable>(jsonData: Data, resultType: T.Type) -> [T]? {
        do {
            let decodedData = try JSONDecoder().decode([T].self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
