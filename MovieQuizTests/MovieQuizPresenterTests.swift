//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
    
    func testDidReceiveNextQuestion() {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let dispatcher = DispatchingProtocolMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock, mainDispatcher: dispatcher)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        presenter.didReceiveNextQuestion(question: question)
        
        XCTAssertTrue(viewControllerMock.isShowStep)
    }
    
    func testDidLoadDataFromServer() {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let dispatcher = DispatchingProtocolMock()
        let networkClient  = StubNetworkClient(emulateError: false)
        let moviesLoader = MoviesLoader(networkClient: networkClient)
        let presenter = MovieQuizPresenter(
            viewController: viewControllerMock,
            mainDispatcher: dispatcher,
            globalDispatcher: dispatcher,
            moviesLoading: moviesLoader
        )
        
        presenter.didLoadDataFromServer()
        
        XCTAssertTrue(viewControllerMock.isHideLoadingIndicator)
        XCTAssertTrue(viewControllerMock.isShowStep)
    }
    
    func testDidFailToLoadData() {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let error = MyError.expectedError
        presenter.didFailToLoadData(with: error)
        
        XCTAssertTrue(viewControllerMock.isHideLoadingIndicator)
        XCTAssertTrue(viewControllerMock.isShowNetworkError)
    }
    
    enum MyError: Error {
        case expectedError
    }
}
