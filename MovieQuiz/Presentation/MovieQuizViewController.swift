import UIKit

final class MovieQuizViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private var presenter: MovieQuizPresenter?

    private let debounceDelay = 1.5
    private let alertPresenter: ResultAlertPresenterProtocol = ResultAlertPresenter()
    
    @IBOutlet
    private var previewImageView: UIImageView!
    
    @IBOutlet
    private var questionTextLabel: UILabel!
    
    @IBOutlet
    private var counterLabel: UILabel!
    
    @IBOutlet
    private var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet
    private var noButton: UIButton!
    
    @IBOutlet
    private var yesButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Public functions for presenter
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // выключаем анимацию
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
    }
    
    func showNetworkError(message: String) {
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз",
                               accessibilityIdentifier: "Game Error") { [weak self] in
            guard let self = self else { return }
            
            self.presenter?.showFirstQuestion()
        }
        
        alertPresenter.showAlert(parentController: self, alertModel: model)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        previewImageView.layer.borderWidth = 8
    }
    
    func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        questionTextLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        previewImageView.image = step.image
        previewImageView.layer.borderWidth = 0
    }
    
    func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            accessibilityIdentifier: "Game Results") { [weak self] in
                guard let self = self else { return }
                
                self.presenter?.showFirstQuestion()
            }
        alertPresenter.showAlert(parentController: self, alertModel: alert)
    }
    
    // MARK: - Actions
    @IBAction
    private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
        debounceButtons()
    }
    
    @IBAction
    private func yesButtonClicked(_ sender: UIButton) {
        presenter?.yesButtonClicked()
        debounceButtons()
    }
    
    // MARK: - Private functions
    private func debounceButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        let deadline = DispatchTime.now() + debounceDelay
        
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            guard let self = self else { return }
            
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
}
