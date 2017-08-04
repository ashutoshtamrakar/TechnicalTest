//
//  ViewController.swift
//  TWSampleApp
//
//  Created by apple on 8/2/17.
//  Copyright © 2017 teamwork. All rights reserved.
//

import UIKit


class ProjectsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    lazy var projectArray: Array<Any>? = []
    lazy var projectName: Array<String>? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProjectsListViewController.handle(withNotification:)), name: NSNotification.Name(rawValue: "Projects"), object: nil)
        
        activityIndicatorView.startAnimating()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Projects"), object: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.projectName != nil {
            return self.projectName!.count
        }
        return 0
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath)
        cell.textLabel?.text = projectName?[indexPath.row]
        
        return cell
    }
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let projectDetailViewController = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProjectDetailViewController") as? ProjectDetailViewController else {
                print("Instantiation Failed")
            return
        }
        let cell = tableView.cellForRow(at: indexPath)
        projectDetailViewController.title = cell?.textLabel?.text
        projectDetailViewController.projectDictionary = projectArray?[indexPath.row] as! [String : Any]
        self.navigationController?.pushViewController(projectDetailViewController, animated:true)
    }
    
    
    func handle(withNotification notification : NSNotification) {
        
        print("Notification: \(notification)")
        
        DispatchQueue.global(qos: .background).async {
            
            if let projectsDic = notification.userInfo {
                for (key, value) in projectsDic {
                    self.projectArray?.append(value)
                    self.projectName?.append(key as! String)
                }
            }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.hidesWhenStopped = true
                self.tableView.reloadData()
            }
        }
    }
}

