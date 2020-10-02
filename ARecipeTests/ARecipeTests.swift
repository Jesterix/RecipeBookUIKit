//
//  ARecipeTests.swift
//  ARecipeTests
//
//  Created by Георгий on 01.10.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import XCTest
@testable import ARecipe

class ARecipeTests: XCTestCase {
    var sut: MainViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = MainViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }
    
    func testShowShare() {
        let sharedDefaults = UserDefaults.init(
            suiteName: "group.com.jesterix.RecipeBook")
        let testText = "testText"
        sharedDefaults!.set(testText, forKey: "shareTask")

        sut.loadView()
        sut.viewWillAppear(true)
        let share = sut.sharedDefaults?.string(forKey: "shareTask")
        XCTAssert(share == nil)
    }
    
    func testNoShowShare() {
        sut.loadView()
        sut.viewWillAppear(true)
        let share = sut.sharedDefaults?.string(forKey: "shareTask")
        XCTAssert(share == nil)
    }
    
    func testWillDisappearVC() {
        sut.loadView()
        sut.viewWillAppear(true)
        sut.viewWillDisappear(true)
        NotificationCenter.default.post(Notification(name: UIApplication.willEnterForegroundNotification))
        XCTAssertFalse(sut.isSharing)
    }
    
    func testHandleNotif() {
        let sharedDefaults = UserDefaults.init(
            suiteName: "group.com.jesterix.RecipeBook")
        let testText = "testText"
        sharedDefaults!.set(testText, forKey: "shareTask")

        sut.loadView()
        sut.viewWillAppear(true)
        sut.isSharing = true
        sut.sharedDefaults!.set(testText + "1", forKey: "shareTask")
        //notification arrived
        sut.showSharedTask { result in
            XCTAssertFalse(result)
        }
//        _ = expectation(forNotification: UIApplication.willEnterForegroundNotification, object: nil, handler: nil)
//        NotificationCenter.default.post(Notification(name: UIApplication.willEnterForegroundNotification))
//        waitForExpectations(timeout: 5, handler: nil)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
