//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Суворов Дмитрий Владимирович on 29.11.2022.
//

import XCTest

class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
        
    override func setUpWithError() throws {
        try super.setUpWithError()
            
        app = XCUIApplication()
        app.launch()
            
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
            
        app.terminate()
        app = nil
    }
    
    func testScreenCast() throws {
        
    }
}
