//
//  SignUpViewController.swift
//  FirebaseChatApp
//
//  Created by Max Jala on 09/11/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet{
            profileImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(signupUser), for: .touchUpInside)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func editButtonTapped(_ sender: Any) {
        //select image form Photo
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary),
           let type = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        {
            imagePicker.mediaTypes = type
            present(imagePicker, animated: true, completion: nil)
        }
    }

    
    @objc func signupUser() {
        
        let ref = Database.database().reference()
        
        guard let email = emailTextField.text,
            let password = passWordTextField.text,
            let confirmPassword = confirmpasswordTextField.text else {return}
        
        if password == "" || confirmPassword == "" {
            alert(title: "Invalid Input", message: "Password field cannot be empty")
            return
        } else if password != confirmPassword {
            alert(title: "Passwords do not match", message: "Password fields must match")
            return
        } else if password.count < 7 || confirmPassword.count < 7 {
            alert(title: "Password too short", message: "Password must contain at least 7 characters")
            return
        }
        
            
        
        Auth.auth().createUser(withEmail: email, password: confirmPassword) { (user, error) in
            if let validError = error {
                self.alert(title: "Error", message: validError.localizedDescription)
            }

            guard let validUser = user
                else {
                    print("No valid user")
                    return
            }
            let uid = validUser.uid
            //create user successfully
            //upload image
            if let profileImage = self.profileImageView.image {
                self.uploadImageToStorage(image: profileImage, uid : uid, completion: { (error, imageUrl) in

                    //getting error when uploading image
                    //display the error
                    if let error = error {
                        self.alert(title: "Upload Image Error", message: error)
                    }


                        var userPost : [String:Any] = ["email" : email]

                        //get the image url
                        if let urlString = imageUrl?.absoluteString {
                            userPost["profileImage"] = urlString
                        }

                        ref.child("users").child(uid).setValue(userPost)
                        self.navigationController?.popViewController(animated: true)

                })
            }else {


                //write the user data (including image) to database
                    let userPost : [String:Any] = ["email" : email]

                    //set Value: overwrites everything in the defined path(key) ["uid"]
                    ////let newPost : [String:Any] = ["name": "Max"]
                    //e.g. if setValue as newPost, i will overwrite all the childs under "uid"
                    //will end up looking like this:
                    //users:
                    //      uid
                            //name : "Max"
                    //-> this keeps

                    ref.child("users").child(uid).setValue(userPost)
                    self.navigationController?.popViewController(animated: true)
                
                
                //let newPost : [String:Any] = ["name": "Max"]
                //updateValue: updates existing key and keep old values not mentioned in post
                
                //users:
                //      uid
                        //email : max@123.com
                        //name : "Max"
                //-> this keeps
                
            }
        }
    }


    func uploadImageToStorage(image : UIImage, uid : String, completion : @escaping ((_ error : String?,_ url : URL?) -> ())) {
        let storage = Storage.storage()
        let storageRef = storage.reference()

        // Data in memory
        guard let data = UIImagePNGRepresentation(image)
            else {
                print("Invalid image data")
                completion("Invalid image data", nil)
                return
        }

        // Create a reference to the file you want to upload
        let imgRef = storageRef.child("profile/\(uid).jpg")

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imgRef.putData(data, metadata: metadata) { (metadata, error) in

            if let error = error {
                //something wrong when uploading to storage
                print("Error : \(error.localizedDescription)")
                completion(error.localizedDescription, nil)
                return
            }

            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                completion("No Metadata Return", nil)
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            let downloadURL = metadata.downloadURL()

            completion(nil, downloadURL)
        }

    }


}


extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //get the image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("Image Selected")
            profileImageView.image = image
        }


        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        dismiss(animated: true, completion: nil)
    }

}
