import UIKit

protocol AddMealViewControllerDelegate: AnyObject {
    func addMeal(name: String, happiness: Int)
}

class AddMealViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Attributes
    private let INPUT_HEIGHT: Double = 50
    weak var delegate: AddMealViewControllerDelegate?
    
    // MARK: - Components
    private lazy var mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nome da refeição"
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var mealNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var happinessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nível de felicidade"
        label.textColor = .darkText
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var happinessTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ex: 1-5"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var addMealButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adicionar", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(addMeal), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "back")
        return button
    }()
    
    // MARK: - Methods
    private func configureNavigationHeader() {
        navigationItem.title = "Adicionar refeição"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func configureHierarchy() {
        view.addSubview(mealNameLabel)
        view.addSubview(mealNameTextField)
        view.addSubview(happinessLabel)
        view.addSubview(happinessTextField)
        view.addSubview(addMealButton)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            // MARK: - Meal name
            mealNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            mealNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            mealNameTextField.heightAnchor.constraint(equalToConstant: CGFloat(INPUT_HEIGHT)),
            mealNameTextField.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 10),
            mealNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            mealNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // MARK: - Happines
            happinessLabel.topAnchor.constraint(equalTo: mealNameTextField.bottomAnchor, constant: 20),
            happinessLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            happinessTextField.heightAnchor.constraint(equalToConstant: CGFloat(INPUT_HEIGHT)),
            happinessTextField.topAnchor.constraint(equalTo: happinessLabel.bottomAnchor, constant: 10),
            happinessTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            happinessTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // MARK: - Add meal
            addMealButton.heightAnchor.constraint(equalToConstant: CGFloat(INPUT_HEIGHT)),
            addMealButton.widthAnchor.constraint(equalToConstant: CGFloat(INPUT_HEIGHT * 3)),
            addMealButton.topAnchor.constraint(equalTo: happinessTextField.bottomAnchor, constant: 30),
            addMealButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func displayAlert(type: AlertType) {
        let alertController = UIAlertController()
        
        switch type {
        case .error:
            alertController.title = "Ocorreu um erro"
            alertController.message = "Preencha as informações corretamente e tente novamente."
            alertController.addAction(UIAlertAction(title: "Voltar", style: .cancel))
        case .success:
            alertController.title = "Refeição cadastrada com sucesso!"
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
        }
        
        self.present(alertController, animated: true)
    }
    
    @objc
    private func addMeal() {
        guard
            let mealName = mealNameTextField.text,
            let happiness = happinessTextField.text,
            let mealHappiness = Int(happiness)
        else {
            displayAlert(type: .error)
            return
        }
        
        delegate?.addMeal(name: mealName, happiness: mealHappiness)
        displayAlert(type: .success)
    }
    
    @objc
    private func dismissKeyboard() {
        mealNameTextField.endEditing(true)
        happinessTextField.endEditing(true)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let userTap = UITapGestureRecognizer(target: self, action: #selector(AddMealViewController.dismissKeyboard))
        view.addGestureRecognizer(userTap)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureNavigationHeader()
        configureHierarchy()
        configureConstraints()
        
        hideKeyboardWhenTappedAround()
    }
}
