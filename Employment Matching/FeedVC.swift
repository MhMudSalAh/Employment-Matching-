//
//  FeedVC.swift
//  Employment Matching
//
//  Created by Mahmoud salah on 6/24/17.
//  Copyright © 2017 Mahmoud salah. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import ARSLineProgress
import NYTPhotoViewer


class FeedVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , NYTPhotosViewControllerDelegate {
    
    var postsArray = [Post]()
    var imagePicker: UIImagePickerController!
    var imageToUpload: UIImage?
    let defaults = UserDefaults.standard
    var visitorId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ARSLineProgress.show()

        REF_POSTS.observe(.value, with: { snapshot in
           
            var newPostsArray = [Post]()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let postDic = snap.value as? [String: Any] {
                        let post = Post(postKey: snap.key, postData: postDic)
                        newPostsArray.append(post)
                    }
                }
            }
            self.postsArray = newPostsArray
            self.tableView.reloadData()
            ARSLineProgress.hide()
        })
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToUpload = image
            tableView.reloadData()
        } else {
            print("image picker error")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func postToFirebase(textField: UITextView, caption: String, imageUrl: String) {
        
        let id =  Auth.auth().currentUser?.uid //defaults.object(forKey: "userID") as! String
        let post: [String: Any] = ["caption": caption, "imageUrl": imageUrl, "date": Date().timeIntervalSince1970, "likes": 0, "posterID" : id!]
        REF_POSTS.childByAutoId().setValue(post)
        
        ARSLineProgress.hide()
        
        imageToUpload = nil
        textField.text = ""
        tableView.reloadData()
    }

    
    
    //MARK: - tableview methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return postsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTopCell", for: indexPath) as! FeedTopCell
            
            if imageToUpload != nil {
                cell.addImageBtn.setImage(imageToUpload, for: .normal)
            } else {
                cell.addImageBtn.setImage(UIImage(named:"ic_add_a_photo_black_24dp"), for: .normal)
            }
            
            cell.addImageAction = {_ in
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
            cell.postAction = {_ in
             
                if self.imageToUpload != nil {
                    
                    ARSLineProgress.show()
                    
                    let imageData = UIImageJPEGRepresentation(self.imageToUpload!, 0.5)
                    let imageUID = UUID().uuidString //random string
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    REF_POST_PICS.child(imageUID).putData(imageData!, metadata: metadata, completion: { (metadata, error) in
                    
                        if error != nil {
                            ARSLineProgress.hide()
                            self.alertError(message: error!.localizedDescription)
                        } else {
                            print("uploaded successfully")
                            let downloadUrl = metadata?.downloadURL()?.absoluteString
                            self.postToFirebase(textField: cell.postTextField, caption: cell.postTextField.text, imageUrl: downloadUrl!)
                        }
                        
                    })
                    
                } else {
                    
                    self.alertError(message: "Please add an image to your post first")
                }
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostCell", for: indexPath) as! FeedPostCell
        
        let post = postsArray[indexPath.row]
        cell.configureCell(post: post)
        
        cell.likeAction = {_ in
         
            REF_USER_LIKES?.child(post.Key).observeSingleEvent(of: .value, with: { snapshot in
                if let _ = snapshot.value as? NSNull {
                    post.changeLikesNumber(isAdding: true)
                    REF_USER_LIKES?.child(post.Key).setValue(true)
                } else {
                    post.changeLikesNumber(isAdding: false)
                    REF_USER_LIKES?.child(post.Key).removeValue()
                }
                
            })
        }
        
        cell.visitAction = {_ in
            
            self.visitorId = post.posterID
            self.performSegue(withIdentifier: "feedToProfile", sender: nil)
        }
        
        cell.viewPhotoAction = {_ in
            let title = NSAttributedString(string: "Post Image", attributes: [NSForegroundColorAttributeName: UIColor.white])
            let imageData = UIImageJPEGRepresentation(cell.postImage.image!, 1)
            let image = NYTImage(image: cell.postImage.image, imageData: imageData, attributedCaptionTitle: title)
            let photosViewController = NYTPhotosViewController(photos: [image])
            photosViewController.delegate = self
            self.present(photosViewController, animated: true, completion: nil)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }
        
        return 350//UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 70
        }
        
        return 350
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "feedToProfile" {
            let visitorVC = segue.destination as! ProfileVC
            visitorVC.passedUserId = visitorId!
        }
    }
    
    
    
    func alertError(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

   
}
