//
//  ListViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 3/29/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var listView: UITableView!
    var type_item : [String] = [String]()
    var ref : FIRDatabaseReference!
    var del : String!
    
    func loadData(){
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Item").observeSingleEvent(of: .value, with: { (snapshot) in
            self.type_item.removeAll()
            
            for i in snapshot.children.allObjects{
                self.type_item.append((i as AnyObject).key)
            }
            self.listView.reloadData()
        })
    }
    
    
    func deleteData(){
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Item").child(del).removeValue()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        //FIRAuth.auth()?.signIn(withEmail: "arm@cmu.com", password: "123456")
        
        // Do any additional setup after loading the view.
    }
    
     
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        //print(type_item)

        
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Itemlist") as? ItemViewController
        
        vc?.Type_name = type_item[indexPath[1]]
        print( type_item[indexPath.row])
        self.present(vc!, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete") { (action, indexPath) -> Void in
            self.deleteData()
            self.type_item.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        //print(type_item[indexPath.row])
        del = type_item[indexPath.row]
        deleteAction.backgroundColor = UIColor.red
       
        
        return [deleteAction]
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
