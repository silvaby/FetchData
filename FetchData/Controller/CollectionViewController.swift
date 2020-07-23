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
        super.viewWillAppear(true)
        personsManager.stateOfSegmentedControl(genderSegmentedControl: genderSegmentedControl,
                                               ageSegmentedControl: ageSegmentedControl)
        collectionView.reloadData()
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

            self.personsManager.sorted()

            DispatchQueue.main.async {
                self.collectionView.reloadData()
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
        collectionView.reloadData()
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
        collectionView.reloadData()
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
        if let destinationVC: DetailsViewController = segue.destination as? DetailsViewController,
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
