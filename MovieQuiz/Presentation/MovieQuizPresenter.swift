//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 07.12.2022.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    private weak var viewController: MovieQuizViewController?
    
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex: Int = 0
    private let statisticService: StatisticService = StatisticServiceImplementation()
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
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
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
                
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            // сохранить результаты квиза
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            // показать результат квиза
            let text = statisticService.getResultStatisticMessage(correct: correctAnswers, total: self.questionsAmount)
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            self.viewController?.show(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
            
        let givenAnswer = isYes
            
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
