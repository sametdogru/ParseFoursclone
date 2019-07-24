//
//  signInVC.swift
//  ParseFoursclone1
//
//  Created by MacBookPro on 3.06.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit
import Parse

class signVC: UIViewController ,UITextFieldDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
        setUI()
        
        self.usernameText.delegate = self
        self.passwordText.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(signVC.dismissKeyboard))
   
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUI() {
        userNameView.layer.cornerRadius = 21
        passwordView.layer.cornerRadius = 21
        loginClicked.layer.cornerRadius = 21
        signUpClicked.layer.cornerRadius = 21
        
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: self.usernameText.text!, password: self.passwordText.text!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true
                        , completion: nil)
                } else {

                    UserDefaults.standard.set(self.usernameText.text!, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Username/Password", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true
                , completion: nil)
        }
    }
     
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            
            let user = PFUser()
            user.username = usernameText.text
            user.password = passwordText.text
            
            user.signUpInBackground { (success, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true
                        , completion: nil)
                } else {
                    UserDefaults.standard.set(self.usernameText.text!, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberUser()
                }
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Username/Password", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true
                , completion: nil)
        }
            
    }

    // UITextField Delegates
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginClicked: UIButton!
    @IBOutlet weak var signUpClicked: UIButton!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    
    
    
    
   }

