struct Person: Codable {
    let id: Int?
    let firstName, lastName, email: String?
    let gender: Gender?
    let dateOfBirtdh: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, gender, dateOfBirtdh
    }
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}

enum Age {
    case ascending
    case descending
}

typealias Persons = [Person]

// MARK: - Extensions

extension Age {
    /// Sort by age.
    var sorted: (Person, Person) -> Bool {
        switch self {
        case .ascending:
            return { $0.dateOfBirtdh ?? "" < $1.dateOfBirtdh ?? "" }
        case .descending:
            return { $0.dateOfBirtdh ?? "" > $1.dateOfBirtdh ?? "" }
        }
    }
}

extension Gender {
    /// Filter by gender.
    var filter: (Person) -> Bool {
        return { $0.gender == self }
    }
}
