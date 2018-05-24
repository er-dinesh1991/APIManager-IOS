//
//  APIManager.swift
//  APIManager
//  https://www.linkedin.com/in/dinesh-saini-7a0b9781
//  Created by Dinesh Saini on 5/16/18.
//  Copyright © 2018 Dinesh Saini. All rights reserved.
//

import Foundation

enum RequestMethod : String{
    case GET,PUT,POST,DELETE
}

open class APIManager{
    
    open static let shared = APIManager()
    fileprivate var baseURL = ""
    public var timeoutIntervalForRequest : TimeInterval = 80
    public var timeoutIntervalForResource : TimeInterval = 80
    public var headers : [String : Any]?
    public var isNetworkIndicator : Bool = true
    
    private lazy var session : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.timeoutIntervalForRequest = self.timeoutIntervalForRequest
        configuration.timeoutIntervalForResource = self.timeoutIntervalForResource
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    /**
     - parameter baseURL : Domain name
     */
    public func initWith(baseURL : String?) -> Void {
        if let temp = baseURL{
            self.baseURL = temp
        }
    }
    
    func makeQueryString(values: Dictionary<String,Any>) -> String {
        var querySTR = ""
        
        if values.count > 0 {
            querySTR = "?"
            for item in values {
                let key = item.key
                let keyValue = key+"="+"\(item.value)"+"&"
                querySTR = querySTR.appending(keyValue)
            }
            querySTR.removeLast()
        }
        return querySTR
    }
    
