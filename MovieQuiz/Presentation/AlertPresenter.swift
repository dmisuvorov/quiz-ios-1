//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Суворов Дмитрий Владимирович on 06.11.2022.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    func showAlert(parentController: UIViewController, alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        
        parentController.present(alert, animated: true, completion: nil)
    }
}
