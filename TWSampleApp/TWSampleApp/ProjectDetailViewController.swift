//
//  ProjectDetailViewController.swift
//  TWSampleApp
//
//  Created by apple on 8/2/17.
//  Copyright © 2017 teamwork. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var projectDictionary = [String: Any]()
    
    var keys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        keys = Array(projectDictionary.keys)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectDictionary.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath)
        
        let dicKey = keys[indexPath.row]
        
        cell.textLabel?.text = dicKey
        
        if let strValue = (projectDictionary[dicKey] as? String) {
            cell.detailTextLabel?.text = strValue
        }
        if let flagValue = (projectDictionary[dicKey] as? Bool) {
            cell.detailTextLabel?.text = String(flagValue)
        }
        if (projectDictionary[dicKey] as? Date) != nil {
            let date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from:date as Date)
            cell.detailTextLabel?.text = dateString
        }
        
        return cell
    }
}
