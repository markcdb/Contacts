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
    
    internal static func createContactDetails(_ contact: Contact? = nil,
                                              storyboardId: String) -> ContactDetailsVC? {
        
        let sid = storyboardId
        guard let vc = Storyboard.contacts.instantiateViewController(withIdentifier: sid) as?   ContactDetailsVC else { return nil }
        
        let vm       = GlobalVMFactory.createContactDetailsVM(delegate: vc)
        vm.contact   = contact
        vc.viewModel = vm
        return vc
    }
}