    /**
     **Get Request**
     - parameter url : Webservice URL
     - parameter requestParameter : Request Parameter
     - parameter completion : Request completion with response
     - parameter data : Response data in Data format
     - parameter response : URLResponse
     - parameter error : Got error from server
     */
    open func get(url:String?, requestParameter:[String:Any]?,completion: @escaping (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void) {
        
        // Check internet connection
        ReachabilityUtil.reachability { (status) in
            switch(status){
                
            case NotReachable:
                print("No Internet, Please try again")
                //Need to show alert getting Warning: Attempt to present like this
                if let window = UIApplication.shared.keyWindow, let viewController = window.topMostWindowController(){
                    viewController.presentAlertController(alertTitle: "No Internet", alertMessage: "Please check your internet connection and try again")
                }
                completion(nil, nil, nil)
                break
                
            case ReachableViaWiFi,ReachableViaWWAN:
                if self.baseURL == "" {
                    print("Base url not defined")
                    completion(nil, nil, nil)
                }
                guard let apiPath = url else{
                    print("API url is not defined")
                    completion(nil, nil, nil)
                    return
                }
                
                var fullPath = ""
                if let dict = requestParameter{
                    fullPath = (self.baseURL+apiPath+self.makeQueryString(values: dict))
                }
                else{
                    fullPath = (self.baseURL+apiPath)
                }
                
                let requestURL : URL = URL(string: fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                var request = URLRequest(url: requestURL)
                
                request.httpMethod = RequestMethod.GET.rawValue //"GET"
                if let tempHeader = self.headers{
                    for theHeader in tempHeader{
                        request.addValue("\(theHeader.value)", forHTTPHeaderField: theHeader.key)
                    }
                }
                
                
                #if DEBUG
                    print("API URL :- \(fullPath)")
                    print("Request Header :- \(self.headers)")
                    if let dict = requestParameter{
                        print("Request Paramerts :- \(dict)")
                    }
                #endif
                
                if self.isNetworkIndicator{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                else{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                let task = self.session.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        if var tempError = error as? NSError{
                            var customError = tempError
                            switch(tempError.code){
                                
                            case NSURLErrorBadURL:
                                //                            customError.localizedDescription = "Bad url error"
                                break
                            case NSURLErrorTimedOut:
                                //                            customError.localizedDescription = "Request time out error"
                                break
                            case NSURLErrorUnknown:
                                //                            customError.localizedDescription = "Unknown error"
                                break
                            case NSURLErrorCannotFindHost:
                                //                            customError.localizedDescription = "Cannot Find Host"
                                break
                            case NSURLErrorUnsupportedURL:
                                //                            customError.localizedDescription = "Unsupported URL"
                                break
                            case NSURLErrorCannotConnectToHost:
                                //                            customError.localizedDescription = "Cannot ConnectTo Host"
                                break
                            case NSURLErrorNetworkConnectionLost:
                                //                            customError.localizedDescription = "Network Connection Lost"
                                break
                            default:
                                //                            customError.localizedDescription = "Unknown error"
                                break
                            }
                            if let window = UIApplication.shared.keyWindow, let rootVC = window.rootViewController{
                                print("Show alert")
                                rootVC.presentAlertController(alertTitle: "Internet Connection", alertMessage: "Please check internet connection and try again")
                            }else{
                                print("Not showing alert")
                            }
                            
                            completion(nil, nil, customError)
                        }
                        
                        if let tempData = data{
                            #if DEBUG
                            do{
                                let json = try JSONSerialization.jsonObject(with: tempData, options: JSONSerialization.ReadingOptions.allowFragments)
                                print("Response :- \(json)")
                            }
                            catch(let serializeError){
                                print(serializeError)
                            }
                            #endif
                            
                            completion(data, response, error)
                        }
                        else{
                            completion(nil, response, error)
                        }
                    }
                }
                task.taskDescription = fullPath
                task.resume()
                break
                
            default:
                completion(nil, nil, nil)
                break
            }
        }
    }
    
    
    /**
     **Post Request**
     - parameter url : Webservice URL
     - parameter requestParameter : Request Parameter
     - parameter completion : Request completion with response
     - parameter data : Response data in Data format
     - parameter response : URLResponse
     - parameter error : Got error from server
     */
    open func post(url:String?, requestParameter:[String:Any]?,completion: @escaping (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void) {
        
        // Check internet connection
        ReachabilityUtil.reachability { (status) in
            switch(status){
                
            case NotReachable:
                print("No Internet, Please try again")
                //Need to show alert getting Warning: Attempt to present like this
                if let window = UIApplication.shared.keyWindow, let viewController = window.topMostWindowController(){
                    viewController.presentAlertController(alertTitle: "No Internet", alertMessage: "Please check your internet connection and try again")
                }
                completion(nil, nil, nil)
                break
                
            case ReachableViaWiFi,ReachableViaWWAN:
                if self.baseURL == "" {
                    print("Base url not defined")
                    completion(nil, nil, nil)
                }
                guard let apiPath = url else{
                    print("API url is not defined")
                    completion(nil, nil, nil)
                    return
                }
                
                let fullPath = (self.baseURL+apiPath)
                
                let requestURL : URL = URL(string: fullPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                var request = URLRequest(url: requestURL)
                request.httpMethod = RequestMethod.POST.rawValue
                
                if let tempHeader = self.headers{
                    for theHeader in tempHeader{
                        request.addValue("\(theHeader.value)", forHTTPHeaderField: theHeader.key)
                    }
                }
                
                
                #if DEBUG
                print("API URL :- \(fullPath)")
                print("Request Header :- \(self.headers)")
                if let dict = requestParameter{
                    print("Request Paramerts :- \(dict)")
                }
                #endif
                
                // Add request data
                if let rdata = requestParameter{
                    var requestData = Data()
                    do {
                        requestData = try JSONSerialization.data(withJSONObject: rdata, options:JSONSerialization.WritingOptions(rawValue: 0))
                        request.httpBody = requestData
                    }
                    catch{
                        print("Error in converting from Dictionary to Data")
                    }
                }
                
                if self.isNetworkIndicator{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                else{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                let task = self.session.dataTask(with: request) { (data, response, error) in
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        if var tempError = error as? NSError{
                            var customError = tempError
                            switch(tempError.code){
                                
                            case NSURLErrorBadURL:
                                //                            customError.localizedDescription = "Bad url error"
                                break
                            case NSURLErrorTimedOut:
                                //                            customError.localizedDescription = "Request time out error"
                                break
                            case NSURLErrorUnknown:
                                //                            customError.localizedDescription = "Unknown error"
                                break
                            case NSURLErrorCannotFindHost:
                                //                            customError.localizedDescription = "Cannot Find Host"
                                break
                            case NSURLErrorUnsupportedURL:
                                //                            customError.localizedDescription = "Unsupported URL"
                                break
                            case NSURLErrorCannotConnectToHost:
                                //                            customError.localizedDescription = "Cannot ConnectTo Host"
                                break
                            case NSURLErrorNetworkConnectionLost:
                                //                            customError.localizedDescription = "Network Connection Lost"
                                break
                            default:
                                //                            customError.localizedDescription = "Unknown error"
                                break
                            }
                            if let window = UIApplication.shared.keyWindow, let rootVC = window.rootViewController{
                                print("Show alert")
                                rootVC.presentAlertController(alertTitle: "Internet Connection", alertMessage: "Please check internet connection and try again")
                            }else{
                                print("Not showing alert")
                            }
                            
                            completion(nil, nil, customError)
                        }
                        
                        if let tempData = data{
                            #if DEBUG
                            do{
                                let json = try JSONSerialization.jsonObject(with: tempData, options: JSONSerialization.ReadingOptions.allowFragments)
                                print("Response :- \(json)")
                            }
                            catch(let serializeError){
                                print(serializeError)
                            }
                            #endif
                            
                            completion(data, response, error)
                        }
                        else{
                            completion(nil, response, error)
                        }
                    }
                }
                task.taskDescription = fullPath
                task.resume()
                break
                
            default:
                completion(nil, nil, nil)
                break
            }
        }
    }
    
    /**
     **Get All Requests from URLSession**
     - parameter array : all request in session
    */
    open func getAllRequests(completion : @escaping (_ array : [URLSessionTask]?) -> Void){
        self.session.getAllTasks { (array) in
            completion(array)
        }
    }
    
    /**
     **Cancel Request**
     - parameter url : Api url to cancle the request
     */
    open func cancelRequest(url : String?){
        
        if let apiPath = url, apiPath != ""{
            let fullPath = baseURL+apiPath
            self.session.getAllTasks { (tasks) in
                let filterAllRequest = tasks.filter({ (task) -> Bool in
                    return task.taskDescription == fullPath
                })
                
                if filterAllRequest.count > 0{
                    print("Cancel Request URL :- \(filterAllRequest.first?.taskDescription)")
                    filterAllRequest.first?.cancel()
                }
            }
        }
        else{
            print("Please provide api path to cancel request ")
        }
    }
}
