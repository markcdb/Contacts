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
    
    case getContactsSuccess   = "SUT: Get Contacts -- SUCCESS"
    case getContactsError     = "SUT: Get Contacts -- ERROR"
    case createContactSuccess = "SUT: Create Contact -- SUCCESS"
    case updateContactSuccess = "SUT: Update Contact -- SUCCESS"
    case deleteContactSuccess = "SUT: Delete Contact -- SUCCESS"
}

class ContactListVMTest: XCTestCase {

    internal lazy var stub: Contact = Contact.createStub()

    internal var viewModel: ContactListVM?
    internal var repository: MockContactsRepository?
    internal var expectation: XCTestExpectation?

    private var testCase: TestCase?
    
    //FOR CUD
    internal var testBlock: (() -> Void)?

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
    
    internal func testCreateContactUpdate() {
        
        testCase             = .createContactSuccess
        expectation          = XCTestExpectation(description: TestCase.createContactSuccess.rawValue)
        
        let vm               = GlobalVMFactory.createContactDetailsVM(delegate: self)
        viewModel?.request()
        
        testBlock = {
            self.testBlock = nil
            
            vm.firstName  = self.stub.first_name
            vm.lastName   = self.stub.last_name
            vm.mobile     = self.stub.phone_number
            vm.email      = self.stub.email
            
            vm.createContact(completion: { error in
                                guard error == nil else {
                                        XCTFail("Expectation not met")
                                        return
                                }
            })
        }
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    internal func testEditContactUpdate() {
        
        testCase             = .updateContactSuccess
        expectation          = XCTestExpectation(description: TestCase.updateContactSuccess.rawValue)
        
        let vm               = GlobalVMFactory.createContactDetailsVM(repository: repository,
                                                                      delegate: self)
        viewModel?.request()
        
        testBlock = {[weak self] in
            guard let self = self else { return }
            self.testBlock = nil
            
            vm.editContact(contact: self.stub,
                           completion: { error in
                            guard error == nil else {
                                XCTFail("Expectation not met")
                                return
                            }
            })
        }
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    internal func testDeleteContactUpdate() {
        
        testCase             = .deleteContactSuccess
        expectation          = XCTestExpectation(description: TestCase.deleteContactSuccess.rawValue)
        
        let vm               = GlobalVMFactory.createContactDetailsVM(repository: repository,
                                                                      delegate: self)
        viewModel?.request()
        
        testBlock = {[weak self] in
            guard let self = self else { return }
            self.testBlock = nil
            
            vm.deleteContact(id: self.stub.id,
                             completion: { error in
                                guard error == nil else {
                                    XCTFail("Expectation not met")
                                    return
                                }
            })
        }
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    fileprivate func validateWith(_ testCase: TestCase?) {
        let countChecking: ((Bool) -> Void) = {[weak self] filterCondition in
            guard let self = self else { return }
            if let block = self.testBlock {
                block()
            } else {
                let string = String(self.stub.first_name?.first ?? Character(""))
                let array  = self.viewModel?.contacts[string]
                if array?.contains(where: { $0.id == self.stub.id }) == filterCondition {
                    self.expectation?.fulfill()
                }
            }
        }
        
        switch testCase {
        case .getContactsSuccess?:
            expectation?.fulfill()
        case .createContactSuccess?:
            countChecking(true)
        case .updateContactSuccess?:
            if let block = testBlock {
                block()
            } else {
                self.expectation?.fulfill()
            }
        case .deleteContactSuccess?:
            countChecking(false)
        default:
            XCTFail("Expectation not met")
        }
    }
}

extension ContactListVMTest: BaseVMDelegate {
    
    internal func didUpdateModel(_ viewModel: BaseVM,
                        withState viewState: ViewState) {
        
        switch viewState {
        case .success(_):
            validateWith(testCase)
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
