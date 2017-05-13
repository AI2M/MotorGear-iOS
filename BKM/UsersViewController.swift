//
//  UsersViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 4/1/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

class UsersViewController: UIViewController , CLLocationManagerDelegate,GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate{
    
    @IBOutlet weak var goBtn: UIButton!
   
  
    @IBOutlet weak var googleMapView: UIView!
    let locationManager = CLLocationManager()
    var ref : FIRDatabaseReference!
    
    var name_all : [String] = [String]()
    var email_all : [String] = [String]()
    var tel_all : [String] = [String]()
    var latitude_all: [String] = [String]()
    var longtitude_all : [String] = [String]()
    var item_all : [String] = [String]()
    var key_all : [String] = [String]()
    var keys : String?
    
    var la : Double = 0.0
    var long : Double = 0.0
    
    var shop_latitude : String?
    var shop_longtitude : String?
    
    var Store_name:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FindLocation()
        //FIRAuth.auth()?.signIn(withEmail: "admin@cmu.com", password: "123456")
        
        let when = DispatchTime.now() + 5 // change ... to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.googleMapView.isHidden = false
        
            self.goBtn.isHidden = false

            // Your code with delay
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
           // print(self.key_all)
        }
    
    }
    
   
    func loadDataFirst(){
        ref = FIRDatabase.database().reference()
        ref.child("User").observe(.childAdded, with: { (snapshot) in
            
            let key = snapshot.key
            //let tel = snapshot.childSnapshot(forPath: "Tel").value as! String
            
            if self.Store_name == snapshot.childSnapshot(forPath: "Name").value as! String
            {
                self.keys = key
                
            }
            
        }, withCancel: nil)
        
    }

    
    
    @IBAction func GotoGarage(_ sender: Any) {
        if Store_name != ""
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Garage") as? Store2ViewController
            vc?.name = Store_name
            vc?.key = keys
            self.present(vc!, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "ผิดพลาด", message: "กรุณาเลือกร้านค้า", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func FindLocation(){
        ref = FIRDatabase.database().reference()
        ref.child("User").observe(.childAdded, with: { (snapshot) in
            
            let name = snapshot.childSnapshot(forPath: "Name").value
            let email = snapshot.childSnapshot(forPath: "Email").value
            let tel = snapshot.childSnapshot(forPath: "Tel").value
            let latitude = snapshot.childSnapshot(forPath: "Latitude").value
            let longtitude = snapshot.childSnapshot(forPath: "Longtitude").value
            let key = snapshot.key
            
            self.name_all.append(name as! String)
            self.email_all.append(email as! String)
            self.tel_all.append(tel as! String)
            self.latitude_all.append(latitude as! String)
            self.longtitude_all.append(longtitude as! String)
            self.key_all.append(key)
        
            
        }, withCancel: nil)
        
    }
    
    
    func showCurrentlocation(){
       let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)! , longitude: (self.locationManager.location?.coordinate.longitude)! , zoom: 11)
        
        
        let mapView = GMSMapView.map(withFrame: self.googleMapView.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
    
        //mark point
        for i in (0..<name_all.count).reversed()
        {
            la = (latitude_all[i] as NSString).doubleValue
            long = (longtitude_all[i] as NSString).doubleValue
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: la, longitude: long)
            marker.title = name_all[i]
            marker.snippet = tel_all[i]
            marker.map = mapView
   
        }
        self.googleMapView.addSubview(mapView)
        
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        Store_name = marker.title ?? ""
        print(Store_name)
        loadDataFirst()
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("tab anana")
        Store_name = ""
    }
    
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentlocation()
        self.locationManager.stopUpdatingLocation()

       
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
    
        let mapView = GMSMapView.map(withFrame: self.googleMapView.bounds, camera: camera)
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        //mark point
        for i in (0..<name_all.count).reversed()
        {
            la = (latitude_all[i] as NSString).doubleValue
            long = (longtitude_all[i] as NSString).doubleValue
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: la, longitude: long)
            marker.title = name_all[i]
            marker.snippet = tel_all[i]
            marker.map = mapView
            
        }

        self.googleMapView.addSubview(mapView)
        self.dismiss(animated: true, completion: nil) //  dissmis after select place
        
    }
    @IBAction func SearchItem(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchItem")
        self.present(vc!, animated: true, completion: nil)

    

    }
    
    @IBAction func searchAddr(_ sender: UIBarButtonItem) {
        
        let autocomplete = GMSAutocompleteViewController()
        autocomplete.delegate = self
        
        self.locationManager.startUpdatingLocation()
        self.present(autocomplete, animated: true , completion: nil)
    }
    
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) //when cancle search
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AutoComplete\(error)")
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
