//
//  testViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 4/20/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
       // loginButton.delegate = self
        //loginButton.readPermissions = ["email", "public_profile"]
        
        
        
//        let customFBButton = UIButton(type: .system)
//        customFBButton.backgroundColor = .blue
//           customFBButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
//          customFBButton.setTitle("Custom FB Login", for: .normal)
//         customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        customFBButton.setTitleColor(.white, for: .normal)
//        view.addSubview(customFBButton)
//       
//        customFBButton.addTarget(self, action: #selector(handlecustomFblogin), for: .touchUpInside)
        
    }
//    
//    func handlecustomFblogin()
//    {
//        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
//            if err != nil{
//                print("custom login  error :", err!)
//                return
//            }
//            
//            //self.showEmail()
//        }
//    }
//    
    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("logout sucess")
//    }
//    
//    
//    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil{
//            print(error)
//            return
//        }
//      //  showEmail()
//    }
    
//    func showEmail(){
//        
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["feilds": "id, name, email"]).start { (connection, result, err) in
//            
//            if err != nil{
//                print("failed to start", err ?? "" )
//                return
//            }
//            print(result ?? "")
//        }
//        
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
