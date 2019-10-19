//
//  ProfileVC.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress
import Kingfisher
import NYTPhotoViewer

class ProfileVC: UITableViewController, NYTPhotosViewControllerDelegate {
    
    var CurrentUser = User()
    var selectorsArray = [""]
    var tagsArray = [""]
    var skillsArray = [""]
    var passedUserId : String?
    var usertoshowRef : DatabaseReference!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        ARSLineProgress.show()
        
        if passedUserId != nil {
            usertoshowRef =  REF_USERS.child("\(passedUserId!)")
        } else {
           usertoshowRef =  REF_CURRENT_USER
        }
        
        usertoshowRef.observe(.value, with: { snapshot in
            
            print(REF_CURRENT_USER)
            
            var newSelectorsArray = [String]()
            var newTagsArray = [String]()
            var newSkillsArray = [String]()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{

                for snap in snapshot {
                    
                    switch snap.key {
                        
                        case "name":
                            self.CurrentUser.name = snap.value as! String
                            self.navigationItem.title = self.CurrentUser.name
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

    override func viewWillDisappear(_ animated: Bool) {
        passedUserId = nil
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        if CurrentUser.type == "Company" {
            return 7
        } else if CurrentUser.type == "Freelancer" {
            return 9
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            if section == 1 {
                return selectorsArray.count
            } else if section == 2 {
                return tagsArray.count
            }
            
        if CurrentUser.type == "Freelancer" {

            if section == 3 {
                return skillsArray.count
            }
        }
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTopCell", for: indexPath) as! ProfileTopCell
            
            let url = URL(string: CurrentUser.imageUrl)
            cell.profileImage.kf.setImage(with: url)
            
            cell.nameLabel.text = CurrentUser.name
            
            cell.viewPhotoAction = {_ in
                let title = NSAttributedString(string: "Profile Image", attributes: [NSForegroundColorAttributeName: UIColor.white])
                let imageData = UIImageJPEGRepresentation(cell.profileImage.image!, 1)
                let image = NYTImage(image: cell.profileImage.image, imageData: imageData, attributedCaptionTitle: title)
                let photosViewController = NYTPhotosViewController(photos: [image])
                photosViewController.delegate = self
                self.present(photosViewController, animated: true, completion: nil)
            }

            
            return cell
        
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileNormalCell", for: indexPath) as! ProfileNormalCell
            
            if CurrentUser.type == "Company" {
                
                switch indexPath.section {
                
                case 1:
                    cell.contentLabel.text = selectorsArray[indexPath.row]
                    break
                    
                case 2:
                    cell.contentLabel.text = tagsArray[indexPath.row]
                    break
                    
                case 3:
                    cell.contentLabel.text = CurrentUser.website
                    break
                    
                case 4:
                    cell.contentLabel.text = CurrentUser.location
                    break
                case 5 :
                    cell.contentLabel.text = CurrentUser.phone
                    break
                case 6:
                    cell.contentLabel.text = CurrentUser.email
                    break

                default:
                    break
                }
                
            } else if CurrentUser.type == "Freelancer" {
                
                switch indexPath.section {
                
                case 1:
                    cell.contentLabel.text = selectorsArray[indexPath.row]
                    break
                    
                case 2:
                    cell.contentLabel.text = tagsArray[indexPath.row]
                    break
                    
                case 3:
                    cell.contentLabel.text = skillsArray[indexPath.row]
                    break
                
                case 4:
                    cell.contentLabel.text = CurrentUser.address
                    break
                case 5 :
                    cell.contentLabel.text = CurrentUser.experience
                    break
                case 6:
                    cell.contentLabel.text = CurrentUser.gender
                    break
                case 7 :
                    cell.contentLabel.text = CurrentUser.phone
                    break
                case 8 :
                    cell.contentLabel.text = CurrentUser.email
                    break
                default:
                    break
                }
                
            }
            
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
 
        if CurrentUser.type == "Company" {
         
            switch section {
            case 1:
                return "Selectors"
            case 2:
                return "Tags"
            case 3:
                return "Website"
            case 4 :
                return "Location"
            case 5 :
                return "Phone Number"
            case 6 :
                return "Email"
            default:
                return nil
            }

            
        } else if CurrentUser.type == "Freelancer" {
            
            switch section {
            case 1:
                return "Selectors"
            case 2:
                return "Tags"
            case 3:
                return "Skills"
            case 4 :
                return "Address"
            case 5:
                return "Experience"
            case 6:
                return "Gender"
            case 7 :
                return "Phone Number"
            case 8 :
                return "Email"
            default:
                return nil
            }
        }
        
        
        
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 175
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 175
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }
        
        return 25
    }
    
  
}
