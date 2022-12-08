//
//  QuestionFactoryDelegateMock.swift
//  MovieQuizTests
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//
@testable import MovieQuiz

class QuestionFactoryDelegateMock : QuestionFactoryDelegate {
    var isLoadDataFromServer = false
    var isFailToLoadData = false
    var isReceiveNextQuestion = false
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        isReceiveNextQuestion = true
    }
    
    func didLoadDataFromServer() {
        isLoadDataFromServer = true
    }
    
    func didFailToLoadData(with error: Error) {
        isFailToLoadData = true
    }
    
}
