//
//  BaseTableViewController.swift
//  Contacts
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

class BaseTableViewController<T: BaseVMRequestProtocol>: BaseVC<T> {

    @IBOutlet weak var tableView: BaseTableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: Notifications.showKeyboard,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: Notifications.hideKeyboard,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView?.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: keyboardSize.height,
                                                   right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        tableView?.contentInset = .zero
    }
}
