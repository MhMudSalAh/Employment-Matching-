//
//  SignUpVC.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress
import DropDown

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imagePicker: UIImagePickerController! //variable
    var imageToUpload: UIImage?
    let dropDown = DropDown()  //constant
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.choseProfileImage))
        let keyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        profileImage.addGestureRecognizer(profileTapGesture)
        view.addGestureRecognizer(keyboardTapGesture)
        
        
        dropDown.anchorView = typeTextField
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = ["Freelancer" , "Company"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.typeTextField.text = item
        }
    }
    
    
    func choseProfileImage(sender: UITapGestureRecognizer) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToUpload = image
            profileImage.image = imageToUpload
        } else {
            print("image picker error")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func choseTypeBtnPressed(_ sender: Any) {
        
        dropDown.show()
    }
    
    
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        
        if imageToUpload == nil {
            alertError(message: "Please chose a profile Picture")
        } else if nameTextField.text == "" {
            alertError(message: "Please enter your name")
        } else if emailTextField.text == "" {
            alertError(message: "Please enter your email")
        } else if typeTextField.text == "" {
            alertError(message: "Please chose your account type")
        } else if (passwordTextField.text?.characters.count)! < 6 {
            alertError(message: "Please enter a password with 6 charachters or more")
        } else {
            
            ARSLineProgress.show()
            
            let imageData = UIImageJPEGRepresentation(self.imageToUpload!, 0.5)
            let imageUID = UUID().uuidString //random string
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            REF_PROFILE_PICS.child(imageUID).putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                
                if error != nil {
                    self.alertError(message: error!.localizedDescription)
                } else {
                    
                    print("profile image uploaded successfully")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    
                    Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                        if error != nil {
                            self.alertError(message: error!.localizedDescription)
                        } else {
                            print("Created account successfully")

                            REF_USERS.child((user?.uid)!).updateChildValues(["name": self.nameTextField.text!, "type":self.typeTextField.text!, "imageUrl": downloadUrl!])
                            
                            ARSLineProgress.hide()
                            
                            let alert = UIAlertController(title: "Success", message: "Your account was created successfully!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                                REF_CURRENT_USER = REF_USERS.child((Auth.auth().currentUser?.uid)!)
                                REF_USER_LIKES = REF_CURRENT_USER?.child("likes")
                                self.performSegue(withIdentifier: "signupToFeed", sender: nil)
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            })
        }
    }
    

    @IBAction func dismissBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func alertError(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
   

}
