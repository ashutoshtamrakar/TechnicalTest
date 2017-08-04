//
//  LoginViewController.swift
//  TWSampleApp
//
//  Created by apple on 8/3/17.
//  Copyright © 2017 teamwork. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var isUserAuthenticated = false
    
    lazy var networkCommunication = NetworkCommunication()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.handle(withNotification:)), name: NSNotification.Name(rawValue: "UserAuthentication"), object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "UserAuthentication"), object: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    open override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if isUserAuthenticated {
            return true
        }
        return false
    }


    @IBAction func buttonActionLogin(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Alert!", message:"", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in }))
        
        guard let usernameStr = tfUserName.text, let passwordStr = tfPassword.text,
                (tfUserName.text?.characters.count)! > 0, (tfPassword.text?.characters.count)! > 0 else {
            alertController.message = "Credentials cannot be empty"
            self.present(alertController, animated: true, completion: { })
            return
        }
        
        activityIndicatorView.startAnimating()
        
        // Authenticate user.
        networkCommunication.authenticateUser(username: usernameStr, password: passwordStr)
    }
    
    
    func handle(withNotification notification : NSNotification) {
        
        isUserAuthenticated = ((notification.userInfo? ["UserAuthentication"]) != nil)
        
        DispatchQueue.global(qos: .background).async {
            if self.isUserAuthenticated {
                self.networkCommunication.getProjects(withStatus: "ALL")
                //self.networkCommunication.getProjects(withStatus: "ACTIVE")
            }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.hidesWhenStopped = true
                
                if self.isUserAuthenticated {
                    self.performSegue(withIdentifier: "ProjectsListVCIdentifier", sender: self)
                } else {
                    let alertController = UIAlertController(title: "Alert!", message:"Could not authenticate", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in }))
                    self.present(alertController, animated: true, completion: { })
                }
            }
        }
    }
}
