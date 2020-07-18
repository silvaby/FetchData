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
}

typealias Persons = [Person]
