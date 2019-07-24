//
//  placesVC.swift
//  ParseFoursclone1
//
//  Created by MacBookPro on 28.05.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit
import Parse
import LocalAuthentication

class placesVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    
    var chosenPlace = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    func getData() {
        
        let query = PFQuery(className: "Places")

        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                for object in objects! {
                    self.placeNameArray.append(object.object(forKey: "name") as! String)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        let query = PFQuery(className: "Places")
        query.whereKey("name", equalTo: self.chosenPlace)
            query.findObjectsInBackground { (objects, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    for object in objects! {
                        
                        self.placeNameArray.remove(at: indexPath.row)
                       
                        self.tableView.reloadData()
            }
         }
        
     }
   }
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.chosenPlace = self.placeNameArray[indexPath.row]
        self.performSegue(withIdentifier: "fromplacesVCtodetailsVC", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromplacesVCtodetailsVC" {
            let destinationVC = segue.destination as! detailsVC
            destinationVC.selectedPlace = self.chosenPlace
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "• \(placeNameArray[indexPath.row])"
        return cell
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
    
        PFUser.logOutInBackground { (error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                
                UserDefaults.standard.removeObject(forKey: "user")
                UserDefaults.standard.synchronize()
                
                let signVC = self.storyboard?.instantiateViewController(withIdentifier: "signVC") as! signVC
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = signVC
                delegate.rememberUser()
            }
        }
            }
    
    @IBAction func addClicked(_ sender: Any) {
        performSegue(withIdentifier: "fromplacesVCtoimageVC", sender: nil)
    } 

}
