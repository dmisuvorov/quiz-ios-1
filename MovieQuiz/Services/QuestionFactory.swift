//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 02.11.2022.
//

import Foundation

class QuestionFactory : QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private let mainDispatcher: DispatchingProtocol
    private let globalDispatcher: DispatchingProtocol
    
    private var movies: [MostPopularMovie] = []
    
    private var questions: [QuizQuestion] = []
    
    init(delegate: QuestionFactoryDelegate?,
         moviesLoader: MoviesLoading,
         mainDispatcher: DispatchingProtocol = DispatchQueue.main,
         globalDispatcher: DispatchingProtocol = DispatchQueue.global()) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
        self.mainDispatcher = mainDispatcher
        self.globalDispatcher = globalDispatcher
    }
    
    func loadData() {
        moviesLoader.loadMovies { result in
            self.mainDispatcher.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        globalDispatcher.async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
                
            guard let movie = self.movies[safe: index] else { return }
                
            var imageData = Data()
               
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
                
            let questionRating = (1..<10).randomElement() ?? 0
            let questionCompare = CompareQuestion.allCases.randomElement() ?? CompareQuestion.more
            var text: String
            var correctAnswer: Bool
            
            switch questionCompare {
            case .more:
                text = "Рейтинг этого фильма больше чем \(questionRating)?"
                correctAnswer = rating > Float(questionRating)
            case .less:
                text = "Рейтинг этого фильма меньше чем \(questionRating)?"
                correctAnswer = rating < Float(questionRating)
            }
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
                
            self.mainDispatcher.async { [weak self] in
                guard let self = self else { return }
                
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}

private enum CompareQuestion: CaseIterable {
    case more
    case less
}
