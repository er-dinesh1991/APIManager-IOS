//
//  UIViewController.swift
//  APIManager
//  https://www.linkedin.com/in/dinesh-saini-7a0b9781
//  Created by Dinesh Saini on 5/22/18.
//  Copyright © 2018 Dinesh Saini. All rights reserved.
//

import Foundation

public extension UIViewController{
    
    public func presentAlertController(alertTitle : String, alertMessage : String) -> Void {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actionOk)
        if let controller = UIApplication.shared.topViewController(){
            DispatchQueue.main.async {
                controller.present(alert, animated: true, completion: nil)
            }
        }
    }

    
}
