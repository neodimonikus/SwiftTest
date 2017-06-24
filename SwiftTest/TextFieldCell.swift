//
//  TextFieldCell.swift
//  SwiftTest
//
//  Created by Dmitriy Zhurbenko on 24.06.17.
//  Copyright © 2017 Dmitriy Zhurbenko. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class TextFieldCell: UITableViewCell {
    
    @IBOutlet weak var textField: JVFloatLabeledTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addDoneButtonOnKeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = UIColor(hexString: "9E1E62")
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.textField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.textField.endEditing(true)
    }

}
