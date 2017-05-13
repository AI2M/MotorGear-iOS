//
//  Store2ViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 4/26/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MessageUI

class Store2ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  

    @IBAction func CallBtn(_ sender: Any) {
        let url: NSURL = URL(string: "TEL://"+Tel)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
    }
    @IBOutlet weak var tableViews: UITableView!
    @IBOutlet weak var navi: UINavigationBar!
    
    @IBOutlet weak var label_tel: UILabel!
    var name: String!
    var key : String!
    var Tel: String!
    
    var type_item : [String] = [String]()
    var ref : FIRDatabaseReference!
    var ref2 : FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        loadTel()
        let when = DispatchTime.now() + 0.4 // change ... to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.label_tel.text = ("โทร: " + self.Tel)
            self.navi.topItem?.title = ("ร้าน: " + self.name)
        }

        
        // Do any additional setup after loading the view.
    }

    func loadData(){
        
        ref = FIRDatabase.database().reference()
        ref.child("User").child(key).child("Item").observeSingleEvent(of: .value, with: { (snapshot) in
            self.type_item.removeAll()
            
            for i in snapshot.children.allObjects{
                self.type_item.append((i as AnyObject).key)
            }
            self.tableViews.reloadData()
        })
    }
    
    func loadTel(){
        ref = FIRDatabase.database().reference()
        ref.child("User").child(key).child("Tel").observeSingleEvent(of: .value, with: { (snapshot) in
            self.Tel = snapshot.value as! String
            print(self.Tel)
            
        })
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = type_item[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type_item.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ItemStore") as? ItemStoreViewController
        
        vc?.Type_Item = type_item[indexPath[1]]
        vc?.keys = key
        vc?.Form = "Garage"
        vc?.NameStore = name
       
        self.present(vc!, animated: true, completion: nil)
        
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
