import Foundation
import UIKit

class PersonsManager {
    // MARK: - Properties

    /// Main URL
    private let stringURL = "https://my.api.mockaroo.com/persons.json?key=f43efc60"
    /// `Persons`.
    private var persons = Persons()
    /// `Persons` with age
    var personsWithAge = Persons()

    /// `Persons` with age to show
    var personsWithAgeToShow = Persons()
    var sortByAge = Age.random
    var sortByGender = Gender.random
    var genderSegmentedControlIndex = 0
    var ageSegmentedControlIndex = 0

    /// Changes the information.
    func sorted() {
        if sortByAge == .random, sortByGender == .random {
            personsWithAgeToShow = personsWithAge
            genderSegmentedControlIndex = 0
            ageSegmentedControlIndex = 0
        } else if sortByAge == .up, sortByGender == .random {
            personsWithAgeToShow = personsWithAge.sorted { Int($0.dateOfBirtdh!)! < Int($1.dateOfBirtdh!)! }
            genderSegmentedControlIndex = 0
            ageSegmentedControlIndex = 1
        } else if sortByAge == .down, sortByGender == .random {
            personsWithAgeToShow = personsWithAge.sorted { Int($0.dateOfBirtdh!)! > Int($1.dateOfBirtdh!)! }
            genderSegmentedControlIndex = 0
            ageSegmentedControlIndex = 2
        } else if sortByAge == .random, sortByGender == .female {
            personsWithAgeToShow = personsWithAge.filter { $0.gender == .female }
            genderSegmentedControlIndex = 1
            ageSegmentedControlIndex = 0
        } else if sortByAge == .up, sortByGender == .female {
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .female }
                .sorted { Int($0.dateOfBirtdh!)! < Int($1.dateOfBirtdh!)! }
            genderSegmentedControlIndex = 1
            ageSegmentedControlIndex = 1
        } else if sortByAge == .down, sortByGender == .female {
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .female }
                .sorted { Int($0.dateOfBirtdh!)! > Int($1.dateOfBirtdh!)! }
            genderSegmentedControlIndex = 1
            ageSegmentedControlIndex = 2
        } else if sortByAge == .random, sortByGender == .male {
            personsWithAgeToShow = personsWithAge.filter { $0.gender == .male }
            genderSegmentedControlIndex = 2
            ageSegmentedControlIndex = 0
        } else if sortByAge == .up, sortByGender == .male {
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .male }
                .sorted { Int($0.dateOfBirtdh!)! < Int($1.dateOfBirtdh!)! }
            genderSegmentedControlIndex = 2
            ageSegmentedControlIndex = 1
        } else if sortByAge == .down, sortByGender == .male {
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .male }
                .sorted { Int($0.dateOfBirtdh!)! > Int($1.dateOfBirtdh!)! }
            genderSegmentedControlIndex = 2
            ageSegmentedControlIndex = 2
        }
    }

    func stateOfSegmentedControl(genderSegmentedControl: UISegmentedControl, ageSegmentedControl: UISegmentedControl) {
        genderSegmentedControl.selectedSegmentIndex = genderSegmentedControlIndex
        ageSegmentedControl.selectedSegmentIndex = ageSegmentedControlIndex
    }

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

    // Parses data.
    func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Persons.self, from: jsonData)

            persons = decodedData
            personsWithAge = persons.map { Person(firstName: $0.firstName,
                                                  gender: $0.gender,
                                                  dateOfBirtdh: String(Date().age(from: $0.dateOfBirtdh ?? "Nil") ?? 0)) }
        } catch {
            print("Decode error.")
        }
    }
}
