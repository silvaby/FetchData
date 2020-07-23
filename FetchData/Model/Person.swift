struct Person: Codable {
    let firstName: String?
    let gender: Gender?
    let dateOfBirtdh: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case gender, dateOfBirtdh
    }
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case random = "Random"
}

enum Age {
    case up
    case down
    case random
}

typealias Persons = [Person]
