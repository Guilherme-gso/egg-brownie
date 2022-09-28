import UIKit

class ListMealViewController: UIViewController {
    // MARK: - Attributes
    private var meals: [Meal] = []
    
    // MARK: - Components
    private lazy var mealsList: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Meal")
        return tableView
    }()
    
    private lazy var addMealButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "plus")
        button.target = self
        button.action = #selector(goToRegisterMealPage)
        return button
    }()
    
    // MARK: - Methods
    private func configureNavigationHeader() {
        navigationItem.title = "Refeições cadastradas"
        navigationItem.rightBarButtonItem = addMealButton
    }
    
    private func configureHierarchy() {
        view.addSubview(mealsList)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            mealsList.topAnchor.constraint(equalTo: view.topAnchor),
            mealsList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mealsList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealsList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc
    private func goToRegisterMealPage() {
        let addMealViewController = AddMealViewController()
        addMealViewController.delegate = self
        navigationController?.pushViewController(addMealViewController, animated: true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationHeader()
        configureHierarchy()
        configureConstraints()
    }
}

// MARK: - UITableViewDataSource
extension ListMealViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Meal", for: indexPath)
        cell.textLabel?.text = meals[indexPath.row].name
        return cell
    }
}

// MARK: - AddMealViewControllerDelegate
extension ListMealViewController: AddMealViewControllerDelegate {
    func addMeal(name: String, happiness: Int) {
        let meal = Meal(name: name, happiness: happiness)
        meals.append(meal)
        mealsList.reloadData()
    }
}
