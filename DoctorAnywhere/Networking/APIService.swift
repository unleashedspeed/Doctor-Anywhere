//
//  APIService.swift
//  DoctorAnywhere
//
//  Created by Saurabh Gupta on 16/07/18.
//  Copyright © 2018 saurabh. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    static let standard = APIService()
    
    private func request(url : String,
                         method: HTTPMethod,
                         parameters: [String: Any]?,
                         headers: HTTPHeaders?,
                         completionHandler: @escaping ([String: Any]? , Error?) -> Void) {
        let request = Alamofire.request(url, method: method, parameters: parameters, headers: headers).responseJSON { response in
            guard response.result.isSuccess else {
                completionHandler(nil, response.result.error)
                return
            }
            
            guard let value = response.result.value as? [String: Any] else {
                completionHandler(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Malformed data received"]))
                return
            }
            
            completionHandler(value, nil)
        }
        debugPrint(request)
    }
    
    func getUsers(offset: Int, limit: Int = 10, completionHandler: @escaping (([User]?, Error?) -> Void)) {
        let url = "https://sd2-hiring.herokuapp.com/api/users?offset=\(offset)&limit=\(limit)"
        var users: [User] = []
        request(url: url,
                method: .get,
                parameters: nil,
                headers: nil) { (response, error) in
                    if let error = error {
                        completionHandler(nil, error)
                        return
                    }
                    
                    if let value = response {
                        let status = value["status"] as! Bool
                        if status {
                            do {
                                guard let data = value["data"] as? [String: Any], let usersData = data["users"] as? [AnyObject] else {
                                    completionHandler(nil, NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse data"]))
                                    
                                    return
                                }
                                
                                for userData in usersData {
                                    let data = try JSONSerialization.data(withJSONObject: userData as Any, options: .prettyPrinted)
                                    let decoder = JSONDecoder()
                                    let user = try decoder.decode(User.self, from: data)
                                    users.append(user)
                                }
                                
                                completionHandler(users, nil)
                            } catch let err {
                                print("Err", err)
                                completionHandler(nil, err)
                            }
                        } else {
//                            Error handling should be present here for all the error codes designed by backend engineer for this Endpoint. One example is given below.

//                            let errorCode = value["error_code"] as! String
//                            if status == "failure" && errorCode == "1" {
//                                completionHandler(nil, NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid Request"]))
//
//                                return
//                            }
                        }
                    }
        }
    }
}
