import XCTest
@testable import fit_app

final class CalendarLogicTests: XCTestCase {

    var vm: CalendarViewModel!
    
    override func setUpWithError() throws {
        vm = CalendarViewModel()
    }
    
    override func tearDownWithError() throws {
        vm = nil
    }

    func testColumnIndex() throws {
        // 19-Jul-2025 → Sábado → columna 5 (0=L, 1=M, 2=X, 3=J, 4=V, 5=S, 6=D)
        let gmt = TimeZone(secondsFromGMT: 0)!
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = gmt
        
        let date = cal.date(from: DateComponents(year: 2025, month: 7, day: 19))!
        let columnIndex = vm.columnIndex(for: date)
        
        XCTAssertEqual(columnIndex, 5, "19 Jul 2025 (Saturday) should be in column 5 (S)")
    }
    
    func testWeekdayHeaderOrder() throws {
        let header = WeekdayHeader()
        XCTAssertEqual(header.symbols, ["L","M","X","J","V","S","D"], "Weekday symbols should be in correct order starting with Monday")
    }
    
    func testColumnIndexForAllDays() throws {
        let gmt = TimeZone(secondsFromGMT: 0)!
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = gmt
        
        // Test a full week: Monday 14 Jul to Sunday 20 Jul 2025
        let testCases = [
            (day: 14, expectedColumn: 0, dayName: "Monday"),    // L
            (day: 15, expectedColumn: 1, dayName: "Tuesday"),   // M
            (day: 16, expectedColumn: 2, dayName: "Wednesday"), // X
            (day: 17, expectedColumn: 3, dayName: "Thursday"),  // J
            (day: 18, expectedColumn: 4, dayName: "Friday"),    // V
            (day: 19, expectedColumn: 5, dayName: "Saturday"),  // S
            (day: 20, expectedColumn: 6, dayName: "Sunday")     // D
        ]
        
        for testCase in testCases {
            let date = cal.date(from: DateComponents(year: 2025, month: 7, day: testCase.day))!
            let columnIndex = vm.columnIndex(for: date)
            
            XCTAssertEqual(columnIndex, testCase.expectedColumn, 
                          "July \(testCase.day), 2025 (\(testCase.dayName)) should be in column \(testCase.expectedColumn)")
        }
    }
    
    func testColumnIndexAcrossTimezones() throws {
        let timezones = [
            TimeZone(secondsFromGMT: -6 * 3600)!, // GMT-6
            TimeZone(secondsFromGMT: 0)!,         // GMT
            TimeZone(secondsFromGMT: 1 * 3600)!   // GMT+1
        ]
        
        for timezone in timezones {
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = timezone
            
            // Same date: July 19, 2025 at noon local time
            let date = cal.date(from: DateComponents(year: 2025, month: 7, day: 19, hour: 12))!
            let columnIndex = vm.columnIndex(for: date)
            
            XCTAssertEqual(columnIndex, 5, 
                          "July 19, 2025 should be Saturday (column 5) in timezone \(timezone.identifier)")
        }
    }
    
    func testWeekStartCalculation() throws {
        let gmt = TimeZone(secondsFromGMT: 0)!
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = gmt
        
        // Friday July 18, 2025
        let friday = cal.date(from: DateComponents(year: 2025, month: 7, day: 18))!
        let weekStart = vm.startOfWeek(for: friday)
        
        // Should return Monday July 14, 2025
        let expectedStart = cal.date(from: DateComponents(year: 2025, month: 7, day: 14))!
        
        XCTAssertEqual(cal.startOfDay(for: weekStart), cal.startOfDay(for: expectedStart),
                      "Week should start on Monday July 14, 2025")
    }
}