import Foundation

extension Date {
    /**
     Returns the age from the string of date.
     - Parameter string: The string of date.
     - Returns: The age as `Int` .

        If an invalid `String`,
        the method returns `nil`.
     */
    func age(from string: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        guard let newDate = dateFormatter.date(from: string) else {
            return nil
        }

        return Calendar.current.dateComponents([.year], from: newDate, to: self).year ?? nil
    }
}
