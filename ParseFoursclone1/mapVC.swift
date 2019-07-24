//
//  mapVC.swift
//  ParseFoursclone1
//
//  Created by MacBookPro on 28.05.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit
import MapKit
import Parse

class mapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var chosenLatitude = ""
    var chosenLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mapView.tintColor = .blue
        mapView.showsUserLocation = true
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapVC.chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.chosenLatitude = ""
        self.chosenLongitude = ""
    }
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touched = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touched, toCoordinateFrom: self.mapView)
            
            let annotatiton = MKPointAnnotation()
            annotatiton.coordinate = coordinates
            annotatiton.title = globalName
            annotatiton.subtitle = globalType
            
            
            self.mapView.addAnnotation(annotatiton)
            
            self.chosenLatitude =  String(coordinates.latitude)
            self.chosenLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)

        mapView.setRegion(region, animated: true)

    }
 

    @IBAction func saveClicked(_ sender: Any) {
        
        if chosenLatitude == "" && chosenLongitude == "" {
            let alert = UIAlertController(title: "Error", message: "Choose Location!", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let object = PFObject(className: "Places")
            object["name"] = globalName
            object["type"] = globalType
            object["atmosphere"] = globalAtmosphere
            object["latitude"] = self.chosenLatitude
            object["longitude"] = self.chosenLongitude
            
            if let imageData = globalImage.jpegData(compressionQuality: 0.5) {
                object["image"] = PFFileObject(name: "image.jpg", data: imageData)
            }
            object.saveInBackground { (succes, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "frommapVCtoplacesVC", sender: nil)
                }
            }
        }
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
