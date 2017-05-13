//
//  ItemStoreViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 4/26/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MessageUI

class ItemStoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var nagiGomap: UINavigationBar!
    @IBOutlet weak var ListView: UITableView!
    @IBOutlet weak var naviGomap: UINavigationItem!
    
    @IBAction func CallBtn(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://"+Tel)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    var name_item : [String] = [String]()
    var price_item : [String] = [String]()
   
    var ref : FIRDatabaseReference!
    var keys: String!
    var TitleName : String!
    var Type_Item :String!
    var Form: String!
    var Tel : String!
    var Latitude : String!
    var Longtitude : String!
    
    @IBOutlet weak var label_tel: UILabel!
    var Data : String!
    var Divide = [String]()
    var NameStore : String!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Form)
        DivineString()
        let when = DispatchTime.now() + 1 // change ... to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadTel()
            self.loadlalong()
            let when = DispatchTime.now() + 1 // change ... to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.navi.topItem?.title = self.TitleName
                self.label_tel.text = ("โทร: " + self.Tel)
                self.nagiGomap.isHidden = false
                self.loadName_item()
                self.loadPrice_item()

            }
            
            
        }

        
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func gotomap(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapStore") as? MapStoreViewController
        
        vc?.latitude = Latitude
        vc?.longtitude = Longtitude
        if Form == "Search"
        {
            vc?.name = Divide[0]
        }
        else if Form == "Garage"
        {
            vc?.name = NameStore
        }

       
        
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    func DivineString(){
        
        
        if Form == "Search"
        {
            Divide = Data.components(separatedBy: " -> ")
            Type_Item = Divide[1]
            //TitleName = ("ร้าน: " + Divide[0] + " ประเภท : " + Divide[1])
            TitleName = ("ร้าน: " + Divide[0])
            loadDataFirst()
        }
        else if Form == "Garage"
        {
            //TitleName = ("ร้าน: " + NameStore + " ประเภท : " + Type_Item)
            TitleName = ("ร้าน: " + NameStore)

        }
       
        
    }
    func loadTel(){
        ref = FIRDatabase.database().reference()
        ref.child("User").child(keys).child("Tel").observeSingleEvent(of: .value, with: { (snapshot) in
            self.Tel = snapshot.value as! String
            print(self.Tel)
           
        })
    }
    func loadlalong(){
        ref = FIRDatabase.database().reference()
        ref.child("User").child(keys).observeSingleEvent(of: .value, with: { (snapshot) in
            self.Latitude = snapshot.childSnapshot(forPath: "Latitude").value as! String
            print(self.Latitude)
            self.Longtitude = snapshot.childSnapshot(forPath: "Longtitude").value as! String
            print(self.Longtitude)

            
        })
    }

    
    func loadDataFirst(){
        ref = FIRDatabase.database().reference()
        ref.child("User").observe(.childAdded, with: { (snapshot) in
            
            let key = snapshot.key
            //let tel = snapshot.childSnapshot(forPath: "Tel").value as! String
            
            if self.Divide[0] == snapshot.childSnapshot(forPath: "Name").value as! String
            {
                self.keys = key
                
            }
            
        }, withCancel: nil)
        
    }


    func loadName_item()
    {
        ref = FIRDatabase.database().reference()
        ref.child("User").child(keys).child("Item").child(Type_Item).observeSingleEvent(of: .value, with: { (snapshot) in
            self.name_item.removeAll()
            
            for i in snapshot.children.allObjects{
                self.name_item.append((i as AnyObject).key)
            }
            self.ListView.reloadData()
        })
    }

    func loadPrice_item()
    {
        ref = FIRDatabase.database().reference()
        ref.child("User").child(keys).child("Item").child(Type_Item).observeSingleEvent(of: .value, with: { (snapshot) in
            self.price_item.removeAll()
            if snapshot.exists()
            {
                for i in 0...self.name_item.count-1{
                    if let temp = snapshot.childSnapshot(forPath: self.name_item[i]).value {
                        self.price_item.append(temp as! String)
                    }
                    
                }
                self.ListView.reloadData()
                
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = name_item[indexPath.row]
        cell.detailTextLabel?.text = "Price : " + price_item[indexPath.row] + " ฿."
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return price_item.count
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowVc" {
//            if let indexPath = self.ListView.indexPathForSelectedRow {
//                
//                let  = Type_name
//                if let destination = segue.destination as? StoreViewController {
//                    destination.NameAndItem = txt
//                }
//
//                
//            }
//        }
//        
//        
//    }
    

    

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
