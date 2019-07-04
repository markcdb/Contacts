//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import XCTest
@testable import Contacts

private enum TestCase: String {
    
    case getContactsSuccess = "SUT: Get Contacts -- SUCCESS"
    case getContactsError   = "SUT: Get Contacts -- ERROR"
}

class ContactListVMTest: XCTestCase {

    var viewModel: ContactListVM?
    var repository: MockContactsRepository?
    private var testCase: TestCase?
    var expectation: XCTestExpectation?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        repository = MockContactsRepository()
        viewModel  = GlobalVMFactory.createContactListVM(repository: repository,
                                                         delegate: self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    internal func testGetContacts() {
        
        testCase    = .getContactsSuccess
        expectation = XCTestExpectation(description: TestCase.getContactsSuccess.rawValue)
        
        viewModel?.request()
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    internal func testGetContactsError() {
        
        testCase             = .getContactsError
        expectation          = XCTestExpectation(description: TestCase.getContactsError.rawValue)
        repository?.failable = true
        
        viewModel?.request()
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
}

extension ContactListVMTest: BaseVMDelegate {
    
    internal func didUpdateModel(_ viewModel: BaseVM,
                        withState viewState: ViewState) {
        
        switch viewState {
        case .success(_):
            if testCase?.rawValue == expectation?.description {
                expectation?.fulfill()
            } else {
                XCTFail("Expectation not met")
            }
        case .loading(_):
            break
        case .error(_):
            if testCase == .getContactsError {
                expectation?.fulfill()
            } else {
                XCTFail("Expectation not met")
            }
            break
        }
    }
}
