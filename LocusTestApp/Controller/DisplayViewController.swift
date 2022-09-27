//
//  DisplayViewController.swift
//  LocusTestApp
//
//  Created by Ashish Nimbria on 26/09/22.
//

import UIKit

class DisplayViewController: UIViewController {
    
    var formDataArray: [FormData] = [FormData]()
    var customInputFormData: [FormData] = [FormData]()
    var manager: DataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Display IDs"
        setDataToTableView()
    }
    
    private func setDataToTableView() {
        guard let manager = manager else {
            return
        }
        let jsonData = manager.readLocalJSONFile(forName: "myJson")
        if let data = jsonData {
            if let sampleRecord = manager.parse(jsonData: data, resultType: FormData.self) {
                self.formDataArray = sampleRecord
                self.formDataArray.append(contentsOf: customInputFormData)
            }
        }
    }
}

extension DisplayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FormDataCell", for: indexPath)
        cell.textLabel?.text = formDataArray[indexPath.row].id
        return cell
    }
}
