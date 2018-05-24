//
//  ViewController.swift
//  APIManager-Sample
//  https://www.linkedin.com/in/dinesh-saini-7a0b9781
//  Created by Dinesh Saini on 5/24/18.
//  Copyright © 2018 Dinesh Saini. All rights reserved.
//

import UIKit
import APIManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize APIManager
        APIManager.shared.initWith(baseURL: "")
        
        //Set request timeout
        APIManager.shared.timeoutIntervalForRequest = 100
        
        //Set ODR request timeout
        APIManager.shared.timeoutIntervalForResource = 200
        
        //Add custom header params for request
        APIManager.shared.headers = ["Content-Type" : "application/json"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func postRequest() -> Void{
        var dict = [String : Any]()
        dict["username"] = "Dinesh"
        dict["password"] = "123456"
        
        // api path
        let url = ""
        
        APIManager.shared.post(url: url, requestParameter: dict) { (data, urlresponse, error) in
            
            //Convert Data to json
            if let tempData = data{
                let json = JSON.init(data: tempData)
                print(json)
            }
        }
    }
    
    //
    func getRequest() -> Void {
        var dict = [String : Any]()
        dict["user_name"] = "Dinesh"
        
        // API path
        let url = ""
        APIManager.shared.get(url: url, requestParameter: dict) { (data, response, error) in
            //Convert Data to json
            if let tempData = data{
                let json = JSON.init(data: tempData)
                print(json)
            }
        }
    }
}

