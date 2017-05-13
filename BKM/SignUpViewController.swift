//
//  SignUpViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 3/17/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class SignUpViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    

    @IBOutlet weak var Username: UITextField!

    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var Password: UITextField!
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    @IBAction func Sign_up(_ sender: Any) {
        if Username.text == "" {
            let alertController = UIAlertController(title: "ผิดพลาด", message: "กรุณาใส่ email และ password ให้ครบ", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            FIRAuth.auth()?.createUser(withEmail: Username.text!, password: Password.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                      FIRAuth.auth()?.signIn(withEmail: self.Username.text!, password: self.Password.text!)
                     self.UserDetail()
        
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "ผิดพลาด", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    func UserDetail() {
       
        let UserDetail : [String: AnyObject] = ["Name" : "" as AnyObject,
                                                "Email" : FIRAuth.auth()?.currentUser?.email as AnyObject,
                                                "Tel" : "" as AnyObject,
                                                "Longtitude" : "" as AnyObject,
                                                "Latitude" : "" as AnyObject]
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("User").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(UserDetail)
        
    }
    
    //google login
    
    fileprivate func SetupGoogleButton(){
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookBtn.addTarget(self, action: #selector(handleGoogleSign), for: .touchUpInside)
        
        
    }
    

    
    func handleGoogleSign(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error
        {
            print("error log in into google ",err)
            return
        }
        print("sucessfully login with google ",user)
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error{
                print("error to create firebase account with google :",err)
                return
            }
            guard let uid = user?.uid else {return}
            print("successfully to create account in firebase",uid)
            self.UserDetail()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
            self.present(vc!, animated: true, completion: nil)
            
            
        })
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }



    

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
       SetupGoogleButton()
        //SetupfacebookButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //facebook login
    
//    fileprivate func SetupfacebookButton(){
//        facebookBtn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
//        
//        
//    }
//    
//    func handleCustomFBLogin() {
//        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
//            if err != nil {
//                print("Custom FB Login failed:", err ?? "" )
//                return
//            }
//            
//            self.showEmailAddress()
//            self.UserDetail()
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
//            self.present(vc!, animated: true, completion: nil)
//        }
//       
//    }
//
//    func showEmailAddress() {
//        let accessToken = FBSDKAccessToken.current()
//        guard let accessTokenString = accessToken?.tokenString else { return }
//        
//        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
//        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
//            if error != nil {
//                print("Something went wrong with our FB user: ", error ?? "")
//                return
//            }
//            
//            print("Successfully logged in with our user: ", user ?? "")
//        })
//        
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
//            
//            if err != nil {
//                print("Failed to start graph request:", err ?? "")
//                return
//            }
//            print(result ?? "")
//        }
//    }
//    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print(error)
//            return
//        }
//        
//        showEmailAddress()
//    }
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("logout")
//    }
//
//
//

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
