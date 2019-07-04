//
//  ViewController.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

class ContactListVC: BaseContactVC {
    
    var selectedIndex: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = Titles.contacts
        
        if viewModel == nil {
            viewModel = GlobalVMFactory.createContactListVM(delegate: self)
            viewModel?.request()
        }
        
        setShadowImageFrom(color: Colors.whiteGray)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel?.viewState != .success(nil) {
            return
        }
        
        super.tableView(tableView, didSelectRowAt: indexPath)
        selectedIndex = indexPath
        pushTo(StoryboardIDs.contactDetails)
    }
    
    override func pushTo(_ storyboardId: String) {
        super.pushTo(storyboardId)
        
        guard let indexPath = selectedIndex,
            let contact = viewModel?.getContactAt(indexPath) else { return }
        
        if let vc = GlobalVCFactory.createContactDetailsWithType(.view,
                                                                 contact: contact,
                                                                 storyboardId: storyboardId) {
            
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
    }
    
    
    @IBAction func didTapAddButton(_ sender: Any) {
        guard let nav = GlobalVCFactory.createContactDetailsWithType(.create,
                                                               contact: nil,
                                                               storyboardId: StoryboardIDs.createContact) else {
                                                                return
        }
        
        present(nav,
                animated: true,
                completion: nil)
    }
}

//MARK: - Custom Methods
extension ContactListVC {
}

//MARK: - Contact List VM delegate
extension ContactListVC: BaseVMDelegate {
    internal func didUpdateModel(_ viewModel: BaseVM,
                        withState viewState: ViewState) {
        
        tableView?.reloadData()
    }
}
