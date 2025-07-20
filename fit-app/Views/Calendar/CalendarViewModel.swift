import Foundation

class CalendarViewModel: ObservableObject {
    private let calendar: Calendar
    
    init() {
        // Force Monday = 2 for all locales
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2  // Monday
        self.calendar = cal
    }
    
    func columnIndex(for date: Date) -> Int {
        // weekday: 1=Sun … 7=Sat
        let wd = calendar.component(.weekday, from: date)
        // Convert to 0=Lunes … 6=Domingo
        // More elegant mapping: ((wd + 5) % 7)
        return (wd + 5) % 7
    }
    
    func isInCurrentWeek(_ date: Date) -> Bool {
        let today = Date()
        return calendar.isDate(date, equalTo: today, toGranularity: .weekOfYear)
    }
    
    func startOfWeek(for date: Date) -> Date {
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        components.weekday = 2  // Monday
        return calendar.date(from: components) ?? date
    }
    
    func endOfWeek(for date: Date) -> Date {
        let start = startOfWeek(for: date)
        return calendar.date(byAdding: .day, value: 6, to: start) ?? date
    }
}