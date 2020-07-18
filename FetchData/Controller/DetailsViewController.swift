import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var name: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var age: UILabel!

    var textOfName: String = "No name"
    var textOfGender: String = "No gender"
    var textOfAge: String = "No age"

    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = "Name: \(textOfName)"
        gender.text = "Gender: \(textOfGender)"
        age.text = "Age: \(textOfAge)"
    }
}
