//
//  Address.swift
//  SwiftTest
//
//  Created by Dmitriy Zhurbenko on 24.06.17.
//  Copyright © 2017 Dmitriy Zhurbenko. All rights reserved.
//

import Foundation
import GoogleMaps

struct Address {
    var addressName : String = ""
    var area : String = ""
    var apartmentType : String = ""
    var block : String = ""
    var street  : String = ""
    var building : String = ""
    var floor : String = ""
    var apartmentNo : String = ""
    var mobileNumber  : String = ""
    var specialInstructions : String = ""
    var coordinate = CLLocationCoordinate2D()
}

struct AddressFromAPI {
    var preview : String = ""
    var block : String = ""
    var province: String = ""
    var street : String = ""
    var area_id: Int = -1
    var area: String = ""
}
