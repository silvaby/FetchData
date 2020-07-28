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
        genderSegmentedControl.selectedSegmentIndex = personsManager.genderSegmentedControlIndex
        ageSegmentedControl.selectedSegmentIndex = personsManager.ageSegmentedControlIndex
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

    private func update() {
        personsManager.sorted()
        personsManager.change(genderIndex: genderSegmentedControl.selectedSegmentIndex,
                              ageIndex: ageSegmentedControl.selectedSegmentIndex)
        collectionView.reloadData()
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

    // MARK: - UICollectionViewDataSource

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return personsManager.personsWithAgeToShow.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as? CollectionViewCell
        // Configure the cell
        cell?.configure(personsManager.personsWithAgeToShow[indexPath.row])
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
