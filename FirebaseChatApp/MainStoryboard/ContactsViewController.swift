//
//  ContactsViewController.swift
//  FirebaseChatApp
//
//  Created by Max Jala on 09/11/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ContactsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    let ref = Database.database().reference()
    
    var users : [User] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        observeFirebase()
    }
    
    func observeFirebase() {
        ref.child("users").observe(.childAdded) { (snapshot) in
            print(snapshot.value)
            
            if let infoDict = snapshot.value as? [String:Any],
                let email = infoDict["email"] as? String {
                
                let profileUrl = infoDict["profileImage"] as? String
                
                DispatchQueue.main.async {
                    let newUser = User(anEmail: email, aUid: snapshot.key,  url: profileUrl)
                    self.users.append(newUser)
                    
                    let indexPath = IndexPath(row: self.users.count - 1, section: 0)
                    
                    self.tableView.insertRows(at: [indexPath], with: .fade)

                }
                
            }
            
            
            
        }
        
//        ref.child("users").observe(.value) { (snapshot) in
//            print(snapshot.value)
//
//        }
        
        ref.child("users").observe(.childChanged) { (snapshot) in
            print(snapshot.value)
   
        }
        

        
//        ref.child("users").observeSingleEvent(of: .childAdded) { (snapshot) in
//
//
//            if let value = snapshot.value {
//                print("This only runs once!")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email

        if let profileUrl = user.profileUrl {
            cell.imageView?.loadImageFromUrl(url: profileUrl)
        }
        return cell
    }
}
