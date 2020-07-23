import UIKit

class CollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var age: UILabel!

//    private var personsManager = ServiceLocator.shared.personsManager
//    private let reuseID = "CollectionCell"
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID,
//                                                      for: indexPath) as? CollectionViewCell
//
//        // Configure the cell
//        cell?.name.text = personsManager.personsWithAgeToShow[indexPath.row].firstName
//        cell?.age.text = personsManager.personsWithAgeToShow[indexPath.row].dateOfBirtdh
//        cell?.gender.text = personsManager.personsWithAgeToShow[indexPath.row].gender?.rawValue
//
//        cell?.backgroundColor = UIColor.white
//        cell?.layer.borderColor = UIColor.lightGray.cgColor
//        cell?.layer.borderWidth = 0.5
//        return cell!
//    }
}
