//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 09.11.2022.
//

import Foundation

final class StatisticServiceImplementation : StatisticService {
    //MARK: - StatisticService property
    var totalAccuracy: Double {
        Double(totalCorrectAnswers) / Double(totalQuestions)
    }
    
    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
                
            return record
        }
            
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
                
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    //MARK: - private property
    private let userDefaults = UserDefaults.standard
    
    private var totalCorrectAnswers: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private var totalQuestions: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    //MARK: - StatisticService functions
    func store(correct count: Int, total amount: Int) {
        let newResult = GameRecord(correct: count, total: amount, date: Date())
        if newResult > bestGame {
            bestGame = newResult
        }
        
        totalCorrectAnswers += newResult.correct
        totalQuestions += newResult.total
        gamesCount += 1
    }
    
    func getResultStatisticMessage(correct count: Int, total amount: Int) -> String {
        return """
            Ваш результат: \(count) из \(amount)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correct) \(bestGame.date.dateTimeString)
            Средняя точность: \(String(format: "%.2f", totalAccuracy * 100))%
        """
    }
}

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}
