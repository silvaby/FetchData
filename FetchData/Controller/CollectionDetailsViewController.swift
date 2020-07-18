import UIKit

class CollectionDetailsViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var age: UILabel!

    var textOfName: String = "No name2"
    var textOfGender: String = "No gender2"
    var textOfAge: String = "No age2"

    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = "Name: \(textOfName)"
        gender.text = "Gender: \(textOfGender)"
        age.text = "Age: \(textOfAge)"
    }
}
