//
//  AlertProtocol.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 07.11.2022.
//

import Foundation
import UIKit

protocol ResultAlertPresenterProtocol {
    func showAlert(parentController: UIViewController, alertModel: AlertModel)
}
