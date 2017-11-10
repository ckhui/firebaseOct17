//
//  Extensions.swift
//  FirebaseChatApp
//
//  Created by Max Jala on 09/11/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    func loadImageFromUrl(url : String) {
        //1. get the url
        guard let imageUrl = URL(string: url)
            else { return }

        //2. get the image data
                //1. url session, task, resume
        let session = URLSession.shared
        let task = session.dataTask(with: imageUrl) { (data, response, error) in

            if let error = error {
                print("Dowload Image Error : \(error.localizedDescription)")
                return
            }
            //3. covert to image
            if let data = data {
                //4. display
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
}

