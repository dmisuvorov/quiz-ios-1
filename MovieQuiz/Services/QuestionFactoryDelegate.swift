//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 05.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
