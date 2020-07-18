import UIKit

class CollectionViewController: UICollectionViewController {
    // MARK: - Properties

    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var ageSegmentedControl: UISegmentedControl!
    @IBOutlet var collectionViewOutlet: UICollectionView!

    private var personsManager = ServiceLocator.shared.personsManager
    private let reuseIdentifier = "CollectionCell"
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second, please", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.refreshControl = myRefreshControl

        let layout = collectionViewOutlet.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        layout?.minimumInteritemSpacing = 5
        layout?.itemSize = CGSize(width: (collectionViewOutlet.frame.size.width - 20) / 2,
                                  height: (collectionViewOutlet.frame.size.height - 220) / 4)
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(false)
        collectionView.reloadData()

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
                self.collectionView.reloadData()
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
            self.collectionView.reloadData()
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
            self.collectionView.reloadData()
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return personsManager.personsWithAgeToShow.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as? CollectionViewCell

        // Configure the cell
        cell?.name.text = personsManager.personsWithAgeToShow[indexPath.row].firstName
        cell?.age.text = personsManager.personsWithAgeToShow[indexPath.row].dateOfBirtdh
        cell?.gender.text = personsManager.personsWithAgeToShow[indexPath.row].gender?.rawValue
        cell?.backgroundColor = UIColor.white
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
        return cell!
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let destinationVC: CollectionDetailsViewController = segue.destination as? CollectionDetailsViewController,
            let selectedItem = collectionView.indexPathsForSelectedItems?.first?.item {
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
