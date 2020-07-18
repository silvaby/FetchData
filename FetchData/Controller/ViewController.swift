import UIKit

class ViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var ageSegmentedControl: UISegmentedControl!

    private var personsManager = ServiceLocator.shared.personsManager
    private let idCell = "PersonCell"
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second, please", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.refreshControl = myRefreshControl

        myRefreshControl.beginRefreshing()
        downloadData()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        updateSegmentControl(state: personsManager.state)
    }

    @objc func refresh(sender _: UIRefreshControl) {
        downloadData()
    }

    private func downloadData() {
        personsManager.loadJson { result in
            switch result {
            case let .success(data):
                self.personsManager.parse(jsonData: data)

            case let .failure(error):
                print(error)
            }

            self.personsManager.change()

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }

    private func updateSegmentControl(state: String) {
        switch state {
        case "RR":
            genderSegmentedControl.selectedSegmentIndex = 0
            ageSegmentedControl.selectedSegmentIndex = 0
        case "RU":
            genderSegmentedControl.selectedSegmentIndex = 0
            ageSegmentedControl.selectedSegmentIndex = 1
        case "RD":
            genderSegmentedControl.selectedSegmentIndex = 0
            ageSegmentedControl.selectedSegmentIndex = 2

        case "FR":
            genderSegmentedControl.selectedSegmentIndex = 1
            ageSegmentedControl.selectedSegmentIndex = 0
        case "FU":
            genderSegmentedControl.selectedSegmentIndex = 1
            ageSegmentedControl.selectedSegmentIndex = 1
        case "FD":
            genderSegmentedControl.selectedSegmentIndex = 1
            ageSegmentedControl.selectedSegmentIndex = 2

        case "MR":
            genderSegmentedControl.selectedSegmentIndex = 2
            ageSegmentedControl.selectedSegmentIndex = 0
        case "MU":
            genderSegmentedControl.selectedSegmentIndex = 2
            ageSegmentedControl.selectedSegmentIndex = 1
        case "MD":
            genderSegmentedControl.selectedSegmentIndex = 2
            ageSegmentedControl.selectedSegmentIndex = 2
        default:
            break
        }
    }

    // MARK: - Actions

    @IBAction func genderChanged(_: Any) {
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            personsManager.stateOfGender = "R"
        case 1:
            personsManager.stateOfGender = "F"
        case 2:
            personsManager.stateOfGender = "M"
        default:
            break
        }
        personsManager.change()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func ageChanged(_: Any) {
        switch ageSegmentedControl.selectedSegmentIndex {
        case 0:
            personsManager.stateOfAge = "R"
        case 1:
            personsManager.stateOfAge = "U"
        case 2:
            personsManager.stateOfAge = "D"
        default:
            break
        }
        personsManager.change()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Create and configure table

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return personsManager.personsWithAgeToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? CustomTableViewCell

        // Configure the cell
        if let name = personsManager.personsWithAgeToShow[indexPath.row].firstName {
            cell?.firstName.text = name
        } else { cell?.firstName.text = "No name" }

        if let age = personsManager.personsWithAgeToShow[indexPath.row].dateOfBirtdh {
            switch age {
            case "0":
                cell?.age.text = "No age"
            case "1":
                cell?.age.text = "\(age) year"
            default:
                cell?.age.text = "\(age) years"
            }
        } else { cell?.age.text = "No age" }

        if let gender = personsManager.personsWithAgeToShow[indexPath.row].gender {
            if gender == .female {
                cell?.genderImage.image = UIImage(named: "Female")
            } else {
                cell?.genderImage.image = UIImage(named: "Male")
            }
        }
        return cell!
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let destinationVC: DetailsViewController = segue.destination as? DetailsViewController,
            let selectedItem = tableView.indexPathForSelectedRow?.item {
            if let firstName = personsManager.personsWithAgeToShow[selectedItem].firstName {
                destinationVC.textOfName = firstName
            }
            if let age = personsManager.personsWithAgeToShow[selectedItem].dateOfBirtdh {
                destinationVC.textOfAge = age
            }
            if let gender = personsManager.personsWithAgeToShow[selectedItem].gender {
                destinationVC.textOfGender = gender.rawValue
            }
        }
    }
}
