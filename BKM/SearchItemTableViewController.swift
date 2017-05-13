//
//  SearchItemTableViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 4/24/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchItemTableViewController: UITableViewController,UISearchResultsUpdating {
    
    @IBAction func BackToUser(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var name_all : [String] = [String]()
    var keyOf_all : [String] = [String]()
    var tel_all : [String] = [String]()
    var item_all:  [String] = [String]()
   

    var ref : FIRDatabaseReference!
    var ref2 : FIRDatabaseReference!
    var filter = [String]()
    var resultSearch = UISearchController()
    
    
    func loadData(){
       
        ref = FIRDatabase.database().reference()
        ref2 = FIRDatabase.database().reference()
        ref.child("User").observe(.childAdded, with: { (snapshot) in
            
            let name = snapshot.childSnapshot(forPath: "Name").value
            let tel = snapshot.childSnapshot(forPath: "Tel").value
            let key = snapshot.key
            
            self.keyOf_all.append(key)
            self.name_all.append(name as! String)
            self.tel_all.append(tel as! String)
            
        }, withCancel: nil)
        
    }
    
    func getfilter(){
        
        for i in keyOf_all{
            ref.child("User").child(i).observe(.value, with: { (snapshot2) in
                
                for j in snapshot2.childSnapshot(forPath: "Item").children.allObjects{
                    
                    let name = snapshot2.childSnapshot(forPath: "Name").value as! String
                    let item2 = (  name + " -> " + (j as AnyObject).key)
                    self.item_all.append(item2)
                }

                
            })
            
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        let when = DispatchTime.now() + 2 // change ... to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.getfilter()
            let when = DispatchTime.now() + 1 // change ... to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                self.resultSearch = UISearchController(searchResultsController: nil)
                self.resultSearch.searchResultsUpdater = self
                
                self.resultSearch.dimsBackgroundDuringPresentation = false
                self.definesPresentationContext = true
                self.resultSearch.searchBar.sizeToFit()
                self.tableView.tableHeaderView = self.resultSearch.searchBar
                self.tableView.reloadData()

            }
        }

        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.resultSearch.isActive
        {
            return self.filter.count
        }
        else{
            return self.item_all.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell?
        
        if self.resultSearch.isActive
        {
            cell!.textLabel?.text = self.filter[indexPath.row]
        }
        else
        {
            cell!.textLabel?.text = self.item_all[indexPath.row]
        }

        return cell!
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearch_1" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                if self.resultSearch.isActive
                {
                    let txt = filter[indexPath.row]
                    if let destination = segue.destination as? ItemStoreViewController {
                        destination.Data = txt
                        destination.Form = "Search"
                    }

                }
                else
                {
                    let txt = item_all[indexPath.row]
                    if let destination = segue.destination as? ItemStoreViewController {
                        destination.Data = txt
                        destination.Form = "Search"
                    }

                }
                
            }
        }
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filter.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array  =  (self.item_all as NSArray).filtered(using: searchPredicate)
        self.filter = array as! [String]
        self.tableView.reloadData()

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
