//
//  ViewControllerHelper.swift
//  Contacts
//
//  Created by Mark Christian Buot on 05/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlertMessageWithAction(_ type: UIAlertAction.Style,
                                    title: String,
                                    message: String,
                                    cancelTitle: String?,
                                    acceptTitle: String?,
                                    completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        
        
        if let cancel = cancelTitle {
            let leftAction = UIAlertAction(title: cancel,
                                           style: type,
                                           handler: nil)
            alertController.addAction(leftAction)
        }
        
        if let accept = acceptTitle {
            let rightAction = UIAlertAction(title: accept,
                                            style: type,
                                            handler: { action in
                                                completion?()
            })
            alertController.addAction(rightAction)
        }
        
        present(alertController,
                animated: true,
                completion: nil)
    }
}
