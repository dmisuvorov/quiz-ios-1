//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showNetworkError(message: String)
    
    func show(quiz step: QuizStepViewModel)
    
    func show(quiz result: QuizResultsViewModel)
}
