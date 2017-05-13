//
//  AddItemViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 3/29/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class AddItemViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var type_item: UITextField!
    @IBOutlet weak var price_item: UITextField!
    @IBOutlet weak var name_item: UITextField!
    @IBOutlet weak var pickerType: UIPickerView!
    var ref : FIRDatabaseReference!
    var item : [String] = ["เลื่อนเพื่อเลือกประเภท"]
    
    func reloadData(){
        ref = FIRDatabase.database().reference()
        ref.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Item").observeSingleEvent(of: .value, with: { (snapshot) in
            self.item.removeAll()
            self.item.append("เลื่อนเพื่อเลือกประเภท")
            for i in snapshot.children.allObjects{
                self.item.append((i as AnyObject).key)
            }
            self.pickerType.reloadAllComponents()
        })

        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return item[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return item.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if item[row] == "เลื่อนเพื่อเลือกประเภท"{
        type_item.text =  ""
        }
        else{
            type_item.text = item[row]
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        
    }
    
    @IBAction func add_item(_ sender: Any) {
        
        if (name_item.text == "" || price_item.text == ""||type_item.text == "")
        {
            let alertController = UIAlertController(title: "ผิดพลาด!", message: "กรุณากรอกข้อมูลให้ครบ", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            addItem()
            reloadData()
            name_item.text = ""
            price_item.text = ""
            type_item.text = ""
        }
        
        
        
    }
    
    func addItem(){
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).child("Item").child(type_item.text!).child(name_item.text!).setValue(price_item.text)
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
