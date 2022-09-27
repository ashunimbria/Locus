//
//  FormData.swift
//  LocusTestApp
//
//  Created by Ashish Nimbria on 26/09/22.
//

import Foundation

struct FormData: Codable {
    let type: FormType
    let id: String
    var title: String
    var dataMap: DataMap?
    
    mutating func updateTitle(newTitle: String) {
        self.title = newTitle
    }
    
    mutating func updateDataMap(dataMap: DataMap) {
        self.dataMap = dataMap
    }
}

struct DataMap: Codable {
    let options: [String]?
}

struct SampleRecord: Codable {
    let formData: [FormData]
}
