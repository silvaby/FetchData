import Foundation

class PersonsManager {
    // MARK: - Properties

    /// Main URL
    private let stringURL = "https://my.api.mockaroo.com/persons.json?key=f43efc60"
    /// `Persons`.
    private var persons = Persons()
    /// `Persons` with age
    private var personsWithAge = Persons()

    /// `Persons` with age to show
    var personsWithAgeToShow = Persons()
    var stateOfGender = "R"
    var stateOfAge = "R"
    var state = ""

    /// Changes the information.
    func change() {
        state = stateOfGender + stateOfAge

        switch state {
        case "RR":
            personsWithAgeToShow = personsWithAge
        case "RU":
            personsWithAgeToShow = personsWithAge.sorted { Int($0.dateOfBirtdh!)! < Int($1.dateOfBirtdh!)! }
        case "RD":
            personsWithAgeToShow = personsWithAge.sorted { Int($0.dateOfBirtdh!)! > Int($1.dateOfBirtdh!)! }

        case "FR":
            personsWithAgeToShow = personsWithAge.filter { $0.gender == .female }
        case "FU":
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .female }
                .sorted { Int($0.dateOfBirtdh!)! < Int($1.dateOfBirtdh!)! }

        case "FD":
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .female }
                .sorted { Int($0.dateOfBirtdh!)! > Int($1.dateOfBirtdh!)! }

        case "MR":
            personsWithAgeToShow = personsWithAge.filter { $0.gender == .male }
        case "MU":
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .male }
                .sorted { Int($0.dateOfBirtdh!)! < Int($1.dateOfBirtdh!)! }
        case "MD":
            personsWithAgeToShow = personsWithAge
                .filter { $0.gender == .male }
                .sorted { Int($0.dateOfBirtdh!)! > Int($1.dateOfBirtdh!)! }
        default:
            break
        }
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
