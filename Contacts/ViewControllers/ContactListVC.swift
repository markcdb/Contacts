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
        routeTo(StoryboardIDs.contactDetails)
    }
    
    override func routeTo(_ storyboardId: String) {
        super.routeTo(storyboardId)
        
        guard let indexPath = selectedIndex,
            let contact = viewModel?.getContactAt(indexPath) else { return }
        
        if let vc = GlobalVCFactory.createContactDetails(contact,
                                                         storyboardId: storyboardId) {
            
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
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
