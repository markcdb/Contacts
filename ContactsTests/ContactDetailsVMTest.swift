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
    case createContactSuccess = "SUT: Create Contacts -- SUCCESS"
    case deleteContactSuccess = "SUT: Delete Contacts -- SUCCESS"
}

class ContactDetailsVMTest: XCTestCase {
    
    internal lazy var stub: Contact = Contact.createStub()

    internal var viewModel: ContactDetailsVM?
    internal var repository: MockContactsRepository?
    internal var expectation: XCTestExpectation?
    private var testCase: TestCase?

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
    
    internal func testUpdateContact() {
        
        testCase            = .updateContactSuccess
        expectation         = XCTestExpectation(description: TestCase.updateContactSuccess.rawValue)
        
        viewModel?.contact = stub
        viewModel?.editContact(contact: stub,
                                     completion: {[weak self] (error) in
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
    
    internal func testCreateContact() {
        
        self.testCase    = .createContactSuccess
        expectation      = XCTestExpectation(description: TestCase.createContactSuccess.rawValue)
        
        self.viewModel?.createContact(contact: stub,
                                      completion: {(error) in
                                        guard error == nil else {
                                            XCTFail("Expectation not met")
                                            return
                                        }
                                        
                                        self.expectation?.fulfill()
        })
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    internal func testDeleteContact() {
        
        testCase            = .createContactSuccess
        expectation         = XCTestExpectation(description: TestCase.createContactSuccess.rawValue)
        
        viewModel?.deleteContact(contact: stub,
                                 completion: { (error) in
                                    guard error == nil else {
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
            if testCase == .getContactSuccess {
                expectation?.fulfill()
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
