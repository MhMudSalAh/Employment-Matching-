//
//  EditProfileVC.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress
import Kingfisher



class EditProfileVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var CurrentUser = User()
    var selectorsArray = [""]
    var tagsArray = [""]
    var skillsArray = [""]
    var imagePicker: UIImagePickerController!
    var imageToUpload: UIImage?
    var isEditingImage = false
    

    func choseProfileImage() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToUpload = image
            isEditingImage = true
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EditProfileImageCell
            cell.profileImage.image = imageToUpload
            tableView.reloadData()
        } else {
            print("image picker error")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ARSLineProgress.show()
        
        REF_CURRENT_USER?.observe(.value, with: { snapshot in
            
            var newSelectorsArray = [String]()
            var newTagsArray = [String]()
            var newSkillsArray = [String]()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshot {
                    
                    switch snap.key {
                        
                    case "name":
                        self.CurrentUser.name = snap.value as! String
                        break
                        
                    case "type":
                        self.CurrentUser.type = snap.value! as! String
                        break
                        
                    case "email":
                        self.CurrentUser.email = snap.value as! String
                        break
                        
                    case "location":
                        self.CurrentUser.location = snap.value as! String
                        break
                        
                    case "address":
                        self.CurrentUser.address = snap.value as! String
                        break
                        
                    case "phone":
                        self.CurrentUser.phone = snap.value as! String
                        break
                        
                    case "website":
                        self.CurrentUser.website = snap.value as! String
                        break
                        
                    case "imageUrl":
                        self.CurrentUser.imageUrl = snap.value as! String
                        break
                        
                    case "gender":
                        self.CurrentUser.gender = snap.value as! String
                        break
                        
                    case "experience":
                        self.CurrentUser.experience = snap.value as! String
                        break
                        
                    case "tags":
                        
                        for child in snap.children.allObjects as! [DataSnapshot]{
                            newTagsArray.append(child.key)
                        }
                        break
                        
                    case "selectors":
                        for child in snap.children.allObjects as! [DataSnapshot]{
                            newSelectorsArray.append(child.key)
                        }
                        break
                        
                    case "skills":
                        for child in snap.children.allObjects as! [DataSnapshot]{
                            newSkillsArray.append(child.key)
                        }
                        break
                        
                    default:
                        break
                    }
                }
            }
            
            self.tagsArray = newTagsArray
            self.selectorsArray = newSelectorsArray
            self.skillsArray = newSkillsArray
            
            self.tableView.reloadData()
            ARSLineProgress.hide()
        })
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if CurrentUser.type == "Company" {
            return 8
        } else if CurrentUser.type == "Freelancer" {
            return 10
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return selectorsArray.count + 1
        } else if section == 3 {
            return tagsArray.count + 1
        }
        
        if CurrentUser.type == "Freelancer" {
            
            if section == 4 {
                return skillsArray.count + 1
            }
        }
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileImageCell", for: indexPath) as! EditProfileImageCell
            
            if isEditingImage == true {
                cell.profileImage.image = imageToUpload
            } else {
                let url = URL(string: CurrentUser.imageUrl)
                cell.profileImage.kf.setImage(with: url)
            }
            
            cell.imageAction = {_ in
                self.choseProfileImage()
            }
            
            cell.updateAction = {_ in
                
                if self.imageToUpload == nil {
                    
                    self.alertError(message: "Please choose a new profile image")
                
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
                            REF_CURRENT_USER?.updateChildValues(["imageUrl": downloadUrl!])
                            ARSLineProgress.hide()
                            self.isEditingImage = false
                        }
                    })
                }
            }
            
            return cell
            
        } else {
            
            if CurrentUser.type == "Company" {
                
                switch indexPath.section {
                    
                case 1:
                
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    
                    cell.valueField.text = CurrentUser.name
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "name", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                    
                case 2:
                    
                    if indexPath.row < selectorsArray.count {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                     
                        cell.valueField.text = selectorsArray[indexPath.row]
                        
                        cell.updateAction = {_ in
                            self.updateValueArray(isAdding: false , indexPath: indexPath, childName: "selectors", passedValueArray: self.selectorsArray)
                        }
                        
                        return cell
                    
                    } else if indexPath.row == selectorsArray.count {
                    
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAddCell", for: indexPath) as! EditProfileAddCell
                        
                        cell.addAction = {_ in
                            if cell.valueField.text != "" {
                                self.selectorsArray.append(cell.valueField.text!)
                                self.updateValueArray(isAdding: true, indexPath: indexPath, childName: "selectors", passedValueArray: self.selectorsArray)
                            }
                        }
                        
                        return cell
                    }
                    
                    
                    break
                    
                case 3:
                    
                    if indexPath.row < tagsArray.count {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                        
                        cell.valueField.text = tagsArray[indexPath.row]
                        
                        cell.updateAction = {_ in
                            self.updateValueArray(isAdding: false, indexPath: indexPath, childName: "tags", passedValueArray: self.tagsArray)
                        }
                        
                        return cell
                    
                    } else if indexPath.row == tagsArray.count {
                    
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAddCell", for: indexPath) as! EditProfileAddCell
                        
                        cell.addAction = {_ in
                            if cell.valueField.text != "" {
                                self.tagsArray.append(cell.valueField.text!)
                                self.updateValueArray(isAdding: true, indexPath: indexPath, childName: "tags", passedValueArray: self.tagsArray)
                            }
                        }
                        
                        return cell
                    }
                    
                    break
                    
                case 4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    
                    cell.valueField.text = CurrentUser.website
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "website", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                    
                case 5:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.location
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "location", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                case 6 :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.phone
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "phone", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                case 7:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.email
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "email", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                    
                default:
                    break
                }
                
            } else if CurrentUser.type == "Freelancer" {
                
                switch indexPath.section {
                    
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.name
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "name", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                    
                case 2:
                    
                    
                    if indexPath.row < selectorsArray.count {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                        cell.valueField.text = selectorsArray[indexPath.row]
                        
                        cell.updateAction = {_ in
                            self.updateValueArray(isAdding: false, indexPath: indexPath, childName: "selectors", passedValueArray: self.selectorsArray)
                        }

                        return cell
                    } else if indexPath.row == selectorsArray.count {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAddCell", for: indexPath) as! EditProfileAddCell
                        
                        cell.addAction = {_ in
                            if cell.valueField.text != "" {
                                self.selectorsArray.append(cell.valueField.text!)
                                self.updateValueArray(isAdding: true, indexPath: indexPath, childName: "selectors", passedValueArray: self.selectorsArray)
                            }
                        }
                        
                        return cell
                    }
                    
                    break
                    
                case 3:
                    
                    if indexPath.row < tagsArray.count {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                        cell.valueField.text = tagsArray[indexPath.row]
                        
                        cell.updateAction = {_ in
                            self.updateValueArray(isAdding: false, indexPath: indexPath, childName: "tags", passedValueArray: self.tagsArray)
                        }
                        return cell
                    } else if indexPath.row == tagsArray.count {
                      
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAddCell", for: indexPath) as! EditProfileAddCell
                        
                        cell.addAction = {_ in
                            if cell.valueField.text != "" {
                                self.tagsArray.append(cell.valueField.text!)
                                self.updateValueArray(isAdding: true, indexPath: indexPath, childName: "tags", passedValueArray: self.tagsArray)
                            }
                        }
                        
                        return cell
                    }
                    
                    break
                    
                case 4:
                    
                    if indexPath.row < skillsArray.count {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                        
                        cell.valueField.text = skillsArray[indexPath.row]
                        
                        cell.updateAction = {_ in
                            self.updateValueArray(isAdding: false, indexPath: indexPath, childName: "skills", passedValueArray: self.skillsArray)
                        }
                        return cell
                        
                    } else if indexPath.row == skillsArray.count {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileAddCell", for: indexPath) as! EditProfileAddCell
                        
                        cell.addAction = {_ in
                            if cell.valueField.text != "" {
                                self.skillsArray.append(cell.valueField.text!)
                                self.updateValueArray(isAdding: true, indexPath: indexPath, childName: "skills", passedValueArray: self.skillsArray)
                            }
                        }
                        
                        return cell
                    }
                    
                    break
                    
                case 5:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.address
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "address", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                case 6 :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.experience
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "experience", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                case 7:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.gender
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "gender", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                case 8 :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.phone
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "phone", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                case 9 :
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileFieldCell", for: indexPath) as! EditProfileFieldCell
                    cell.valueField.text = CurrentUser.email
                    
                    cell.updateAction = {_ in
                        self.updateValue(indexPath: indexPath, childName: "email", passedValue: cell.valueField.text!)
                    }
                    return cell
                    break
                    
                default:
                    break
                }
            }
        }
        
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        if CurrentUser.type == "Company" {
            
            switch section {
                
            case 1:
                return "Name"
            case 2:
                return "Selectors"
            case 3:
                return "Tags"
            case 4:
                return "Website"
            case 5 :
                return "Location"
            case 6 :
                return "Phone Number"
            case 7 :
                return "Email"
            default:
                return nil
            }
            
            
        } else if CurrentUser.type == "Freelancer" {
            
            switch section {
            
            case 1:
                return "Name"
            case 2:
                return "Selectors"
            case 3:
                return "Tags"
            case 4:
                return "Skills"
            case 5 :
                return "Address"
            case 6:
                return "Experience"
            case 7:
                return "Gender"
            case 8 :
                return "Phone Number"
            case 9 :
                return "Email"
            default:
                return nil
            }
        }
        
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        
        return 25
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 140
        }
        
        return 50
    }
    
    
    
    func updateValue(indexPath: IndexPath, childName: String, passedValue: String){
        
        let cell = tableView.cellForRow(at: indexPath) as! EditProfileFieldCell
        if cell.valueField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Value can't be empty", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            REF_CURRENT_USER?.child("\(childName)").setValue(passedValue)
        }
    }

    
    func updateValueArray(isAdding: Bool, indexPath: IndexPath, childName: String, passedValueArray: [String]){
        
        var passedValueArray = passedValueArray
    
        
        if isAdding {
        
            let cell = tableView.cellForRow(at: indexPath) as! EditProfileAddCell
            
            if cell.valueField.text == "" {
                let alert = UIAlertController(title: "Error", message: "Value can't be empty", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                
                passedValueArray[indexPath.row] = cell.valueField.text!
                var dic = [String: Any]()
                for value in passedValueArray {
                    dic[value] = "true"
                }
                
                REF_CURRENT_USER?.child("\(childName)").setValue(dic)
                
                cell.valueField.text = ""
            }


        }else {
            let  cell = tableView.cellForRow(at: indexPath) as! EditProfileFieldCell
            
            if cell.valueField.text == "" {
                let alert = UIAlertController(title: "Error", message: "Value can't be empty", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                
                passedValueArray[indexPath.row] = cell.valueField.text!
                var dic = [String: Any]()
                for value in passedValueArray {
                    dic[value] = "true"
                }
                
                REF_CURRENT_USER?.child("\(childName)").setValue(dic)
            }
        }
       
    }
    
    
    func alertError(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    

}
