//
//  NetworkManager.swift
//  SwiftTest
//
//  Created by Dmitriy Zhurbenko on 23.06.17.
//  Copyright © 2017 Dmitriy Zhurbenko. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift
import GoogleMaps

class AddressNetworkManager {
    
    let urlLink = "http://staging.salony.com/v5/addresses/"
    
    static let shared = AddressNetworkManager()
    
    typealias CompletionHandler = (_ success: Bool, _ address: AddressFromAPI?, _ error: String?) -> Void
    
    func getAddressWithCoordinate(coordinate: CLLocationCoordinate2D, completionHandler: @escaping CompletionHandler) {
        
        if !checkInternetConnection() {
            completionHandler(false, nil, "Check your internet connection")
            return
        }
        
        let url = urlLink + "geolocate?lat=\(coordinate.latitude)&lng=\(coordinate.longitude)"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseJSON { response in
            
            if response.error != nil {
                completionHandler(false, nil, response.error?.localizedDescription)
                return
            }
            
            if let result = response.result.value {
                
                let JSON = result as! NSDictionary
                
                if let resultAddress = JSON["address"] as? NSDictionary {
                    
                    var addressFromAPI = AddressFromAPI()
                   
                    if let area = resultAddress["area"] as? String {
                        addressFromAPI.area = area
                    }
            
                    if let area_id = resultAddress["area_id"] as? Int {
                        addressFromAPI.area_id = area_id
                    }
                    
                    if let block = resultAddress["block"] as? String {
                        addressFromAPI.block = block
                    }
                    
                    if let preview = resultAddress["preview"] as? String {
                        addressFromAPI.preview = preview
                    }
                    
                    if let province = resultAddress["province"] as? String {
                        addressFromAPI.province = province
                    }
                    
                    if let street = resultAddress["street"] as? String {
                        addressFromAPI.street = street
                    }
                    
                    completionHandler(true, addressFromAPI, nil)
                }
                else {
                    completionHandler(false, nil, "address not found")
                }
            }
            else {
                completionHandler(false, nil, "error")
            }
        }
    }
    
    func checkInternetConnection() -> Bool {
        
        let reachability = Reachability()!
        
        if !reachability.isReachable {
            return false
            
        }
        
        return true
    }
}
