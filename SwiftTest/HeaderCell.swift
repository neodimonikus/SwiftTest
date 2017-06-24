//
//  HeaderCell.swift
//  SwiftTest
//
//  Created by Dmitriy Zhurbenko on 24.06.17.
//  Copyright © 2017 Dmitriy Zhurbenko. All rights reserved.
//

import UIKit
import GoogleMaps

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var mapView: GMSMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
