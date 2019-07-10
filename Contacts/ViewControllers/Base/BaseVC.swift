//
//  BaseVC.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

class BaseVC<T: BaseVMRequestProtocol>: UIViewController {

    var viewModel: T?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let colorKey = NSAttributedString.Key.foregroundColor
        let fontKey  = NSAttributedString.Key.font
        
        if let font = Fonts.helveticaBold17 {
            let attri: [NSAttributedString.Key : Any] = [colorKey: Colors.semiBlack,
                                                         fontKey: font]
            self.navigationController?.navigationBar.titleTextAttributes = attri
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor    = Colors.blueGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    open func pushTo(_ storyboardId: String) {}
    
    open func setShadowImageFrom(color: UIColor = .clear) {
        
        let shadowImage = UIImage.imageWithColor(color)
        self.navigationController?.navigationBar.shadowImage  = shadowImage
    }
}
