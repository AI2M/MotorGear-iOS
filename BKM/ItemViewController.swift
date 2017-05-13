//
//  ItemViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 3/30/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ItemViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var Navi: UINavigationBar!
    @IBOutlet weak var itemView: UITableView!
    var Type_name : String!
    var name_item : [String] = [String]()
    var price_item : [String] = [String]()
    var ref : FIRDatabaseReference!
    var test : String!
    var delname : String!
    var delprice : String!
    
    @IBAction func backBtn(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
//        
//        self.present(vc!, animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
    }
    func loadName_item()
    {
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Item").child(Type_name).observeSingleEvent(of: .value, with: { (snapshot) in
            self.name_item.removeAll()
            
            for i in snapshot.children.allObjects{
                self.name_item.append((i as AnyObject).key)
            }
                self.itemView.reloadData()
        })
    }
    
    func deleteData(){
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Item").child(Type_name).child(delname).removeValue()
    }
    
    func loadPrice_item()
    {
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Item").child(Type_name).observeSingleEvent(of: .value, with: { (snapshot) in
            self.price_item.removeAll()
            if snapshot.exists()
            {
                for i in 0...self.name_item.count-1{
                    if let temp = snapshot.childSnapshot(forPath: self.name_item[i]).value {
                        self.price_item.append(temp as! String)
                    }
                    
                }
                self.itemView.reloadData()
               
            }
        })
    }

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Navi.topItem?.title = Type_name
        loadName_item()
        loadPrice_item()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete") { (action, indexPath) -> Void in
            self.deleteData()
            self.name_item.remove(at: indexPath.row)
            self.price_item.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        //print(type_item[indexPath.row])
        delname = name_item[indexPath.row]
        delprice = price_item[indexPath.row]
        deleteAction.backgroundColor = UIColor.red
        
        
        return [deleteAction]
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
