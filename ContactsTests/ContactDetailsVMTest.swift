//
//  ContactDetailsVMTest.swift
//  ContactsTests
//
//  Created by Mark Christian Buot on 04/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import XCTest
@testable import Contacts

private enum TestCase: String {
    
    case getContactSuccess    = "SUT: Get Contacts -- SUCCESS"
    case getContactError      = "SUT: Get Contacts -- ERROR"
    case updateContactSuccess = "SUT: Update Contacts -- SUCCESS"
}

class ContactDetailsVMTest: XCTestCase {
    
    var viewModel: ContactDetailsVM?
    var repository: MockContactsRepository?
    private var testCase: TestCase?
    var expectation: XCTestExpectation?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repository = MockContactsRepository()
        viewModel  = GlobalVMFactory.createContactDetailsVM(repository: repository,
                                                            delegate: self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    internal func testGetContact() {
        
        testCase    = .getContactSuccess
        expectation = XCTestExpectation(description: TestCase.getContactSuccess.rawValue)
        
        viewModel?.contact = Contact.createStub()
        viewModel?.request()
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    internal func testGetContactsError() {
        
        testCase             = .getContactError
        expectation          = XCTestExpectation(description: TestCase.getContactError.rawValue)
        repository?.failable = true
        
        viewModel?.contact = Contact.createStub()
        viewModel?.request()
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    internal func testUpdateContacts() {
        
        testCase            = .updateContactSuccess
        expectation         = XCTestExpectation(description: TestCase.updateContactSuccess.rawValue)
        
        viewModel?.contact = Contact.createStub()
        viewModel?.editContact(contact: Contact.createStub(),
                                     completion: {[weak self] (contact, error) in
                                        guard let self = self,
                                            error == nil else {
                                            XCTFail("Expectation not met")
                                            return
                                        }
                                        
                                        self.expectation?.fulfill()
        })
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
}

extension ContactDetailsVMTest: BaseVMDelegate {
    
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
            if testCase == .getContactError {
                expectation?.fulfill()
            } else {
                XCTFail("Expectation not met")
            }
            break
        }
    }
}
