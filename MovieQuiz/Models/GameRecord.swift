//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 09.11.2022.
//

import Foundation

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }

    static func == (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct == rhs.correct
    }
} 
