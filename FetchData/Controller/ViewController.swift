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
        genderSegmentedControl.selectedSegmentIndex = personsManager.genderSegmentedControlIndex
        ageSegmentedControl.selectedSegmentIndex = personsManager.ageSegmentedControlIndex
        tableView.reloadData()
    }

    @objc func refresh(sender _: UIRefreshControl) {
        downloadData()
    }

    /// Download ahd parse data from URL.
    private func downloadData() {
        personsManager.loadJson { result in
            switch result {
            case let .success(data):
                self.personsManager.parse(jsonData: data)
            case let .failure(error):
                print(error)
            }
            self.personsManager.sorted()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }

    private func update() {
        personsManager.sorted()
        personsManager.change(genderIndex: genderSegmentedControl.selectedSegmentIndex,
                              ageIndex: ageSegmentedControl.selectedSegmentIndex)
        tableView.reloadData()
    }

    // MARK: - Actions

    @IBAction func genderChanged(_: Any) {
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            personsManager.sortByGender = nil
        case 1:
            personsManager.sortByGender = .female
        case 2:
            personsManager.sortByGender = .male
        default:
            break
        }
        update()
    }

    @IBAction func ageChanged(_: Any) {
        switch ageSegmentedControl.selectedSegmentIndex {
        case 0:
            personsManager.sortByAge = nil
        case 1:
            personsManager.sortByAge = .ascending
        case 2:
            personsManager.sortByAge = .descending
        default:
            break
        }
        update()
    }
}

// MARK: - Create and configure table

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return personsManager.personsWithAgeToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell,
                                                 for: indexPath) as? CustomTableViewCell
        // Configure the cell
        cell?.configure(personsManager.personsWithAgeToShow[indexPath.row])
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
