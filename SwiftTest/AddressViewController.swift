//
//  AddressViewController.swift
//  SwiftTest
//
//  Created by Dmitriy Zhurbenko on 23.06.17.
//  Copyright © 2017 Dmitriy Zhurbenko. All rights reserved.
//

import UIKit
import GoogleMaps

class AddressViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var currentCamera : GMSCameraPosition?
    var mainMarker : GMSMarker?
    var address : Address?
    
    
    let fieldPlaceholderNames = ["Address Name (optional)",
                                 "Area",
                                 "Apartment Type",
                                 "Block",
                                 "Street",
                                 "Building",
                                 "Floor",
                                 "Apartment No.",
                                 "Mobile Number",
                                 "Special instructions (optional)"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldPlaceholderNames.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! FooterViewCell
            return cell
        }
        if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewCell
            
            if address?.specialInstructions == "" {
                cell.textView.text = fieldPlaceholderNames[9]
                cell.textView.textColor = UIColor(hexString: "C7C7CD")
            }
            else {
                cell.textView.text = address?.specialInstructions
            }
            cell.separatorInset = .zero
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            
            cell.textField.tag = indexPath.row
            cell.textField.placeholder = fieldPlaceholderNames[indexPath.row]
            
            switch indexPath.row {
            case 0: cell.textField.text = address?.addressName
            case 1: cell.textField.text = address?.area
            case 2: cell.textField.text = address?.apartmentType
            case 3: cell.textField.text = address?.block
            case 4: cell.textField.text = address?.street
            case 5: cell.textField.text = address?.building
            case 6: cell.textField.text = address?.floor
            case 7: cell.textField.text = address?.apartmentNo
            case 8: cell.textField.text = address?.mobileNumber
            default: cell.textField.text = ""
            }
            
            if indexPath.row == 8 {
                cell.separatorInset = .zero
            }
 
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 10:
            return 82
        case 9:
            return 127
        default:
            return 47
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        headerCell.mapView.camera = currentCamera!
        mainMarker?.map = headerCell.mapView
        headerCell.mapView.settings.scrollGestures = false
        return headerCell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 109
    }
    
    //MARK: TextField Delegate
    @IBAction func editingEndTextField(_ sender: Any) {
        
        let text = (sender as! UITextField).text!
        
        switch (sender as! UITextField).tag {
        case 0: address?.addressName = text
        case 1: address?.area = text
        case 2: address?.apartmentType = text
        case 3: address?.block = text
        case 4: address?.street = text
        case 5: address?.building = text
        case 6: address?.floor = text
        case 7: address?.apartmentNo = text
        case 8: address?.mobileNumber = text
        case 9: address?.specialInstructions = text
        default: break
        }
    }
    
    //MARK: TextView Delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        address?.specialInstructions = textView.text
        
        if textView.text.isEmpty {
            textView.text = fieldPlaceholderNames[9]
            textView.textColor = UIColor(hexString: "C7C7CD")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(hexString: "C7C7CD") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        print(address!)
        navigationController?.popToRootViewController(animated: true)
    }
}
