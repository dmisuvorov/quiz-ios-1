//
//  MovieQuizViewControllerProtocolMock.swift
//  MovieQuizTests
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {
    
    }
    
    func show(quiz result: QuizResultsViewModel) {
    
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
    
    }
    
    func showLoadingIndicator() {
    
    }
    
    func hideLoadingIndicator() {
    
    }
    
    func showNetworkError(message: String) {
    
    }
}
