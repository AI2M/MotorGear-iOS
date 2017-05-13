//
//  MapStoreViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 5/10/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import GoogleMaps

class MapStoreViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    @IBOutlet weak var googlemapview: UIView!
    
    @IBOutlet weak var naviga: UINavigationBar!
    var latitude : String!
    var longtitude : String!
    var name:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let la = (latitude! as NSString).doubleValue
        let long = (longtitude! as NSString).doubleValue
        naviga.topItem?.title  = ("ร้าน : " + name)
        let camera = GMSCameraPosition.camera(withLatitude: la, longitude: long, zoom: 19.0)
        let mapView = GMSMapView.map(withFrame: self.googlemapview.bounds, camera: camera)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: la, longitude: long)
        marker.title = name
        marker.map = mapView
        self.googlemapview.addSubview(mapView)


        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
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
