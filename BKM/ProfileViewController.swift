//
//  ProfileViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 3/29/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import GoogleMaps
import CoreLocation

class ProfileViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var googleMapView: UIView!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longtitude: UILabel!
    @IBAction func LogoutBtn(_ sender: Any) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        
        self.present(vc!, animated: true, completion: nil)
            

    }
    
    var pin_name: String?
    var pin_tel: String?
    var la : Double = 0.0
    var long : Double = 0.0
    //var la: CLLocationDegrees  = 0.0
   // var long: CLLocationDegrees = 0.0
    
    @IBAction func editProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Create")
        self.present(vc!, animated: true, completion: nil)
    }
    
    var ref : FIRDatabaseReference!
    
    func loadData()
    {
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists()
            {
                if let temp = snapshot.childSnapshot(forPath: "Name").value {
                    self.name.text = temp as? String
                    self.pin_name = temp as? String
                }
                if let temp = snapshot.childSnapshot(forPath: "Tel").value {
                    self.tel.text = "Tel:" + (temp as? String)!
                    self.pin_tel = temp as? String
                }
                if let temp = snapshot.childSnapshot(forPath: "Latitude").value {
                    self.latitude.text = "Latitude:" + (temp as? String)!
                    self.la = (temp as! NSString).doubleValue
                }
                if let temp = snapshot.childSnapshot(forPath: "Longtitude").value {
                    self.longtitude.text = "Longtitude:" + (temp as? String)!
                    self.long = (temp as! NSString).doubleValue
                    
                }
                if let temp = snapshot.childSnapshot(forPath: "Email").value {
                    self.email.text = temp as? String
                }
                
                
                let camera = GMSCameraPosition.camera(withLatitude: self.la, longitude: self.long, zoom: 15.0)
                let mapView = GMSMapView.map(withFrame: self.googleMapView.bounds, camera: camera)
                
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: self.la, longitude: self.long)
                marker.title = self.pin_name
                marker.snippet = self.pin_tel
                marker.map = mapView
                self.googleMapView.addSubview(mapView)

                
                
            }
        })
        
        name.isHidden = false
        tel.isHidden = false
        email.isHidden = false
        latitude.isHidden = false
        longtitude.isHidden = false
        
      
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
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
