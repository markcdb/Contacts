//
//  TextFieldHelper.swift
//  Contacts
//
//  Created by Mark Christian Buot on 05/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addDoneCancelToolbar(nextTitle: String) {
        let onCancel = (target: self, action: #selector(cancelButtonTapped))
        let onDone   = (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle       = .default
        toolbar.items          = [
                                    UIBarButtonItem(title: Strings.Cancel,
                                                    style: .plain,
                                                    target: onCancel.target,
                                                    action: onCancel.action),
                                    UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                    target: self,
                                                    action: nil),
                                    UIBarButtonItem(title: nextTitle,
                                                    style: .done,
                                                    target: onDone.target,
                                                    action: onDone.action)
                                ]
        
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { let _ = self.delegate?.textFieldShouldReturn?(self) }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}
