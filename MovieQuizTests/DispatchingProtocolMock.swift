//
//  DispatchingProtocolMock.swift
//  MovieQuizTests
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//

import Foundation
@testable import MovieQuiz

final class DispatchingProtocolMock: DispatchingProtocol {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
