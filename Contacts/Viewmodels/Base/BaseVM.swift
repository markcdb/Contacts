//
//  BaseVM.swift
//  FourSquare
//
//  Created by Mark Christian Buot on 31/01/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation

protocol BaseVMDelegate: class {
    
    func didUpdateModel(_ viewModel: BaseVM,
                        withState viewState: ViewState)
}

protocol BaseVMRequestProtocol {
    
    func request()
    func retry()
}

class BaseVM {
    
    open var viewState: ViewState? {
        didSet {
            if let viewState = viewState {
                delegate?.didUpdateModel(self,
                                         withState: viewState)
            }
        }
    }
    
    open weak var delegate: BaseVMDelegate?
    
    init(delegate: BaseVMDelegate) {
        self.delegate = delegate
    }
}

class BaseVMRepo<T: RepositoryProtocol>: BaseVM, BaseVMRequestProtocol {
    
    var repository: T?
    
    open func request() {}
    
    open func retry() {
        repository?.retry()
    }
}
