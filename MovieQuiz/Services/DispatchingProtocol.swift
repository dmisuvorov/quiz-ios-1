//
//  DispatchingProtocol.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 08.12.2022.
//

import Foundation

protocol DispatchingProtocol {
    func async(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchingProtocol {
    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}
