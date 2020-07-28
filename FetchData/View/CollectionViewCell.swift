import UIKit

class CollectionViewCell: UICollectionViewCell {
    // MARK: - Properties

    @IBOutlet var name: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var genderImage: UIImageView!

    /**
     Configures the cell.
     - Parameter person: The `Person` type.
     */
    func configure(_ person: Person) {
        if let name = person.firstName {
            self.name.text = name
        } else { name.text = "No name" }

        if let age = person.dateOfBirtdh {
            switch age {
            case "0":
                self.age.text = "No age"
            case "1":
                self.age.text = "\(age) year"
            default:
                self.age.text = "\(age) years"
            }
        } else { age.text = "No age" }

        if let gender = person.gender {
            if gender == .female {
                genderImage.image = UIImage(named: "Female")
            } else {
                genderImage.image = UIImage(named: "Male")
            }
        }

        backgroundColor = UIColor.white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
}
