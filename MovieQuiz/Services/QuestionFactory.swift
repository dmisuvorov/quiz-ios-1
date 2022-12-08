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
    
    private var movies: [MostPopularMovie] = []
    
    private var questions: [QuizQuestion] = []
    
    init(delegate: QuestionFactoryDelegate?, moviesLoader: MoviesLoading) {
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
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
                
            DispatchQueue.main.async { [weak self] in
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
