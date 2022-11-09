//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 09.11.2022.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
