//
//  MovieQuizViewControllerProtocolMock.swift
//  MovieQuizTests
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    var isShowStep = false
    var isHideLoadingIndicator = false
    var isShowNetworkError = false
    
    func show(quiz step: QuizStepViewModel) {
        isShowStep = true
    }
    
    func show(quiz result: QuizResultsViewModel) {
    
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
    
    }
    
    func disableAndEnableButtonsAfterDelay() {

    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
        isHideLoadingIndicator = true
    }
    
    func showNetworkError(message: String) {
        isShowNetworkError = true
    }
}
