//
//  ContactDetailsVC.swift
//  Contacts
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

internal enum ContactViewType {
    
    case view
    case edit
    case create
}

class ContactDetailsVC: BaseTableViewController<ContactDetailsVM>, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    internal var contactViewType: ContactViewType? = .view {
        didSet {
            tableView?.reloadData()
        }
    }
    
    internal let identifiers = [Cells.profileHeaderCell,
                                Cells.fieldCell]
    
    internal let descriptors = [Strings.firstName,
                                Strings.lastName,
                                Strings.mobile,
                                Strings.email]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        for identifier in identifiers {
            let nib = UINib(nibName: identifier,
                            bundle: nil)
            
            tableView?.register(nib,
                                forCellReuseIdentifier: identifier)
        }
        
        setShadowImageFrom(color: .clear)
        viewModel?.request()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }
        
        return 60
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return descriptors.count + 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let id   = identifiers[0]
            let cell = tableView.dequeueReusableCell(withIdentifier: id) as! ProfileHeaderCell
            cell.delegate = self
            cell.doUpdateFromType(contactViewType)
            cell.profileName?.text = viewModel?.getFullName()
            cell.separatorInset = .zero
            cell.selectionStyle = .none
            
            return cell
        }
        
        let row  = indexPath.row - 1
        let id   = identifiers[1]
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! FieldCell
        
        cell.descriptor?.text       = descriptors[row]
        cell.textField?.placeholder = descriptors[row]
        cell.textField?.tag         = indexPath.row
        cell.textField?.delegate    = self
        cell.textField?.addDoneCancelToolbar()
        cell.textField?.isUserInteractionEnabled = contactViewType == .edit
        cell.textField?.text        = viewModel?.getTextFromTag(row)
        
        cell.separatorInset = .zero
        cell.selectionStyle = .none

        return cell
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 3 {
            textField.keyboardType = .phonePad
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 4 {
            textField.resignFirstResponder()
        }
        
        let indexPath = IndexPath(row: textField.tag + 1, section: 0)
        if let cell = tableView?.cellForRow(at: indexPath) as? FieldCell {
            cell.textField?.becomeFirstResponder()
        }
        
        return false
    }
    
    @IBAction func didTapEditButton(_ sender: UIBarButtonItem) {
        contactViewType = .edit

        let doneItem   = UIBarButtonItem.SystemItem.done
        let cancelItem = UIBarButtonItem.SystemItem.cancel
        
        let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: doneItem,
                                                      target: self,
                                                      action: #selector(didTapDoneButton(_:)))
        
        let cancel: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: cancelItem,
                                                    target: self,
                                                    action: #selector(didTapCancelButton(_:)))
        
        tableView?.reloadData()
        
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        navigationController?.navigationBar.topItem?.rightBarButtonItem = done
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancel
        
        startResponding()
    }
    
    @IBAction func didTapDoneButton(_ sender: UIBarButtonItem) {
       createViewTypeBarButton()
    }
    
    @IBAction func didTapCancelButton(_ sender: UIBarButtonItem) {
       createViewTypeBarButton()
    }
}

//MARK: - Custom Methods
extension ContactDetailsVC {
    func startResponding() {
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = tableView?.cellForRow(at: indexPath) as? FieldCell {
            cell.textField?.becomeFirstResponder()
        }
    }
    
    func createViewTypeBarButton() {
        var button: UIBarButtonItem?
        
        contactViewType = .view
        let item = UIBarButtonItem.SystemItem.edit
        button = UIBarButtonItem(barButtonSystemItem: item,
                                 target: self,
                                 action: #selector(didTapEditButton(_:)))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        navigationController?.navigationBar.topItem?.hidesBackButton   = false
        navigationController?.navigationBar.topItem?.rightBarButtonItem = button
    }
}

//MARK: - ProfileHeader Cell Delegate
extension ContactDetailsVC: ProfileHeaderCellDelegate {
    
    func doMessage() {
        print("Do Message")
    }
    
    func doCall() {
        print("Do Call")
    }
    
    func doEmail() {
        print("Do Email")
    }
    
    func doFavourite() {
        print("Do Favourite")
    }
}

//MARK: - ViewModel delegate
extension ContactDetailsVC: BaseVMDelegate {
    
    func didUpdateModel(_ viewModel: BaseVM,
                        withState viewState: ViewState) {
        
        tableView?.reloadData()
    }
}
