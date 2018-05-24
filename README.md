# APIManager-IOS

# How to build framework
  1. Select APIManager target and press Command and B togather (⌘+B)
  2. Select UniversalAPIManager target and press Command and B togather (⌘+B) it will popup APIManager.framework in Project folder in Finder
  
# How to use

1. Drag and drop APIManager.framework in your xcode project

2. Add APIManager.framework in Embedded Binaries and Linked Framework and Libaries in xcode project target General Setting

3.Initialize APIManager

  import APIManager in AppDelegate
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize APIManager
        APIManager.shared.initWith(baseURL: "")
        
        //Set request timeout
        APIManager.shared.timeoutIntervalForRequest = 100
        
        //Set ODR request timeout
        APIManager.shared.timeoutIntervalForResource = 200
        
        //Add custom header params for request
        APIManager.shared.headers = ["Content-Type" : "application/json"]
        
        return true
    }
    
    
How to use POST Method

        var parameters = [String : Any]()
        parameters["username"] = "Dinesh"
        parameters["password"] = "123456"
        
        // api path
        let url = ""
        
        APIManager.shared.post(url: url, requestParameter: parameters) { (data, urlresponse, error) in
            
            //Convert Data to json
            if let tempData = data{
                let json = JSON.init(data: tempData)
                print(json)
            }
        }
        
        
How to use GET Method
 
        var parameters = [String : Any]()
        parameters["user_name"] = "Dinesh"
        
        // API path
        let url = ""
        APIManager.shared.get(url: url, requestParameter: parameters) { (data, response, error) in
            //Convert Data to json
            if let tempData = data{
                let json = JSON.init(data: tempData)
                print(json)
            }
        }
 
 
 
