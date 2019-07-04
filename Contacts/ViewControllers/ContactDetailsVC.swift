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

class ContactDetailsVC: BaseVC<ContactDetailsVM>, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: BaseTableView?
    
    internal var contactViewType: ContactViewType? = .view {
        didSet {
            tableView?.reloadData()
        }
    }
    
    internal let identifiers = [Cells.profileHeaderCell]
    
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
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let id   = identifiers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: id) as! ProfileHeaderCell
        cell.delegate = self
        
        if contactViewType == .edit ||
            contactViewType == .create {
            
            cell.profileName?.isHidden       = true
            cell.buttonStackHeight?.constant = 0
            cell.layoutIfNeeded()
        } else {
            cell.profileName?.isHidden       = false
            cell.buttonStackHeight?.constant = 70
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
    
    @IBAction func didTapEditButton(_ sender: UIBarButtonItem) {
        
        var button: UIBarButtonItem?
        
        if contactViewType == .edit {
            contactViewType = .view
            let item = UIBarButtonItem.SystemItem.edit
            button = UIBarButtonItem(barButtonSystemItem: item,
                                     target: self,
                                     action: #selector(didTapEditButton(_:)))
        } else {
            contactViewType = .edit
            let item = UIBarButtonItem.SystemItem.cancel
            button = UIBarButtonItem(barButtonSystemItem: item,
                                     target: self,
                                     action: #selector(didTapEditButton(_:)))
        }
        
        let indexPath   = IndexPath(row: 0,
                                    section: 0)
        
        tableView?.reloadRows(at: [indexPath], with: .fade)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = button
    }
}

//MARK: - Custom Methods
extension ContactDetailsVC {
    
}

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
