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
    
    case getContactSuccess = "SUT: Get Contacts -- SUCCESS"
    case getContactError   = "SUT: Get Contacts -- ERROR"
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

    func testGetContact() {
        
        testCase    = .getContactSuccess
        expectation = XCTestExpectation(description: TestCase.getContactSuccess.rawValue)
        
        let contactStub = Contact(id: 123,
                              first_name: nil,
                              last_name: nil,
                              email: nil,
                              phone_number: nil,
                              profile_pic: nil,
                              favorite: nil,
                              created_at: nil,
                              updated_at: nil)
        
        viewModel?.contact = contactStub
        viewModel?.request()
        
        wait(for: [expectation!],
             timeout: 10.0)
    }
    
    func testGetContactsError() {
        
        testCase             = .getContactError
        expectation          = XCTestExpectation(description: TestCase.getContactError.rawValue)
        repository?.failable = true
        
        viewModel?.request()
        
        wait(for: [expectation!],
             timeout: 10.0)
    }

}

extension ContactDetailsVMTest: BaseVMDelegate {
    
    func didUpdateModel(_ viewModel: BaseVM,
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
