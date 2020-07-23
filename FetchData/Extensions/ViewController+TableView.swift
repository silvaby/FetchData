//
//  ViewController+TableView.swift
//  FetchData
//
//  Created by Dzmitry on 7/22/20.
//  Copyright © 2020 Dzmitry Krukov. All rights reserved.
//

import UIKit

// MARK: - Properties

private var personsManager = ServiceLocator.shared.personsManager
private let idCell = "PersonCell"

// MARK: - Create and configure table

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return personsManager.personsWithAgeToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? CustomTableViewCell

        // Configure the cell
        if let name = personsManager.personsWithAgeToShow[indexPath.row].firstName {
            cell?.firstName.text = name
        } else { cell?.firstName.text = "No name" }

        if let age = personsManager.personsWithAgeToShow[indexPath.row].dateOfBirtdh {
            switch age {
            case "0":
                cell?.age.text = "No age"
            case "1":
                cell?.age.text = "\(age) year"
            default:
                cell?.age.text = "\(age) years"
            }
        } else { cell?.age.text = "No age" }

        if let gender = personsManager.personsWithAgeToShow[indexPath.row].gender {
            if gender == .female {
                cell?.genderImage.image = UIImage(named: "Female")
            } else {
                cell?.genderImage.image = UIImage(named: "Male")
            }
        }
        return cell!
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let destinationVC: DetailsViewController = segue.destination as? DetailsViewController,
            let selectedItem = tableView.indexPathForSelectedRow?.item {
            if let firstName = personsManager.personsWithAgeToShow[selectedItem].firstName {
                destinationVC.textOfName = firstName
            }
            if let age = personsManager.personsWithAgeToShow[selectedItem].dateOfBirtdh {
                destinationVC.textOfAge = age
            }
            if let gender = personsManager.personsWithAgeToShow[selectedItem].gender {
                destinationVC.textOfGender = gender.rawValue
            }
        }
    }
}
