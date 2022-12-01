import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let debounceDelay = 1.5
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionsAmount: Int = 10
    private let alertPresenter: ResultAlertPresenterProtocol = ResultAlertPresenter()
    private let statisticService: StatisticService = StatisticServiceImplementation()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
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
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        showFirstQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
                
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    // MARK: - Actions
    @IBAction
    private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        debounceButton()
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction
    private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        debounceButton()
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private functions
    private func debounceButton() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        let deadline = DispatchTime.now() + debounceDelay
        
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            guard let self = self else { return }
            
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showFirstQuestion() {
        correctAnswers = 0
        currentQuestionIndex = 0
        
        questionFactory?.loadData()
        showLoadingIndicator()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        questionTextLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        previewImageView.image = step.image
        previewImageView.layer.borderWidth = 0
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        // здесь мы показываем результат прохождения квиза
        let alert = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            accessibilityIdentifier: "Game Results") { [weak self] in
                guard let self = self else { return }
                
                self.showFirstQuestion()
            }
        alertPresenter.showAlert(parentController: self, alertModel: alert)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        previewImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        previewImageView.layer.borderWidth = 8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // - 1 потому что индекс начинается с 0, а длинна массива — с 1
            // сохранить результаты квиза
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            // показать результат квиза
            let text = statisticService.getResultStatisticMessage(correct: correctAnswers, total: questionsAmount)
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз"
            )
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1 // увеличиваем индекс текущего вопроса на 1; таким образом мы сможем получить следующий вопрос
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // выключаем анимацию
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз",
                               accessibilityIdentifier: "Game Error") { [weak self] in
            guard let self = self else { return }
            
            self.showFirstQuestion()
        }
        
        alertPresenter.showAlert(parentController: self, alertModel: model)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
}
