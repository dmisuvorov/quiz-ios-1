//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 07.12.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex: Int = 0
    private let statisticService: StatisticService = StatisticServiceImplementation()
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        self.viewController?.showLoadingIndicator()
        self.showFirstQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
                
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    // MARK: - Public functions for controller
    func showFirstQuestion() {
        resetQuestionIndex()
        
        questionFactory?.loadData()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
        
    func resetQuestionIndex() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            // сохранить результаты квиза
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            let text = statisticService.getResultStatisticMessage(correct: correctAnswers, total: self.questionsAmount)
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз",
                accessibilityId: "Game results"
            )
            // показать результат квиза
            self.viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
            
        let givenAnswer = isYes
            
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
