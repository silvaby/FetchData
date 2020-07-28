import Foundation

class PersonsManager {
    // MARK: - Properties

    /// Main URL.
    private let stringURL = "https://my.api.mockaroo.com/persons.json?key=f43efc60"
    /// `Persons`.
    private var persons = Persons()
    /// `Persons` with age.
    private var personsWithAge = Persons()

    /// `Persons` with age to show.
    var personsWithAgeToShow = Persons()
    var sortByAge: Age?
    var sortByGender: Gender?
    var genderSegmentedControlIndex = 0
    var ageSegmentedControlIndex = 0

    // MARK: - Sorting

    typealias PersonsFilter = (Person) -> Bool

    /// Filters the data using `filters`.
    private func filter(persons: [Person], filters: [PersonsFilter]) -> [Person] {
        var filteredPersons = persons
        filters.forEach { filteredPersons = filteredPersons.filter($0) }
        return filteredPersons
    }

    /// Sorted the information.
    func sorted() {
        let filters: [PersonsFilter] = sortByGender?.filter != nil ? [sortByGender!.filter] : []
        personsWithAgeToShow = filter(persons: personsWithAge, filters: filters)
        if let age = sortByAge?.sorted {
            personsWithAgeToShow.sort(by: age)
        }
    }

    /// Changes index for segmented control by age and gender.
    func change(genderIndex genderSelectedSegmentIndex: Int,
                ageIndex ageSelectedSegmentIndex: Int) {
        genderSegmentedControlIndex = genderSelectedSegmentIndex
        ageSegmentedControlIndex = ageSelectedSegmentIndex
    }

    // MARK: - Fetches and parses data

    /// Fetches data from URLString.
    func loadJson(completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: stringURL) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    completion(.success(data))
                }
            }
            urlSession.resume()
        }
    }

    /// Parses data.
    func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Persons.self, from: jsonData)
            persons = decodedData
            personsWithAge = persons.map { Person(id: $0.id,
                                                  firstName: $0.firstName,
                                                  lastName: $0.lastName,
                                                  email: $0.email,
                                                  gender: $0.gender,
                                                  dateOfBirtdh: String(Date().age(from: $0.dateOfBirtdh ?? "") ?? 0)) }
        } catch {
            print("Decode error.")
        }
    }
}
