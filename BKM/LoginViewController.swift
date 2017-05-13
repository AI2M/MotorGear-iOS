//
//  LoginViewController.swift
//  BKM
//
//  Created by Tongchai Tonsau on 3/31/2560 BE.
//  Copyright © 2560 Tongchai Tonsau. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    


   
    @IBOutlet weak var facebookLogin_Btn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBAction func fb_login_Btn(_ sender: Any) {
    }
    
    @IBAction func signupAc(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Sign_up")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func loginAc(_ sender: Any) {
        if self.Username.text == "" || self.Password.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "ผิดพลาด", message: "กรุณาใส่ email และ password ให้ครบ", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.Username.text!, password: self.Password.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "ผิดพลาด", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "ตกลง", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        SetupGoogleButton()
        GIDSignIn.sharedInstance().signOut()
        //SetupfacebookButton()
                // Do any additional setup after loading the view.
    }
    //google login
    
    fileprivate func SetupGoogleButton(){
        
       GIDSignIn.sharedInstance().uiDelegate = self
        facebookLogin_Btn.addTarget(self, action: #selector(handleGoogleSign), for: .touchUpInside)
        
        
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

    
//facebook login
    
//    fileprivate func SetupfacebookButton(){
//         facebookLogin_Btn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
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
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
//            self.present(vc!, animated: true, completion: nil)
//        }
//
//    }
//    
//    func showEmailAddress() {
//                let accessToken = FBSDKAccessToken.current()
//                guard let accessTokenString = accessToken?.tokenString else { return }
//        
//                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
//                FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
//                    if error != nil {
//                        print("Something went wrong with our FB user: ", error ?? "")
//                        return
//                    }
//        
//                    print("Successfully logged in with our user: ", user ?? "")
//                })
//        
//    FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
//            
//            if err != nil {
//                print("Failed to start graph request:", err ?? "")
//                return
//            }
//            print(result ?? "")
//        }
//    }
//
//
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Did log out of facebook")
//    }
//
//    
//      func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print(error)
//            return
//        }
//        
//        showEmailAddress()
//    }
//    
//    
//    
//    
//   
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        
//        return true
//    }
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
