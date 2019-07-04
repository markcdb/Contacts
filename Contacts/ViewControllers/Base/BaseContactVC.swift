//
//  BaseContactVC.swift
//  Contacts
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import UIKit

class BaseContactVC: BaseTableViewController<ContactListVM>, UITableViewDelegate, UITableViewDataSource {

    var identifiers = [Cells.contactCell,
                       Cells.loaderCell]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for identifier in identifiers {
            let nib = UINib(nibName: identifier,
                            bundle: nil)
            
            tableView?.register(nib,
                                forCellReuseIdentifier: identifier)
        }

        tableView?.delegate   = self
        tableView?.dataSource = self
    }
    
    //@objc is not supported within extensions of generic classes or classes that inherit from generic classes
    //Was forced to put all @objc protocol conformances inside class declaration
    
    //MARK: - Tableview Delegate and DataSource
    
    internal func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView,
                            estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    internal func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.getContactsCountAt(section) ?? 0
        
        if count > 0 {
            return count
        }
        
        return 1
    }
    
    internal func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        switch viewModel?.viewState {
        case .loading(_)?:
            cell = createLoaderCell(tableView: tableView,
                                    indexPath: indexPath)
        case .success(_)?:
            cell = createContactCell(tableView: tableView,
                                     indexPath: indexPath)
        case .error(_)?:
            cell = createErrorCell(tableView: tableView,
                                   indexPath: indexPath)
        default:
            break
        }
        
        return cell ?? UITableViewCell()
    }
    
    internal func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        guard viewModel?.viewState == .success(nil) else { return 1 }
        print(viewModel?.getSortingKeysCount() ?? 0)
        return viewModel?.getSortingKeysCount() ?? 0
    }
    
    internal func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel?.viewState == .success(nil) else {
            return nil
        }
        
        let frame = CGRect(x: 0,
                           y: 0,
                           width: tableView.frame.width,
                           height: 28)
        
        let view  = SectionHeader(frame: frame)
        view.titleLabel?.text = viewModel?.getSortingKeys()[section]
        return view
    }
    
    internal func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard viewModel?.viewState == .success(nil) else { return nil }
        return viewModel?.getSortingKeys()
    }
}

//MARK: - Custom methods
extension BaseContactVC {
    
    private func createLoaderCell(tableView: UITableView,
                                  indexPath: IndexPath) -> LoaderCell? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.loaderCell,
                                                 for: indexPath) as? LoaderCell
        
        cell?.selectionStyle = .none
        cell?.loadingIndicator.startAnimating()
        
        return cell
    }
    
    private func createContactCell(tableView: UITableView,
                                   indexPath: IndexPath) -> ContactCell? {
        
        let id        = Cells.contactCell
        let name      = viewModel?.getFullNameAt(indexPath) ?? ""
        let favorite  = viewModel?.getIsFavorite(indexPath) ?? false
        let urlString = viewModel?.getProfileUrl(indexPath) ?? ""
        let cell      = tableView.dequeueReusableCell(withIdentifier: id) as? ContactCell
        
        
        cell?.setNameFrom(name)
        cell?.setFavoriteFrom(favorite)
        cell?.setImageFrom(urlString)
        
        return cell
    }
    
    private func createErrorCell(tableView: UITableView,
                                 indexPath: IndexPath) -> UITableViewCell? {
        let id = Cells.emptyCell
        let cell = tableView.dequeueReusableCell(withIdentifier: id)
        
        return cell
    }
}
