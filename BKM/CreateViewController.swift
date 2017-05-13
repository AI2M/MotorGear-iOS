//
//  CreateViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 3/28/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleMaps
import GooglePlaces
import CoreLocation



class CreateViewController: UIViewController ,CLLocationManagerDelegate ,GMSAutocompleteViewControllerDelegate,GMSMapViewDelegate {

    @IBOutlet weak var googleMapView: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longtitude: UITextField!
    
    var locationManager = CLLocationManager()
    
    var ref : FIRDatabaseReference!
    
    
    
    @IBAction func back(_ sender: Any) {
        UserDetail()
        dismiss(animated: true, completion: nil)
    }
    func UserDetail() {
        let Name = name.text as AnyObject
        let Tel = tel.text as AnyObject
        let Longtitude = longtitude.text as AnyObject
        let Latitude = latitude.text as AnyObject

        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Name").setValue(Name)
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Tel").setValue(Tel)
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Longtitude").setValue(Longtitude)
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Latitude").setValue(Latitude)

        
        
    }

    
    override func viewDidLoad() {
         super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                if let temp1 = snapshot.childSnapshot(forPath: "Name").value {
                    self.name.text = temp1 as? String
                }
                if let temp2 = snapshot.childSnapshot(forPath: "Tel").value {
                    self.tel.text = temp2 as? String
                }
                if let temp3 = snapshot.childSnapshot(forPath: "Latitude").value {
                    self.latitude.text = temp3 as? String
                }
                if let temp4 = snapshot.childSnapshot(forPath: "Longtitude").value {
                    self.longtitude.text = temp4 as? String
                }
                
            }
        })
        
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        self.showCurrentlocation()
        self.locationManager.stopUpdatingLocation()
    }
    func showCurrentlocation(){
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)! , longitude: (self.locationManager.location?.coordinate.longitude)! , zoom: 18)
        
        
        let mapView = GMSMapView.map(withFrame: self.googleMapView.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        self.googleMapView.addSubview(mapView)
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.snippet = tel.text
        marker.title = name.text
        marker.map = mapView
        self.googleMapView.addSubview(mapView)
        
        
        print("โลเคชั่น")
        print((marker.position.latitude), " และ ", (marker.position.longitude))

       

        latitude.text = "\((marker.position.latitude))"
        longtitude.text = "\((marker.position.longitude))"
        
        
    }

    
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 18.0)
        //self.googleMapView.camera = camera
        let mapView = GMSMapView.map(withFrame: self.googleMapView.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        self.googleMapView.addSubview(mapView)
        self.dismiss(animated: true, completion: nil) //  dissmis after select place
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AutoComplete\(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) //when cancle search
        
    }
    
    
   
    @IBAction func searchAddr(_ sender: UIBarButtonItem) {
        let autocomplete = GMSAutocompleteViewController()
        autocomplete.delegate = self
        
        self.locationManager.startUpdatingLocation()
        self.present(autocomplete, animated: true , completion: nil)
    }
    
   

    
   
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
