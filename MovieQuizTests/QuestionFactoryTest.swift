//
//  QuestionFactoryTest.swift
//  MovieQuizTests
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//
import XCTest
@testable import MovieQuiz

final class QuestionFactoryTest : XCTestCase {
    
    func testLoadDataSuccess() {
        let networkClient  = StubNetworkClient(emulateError: false)
        let moviesLoader = MoviesLoader(networkClient: networkClient)
        let delegate = QuestionFactoryDelegateMock()
        let dispatcher = DispatchingProtocolMock()
        let questionFactory = QuestionFactory(
            delegate: delegate,
            moviesLoader: moviesLoader,
            mainDispatcher: dispatcher
        )
        
        questionFactory.loadData()
        
        XCTAssertTrue(delegate.isLoadDataFromServer)
        XCTAssertFalse(delegate.isFailToLoadData)
    }
    
    func testLoadDataFail() {
        let networkClient  = StubNetworkClient(emulateError: true)
        let moviesLoader = MoviesLoader(networkClient: networkClient)
        let delegate = QuestionFactoryDelegateMock()
        let dispatcher = DispatchingProtocolMock()
        let questionFactory = QuestionFactory(
            delegate: delegate,
            moviesLoader: moviesLoader,
            mainDispatcher: dispatcher
        )
        
        questionFactory.loadData()
        
        XCTAssertTrue(delegate.isFailToLoadData)
        XCTAssertFalse(delegate.isLoadDataFromServer)
    }
    
    func testRequestNextQuestion() {
        let networkClient  = StubNetworkClient(emulateError: false)
        let moviesLoader = MoviesLoader(networkClient: networkClient)
        let delegate = QuestionFactoryDelegateMock()
        let dispatcher = DispatchingProtocolMock()
        let questionFactory = QuestionFactory(
            delegate: delegate,
            moviesLoader: moviesLoader,
            mainDispatcher: dispatcher,
            globalDispatcher: dispatcher
        )
        
        questionFactory.loadData()
        questionFactory.requestNextQuestion()
        
        XCTAssertTrue(delegate.isLoadDataFromServer)
        XCTAssertTrue(delegate.isReceiveNextQuestion)
        XCTAssertFalse(delegate.isFailToLoadData)
    }
}
