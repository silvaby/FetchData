import UIKit

class ViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var ageSegmentedControl: UISegmentedControl!

    private var personsManager = ServiceLocator.shared.personsManager
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
        personsManager.stateOfSegmentedControl(genderSegmentedControl: genderSegmentedControl,
                                               ageSegmentedControl: ageSegmentedControl)
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

    // MARK: - Actions

    @IBAction func genderChanged(_: Any) {
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            personsManager.sortByGender = .random
        case 1:
            personsManager.sortByGender = .female
        case 2:
            personsManager.sortByGender = .male
        default:
            break
        }
        personsManager.sorted()
        tableView.reloadData()
    }

    @IBAction func ageChanged(_: Any) {
        switch ageSegmentedControl.selectedSegmentIndex {
        case 0:
            personsManager.sortByAge = .random
        case 1:
            personsManager.sortByAge = .up
        case 2:
            personsManager.sortByAge = .down
        default:
            break
        }
        personsManager.sorted()
        tableView.reloadData()
    }
}
