//
//  GlobalVCFactory.swift
//  Contacts
//
//  Created by Mark Christian Buot on 05/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit

class GlobalVCFactory {
    
    internal static func createContactDetailsWithType(_ type: ContactViewType,
                                                      contact: Contact? = nil,
                                                      storyboardId: String) -> UIViewController? {
        let sid = storyboardId

        switch type {
        case .create:
            guard let nav = Storyboard.contacts.instantiateViewController(withIdentifier: sid) as?   UINavigationController,
                let vc = nav.viewControllers.first as? ContactDetailsVC else { return nil }
            
            let vm       = GlobalVMFactory.createContactDetailsVM(delegate: vc)
            vc.contactViewType = type
            vc.createBarButtons()
            vc.viewModel = vm

            return nav
        case .edit:
            guard let nav = Storyboard.contacts.instantiateViewController(withIdentifier: sid) as?   UINavigationController,
                let vc = nav.viewControllers.first as? ContactDetailsVC else { return nil }
            
            let vm       = GlobalVMFactory.createContactDetailsVM(delegate: vc)
            vm.contact   = contact
            vc.viewModel = vm
            return vc
            
        case .view:
            let sid = storyboardId
            guard let vc = Storyboard.contacts.instantiateViewController(withIdentifier: sid) as?   ContactDetailsVC else { return nil }
            
            let vm       = GlobalVMFactory.createContactDetailsVM(delegate: vc)
            vm.contact   = contact
            vc.viewModel = vm
            return vc
        }
    }
}
