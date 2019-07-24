//
//  imageVC.swift
//  ParseFoursclone1
//
//  Created by MacBookPro on 28.05.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit
import Parse

var globalName = ""
var globalType = ""
var globalAtmosphere = ""
var globalImage = UIImage()

class imageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placenameText: UITextField!
    @IBOutlet weak var placetypeText: UITextField!
    @IBOutlet weak var placeatmosphereText: UITextField!
    @IBOutlet weak var placeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        globalName = ""
        globalType = ""
        globalAtmosphere = ""
        globalImage = UIImage()
    }
    
    
    @IBAction func selectClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        
        if placenameText.text != "" && placetypeText.text != "" && placeatmosphereText.text != "" {
            
            if let chosenImage = placeImage.image {
                globalImage = chosenImage
                globalName = placenameText.text!
                globalType = placetypeText.text!
                globalAtmosphere = placeatmosphereText.text!
                performSegue(withIdentifier: "fromimageVCtomapVC", sender: nil)
                placenameText.text = ""
                placetypeText.text = ""
                placeatmosphereText.text = ""
                placeImage.image = UIImage(named: "")
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Choose Image", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Fill in the blanks!", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
        
    @IBAction func cancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
