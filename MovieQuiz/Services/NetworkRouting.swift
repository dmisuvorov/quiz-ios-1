//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 28.11.2022.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
