//
//  MoviesLoading.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 21.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
