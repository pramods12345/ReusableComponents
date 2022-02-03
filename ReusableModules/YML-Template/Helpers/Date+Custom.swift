//
// Date+Custom.swift
// Crohns

// Created by Y Media Labs on 03/09/19.
// Copyright © 2019 Y Media Labs. All rights reserved.
//

import Foundation

public let dateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
public let dateFormat = "yyyy-MM-dd"
public let timeFormat = "hh:mm a"
public let utc = "UTC"
public let dayShort = "EEE"
public let shortDate = "MMM dd\nyyyy"

/// These extensions implements all helper functions for date formatings, date convertions, date fetchings, offset calculations.
public extension Date {

    func convertToString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    /// Converts the Time interval value to Date by using timeIntervalSince1970.
    ///
    /// - Parameter date: The date in TimeInterval.
    /// - Returns: Date
    static func dateFrom(timeinterval date: TimeInterval) -> Date {
        return (Date(timeIntervalSince1970: date / 1000))
    }
    
    /// Converts the Time interval value to date string with the given format.
    ///
    /// - Parameters:
    ///   - date: The date in TimeInterval.
    ///   - format: The date string format. Default format is date format ("yyyy-MM-dd").
    /// - Returns: String with given date format
    static func dateStringFrom (timeinterval date: TimeInterval, format: String = dateFormat) -> String {
        let dateValue = self.dateFrom(timeinterval: date)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: dateValue)
    }
    
    /// Converts the current date to milliseconds.
    ///
    /// - Returns: Milliseconds in double.
    static func currentDateInMilliSeconds() -> Double {
        return round(Date().timeIntervalSince1970 * 1000)
    }
    
    ///  Converts the date intialized to milliseconds.
    ///
    /// - Returns: Milliseconds in double.
    func milliSeconds() -> Double {
        return round(self.timeIntervalSince1970 * 1000)
    }
    
    ///  Returns bool value by verifying the date passed to compare is greater than intialized date or not.
    ///
    /// - Parameter dateToCompare: Date use to compare with the other date.
    /// - Returns: Bool
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        var isGreater = false
        
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending || self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isGreater = true
        }
        
        return isGreater
    }
    
    ///  Returns bool value by verifying the date passed to compare is less than intialized date or not.
    ///
    /// - Parameter dateToCompare: Date use to compare with the other date.
    /// - Returns: Bool
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        var isGreater = false
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending || self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isGreater = true
        }
        
        return isGreater
    }
    
    ///  Returns bool value by verifying the date passed to compare is equal to intialized date or not.
    ///
    /// - Parameter dateToCompare: Date use to compare with the other date.
    /// - Returns: Bool
    func isBothSameDay(_ dateToCompare: Date?) -> Bool {
        var isValid = true
        let calendar = Calendar.current
        if let dateToCompare = dateToCompare {
            isValid = calendar.isDate(self, inSameDayAs: dateToCompare)
        }
        
        return isValid
    }
    
    /// Returns bool value by verifying the two dates passed are equal or not.
    ///
    /// - Parameters:
    ///   - lhs: First date use to compare with the other date.
    ///   - rhs: Second date use to compare with the other date.
    /// - Returns: Bool
    func isSameDate(_ lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedSame
    }
    
}

public extension Date {
    
    func getDates(for days: Int, interval: Int, format: String = dayShort) -> [String] {
        var arrayOfDates = [String]()
        arrayOfDates.append(self.convertToString(format: format))
        for index in 1...interval {
            arrayOfDates.append(self.getDate(for: (index * days)).convertToString(format: format))
        }
        return arrayOfDates
    }
    
    func getDates(forLastNDays nDays: Int, format: String = dayShort) -> [String] {
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: Date())
        var arrayOfDates = [String]()
        
        for _ in 0 ... nDays - 1 {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date) ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            let dateString = dateFormatter.string(from: date)
            arrayOfDates.append(dateString)
        }
        return arrayOfDates
    }
    
    func getDate(for days: Int) -> Date {
        let date = Calendar.current.date(byAdding: .day, value: days, to: self)
        return date ?? Date()
    }
    
    /// Returns start date of current month from the initialized date.
    ///
    /// - Returns: Date
    func startOfMonth() -> Date {
        var calendar = Calendar.current
        if let calendarTimeZone = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = calendarTimeZone
        }
        let currentDateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month], from: self)
        let startOfMonth = calendar.date(from: currentDateComponents) ?? Date()
        return startOfMonth
    }
    
    /// Returns Date by adding required number of months to the initialized date.
    ///
    /// - Parameter toAdd: The number of months to be added.
    /// - Returns: Date
    func dateByAdding(months toAdd: Int) -> Date {
        let calendar = Calendar.current
        var months = DateComponents()
        months.month = toAdd
        return (calendar as NSCalendar).date(byAdding: months, to: self, options: []) ?? Date()
    }
    
    /// Returns end date of current month of the initialized date.
    ///
    /// - Returns: Date
    func endOfMonth() -> Date {
        let calendar = Calendar.current
        let plusOneMonthDate = dateByAdding(months: 1)
        let plusOneMonthDateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month], from: plusOneMonthDate)
        let endOfMonth = calendar.date(from: plusOneMonthDateComponents) ?? Date()
        return endOfMonth.addingTimeInterval(-1)
    }
    
    /// Returns Int, number of years between the date passed and intialized date.
    ///
    /// - Parameter date: Date to calculate the number of years.
    /// - Returns: Int
    func years(from date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year ?? 0
    }
    
    /// Returns Int, number of months between the date passed and intialized date.
    ///
    /// - Parameter date: Date to calculate the number of months.
    /// - Returns: Int
    func months(from date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month ?? 0
    }
    
    /// Returns Int, number of weeks between the date passed and intialized date.
    ///
    /// - Parameter date: Date to calculate the number of weeks.
    /// - Returns: Int
    func weeks(from date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear ?? 0
    }
    
    /// Returns Int, number of days between the date passed and intialized Date.
    ///
    /// - Parameter date: Date to calculate the number of days.
    /// - Returns: Int
    func days(from date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day ?? 0
    }
    
    /// Returns Int, number of hours between the date passed and intialized date.
    ///
    /// - Parameter date: Date to calculate the number of hours.
    /// - Returns: Int
    func hours(from date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour ?? 0
    }
    
    /// Returns Int, number of minutes between the date passed and intialized date.
    ///
    /// - Parameter date: Date to calculate the number of minutes.
    /// - Returns: Int
    func minutes(from date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute ?? 0
    }
    
    /// Returns Int, number of seconds between the date passed and intialized date.
    ///
    /// - Parameter date: Date to calculate the number of seconds.
    /// - Returns: Int
    func seconds(from date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second ?? 0
    }
    
    /// Returns Offset value as string between the date passed and intialized date.
    ///
    /// - Parameter date: Date to calculate the offset.
    /// - Returns: String
    func offset(from date: Date) -> String {
        if years(from: date) > 0 {
            let offsetYears = years(from: date)
            return  offsetYears > 1 ? "\(offsetYears) years ago" : "\(offsetYears) year ago"
        }
        if months(from: date) > 0 {
            let offsetMonths = months(from: date)
            return offsetMonths > 1 ? "\(offsetMonths) months ago" : "\(offsetMonths) month ago"
        }
        if weeks(from: date) > 0 {
            let offsetWeeks = weeks(from: date)
            return offsetWeeks > 1 ? "\(offsetWeeks) weeks ago" : "\(offsetWeeks) week ago"
        }
        if days(from: date) > 0 {
            let offsetDays = days(from: date)
            return offsetDays > 1 ? "\(offsetDays) days ago" : "\(offsetDays) day ago"
        }
        if hours(from: date) > 0 {
            let offsetHours = hours(from: date)
            return offsetHours > 1 ? "\(offsetHours) hours ago" : "\(offsetHours) hour ago"
        }
        if minutes(from: date) > 0 {
            let offsetMinutes = minutes(from: date)
            return offsetMinutes > 1 ? "\(offsetMinutes) minutes ago" : "\(offsetMinutes) minute ago"
        }
        if seconds(from: date) > 0 {
            return "Just now"
        }
        return ""
    }
    
    /// Returns the gramatical string format of the difference between years
    ///
    /// - Parameter year: The difference of year
    /// - Returns: String
    func getYears(year: Int) -> String {
        var diff = ""
        if year > 0 {
            if year > 1 {
                diff += "\(year) years "
            } else {
                diff += "\(year) year "
            }
            return diff
        }
        return ""
    }
    
    /// Returns the gramatical string format of the difference between month and start of the ending year
    ///
    /// - Parameter monthMod: The mod of Months remaining, excluding the months calculated in years
    /// - Returns: String
    func getMonths(monthMod: Int) -> String {
        var diff = ""
        if monthMod > 0 {
            if monthMod > 1 {
                diff += "\(monthMod) months "
            } else {
                diff += "\(monthMod) month "
            }
            return diff
        }
        return ""
    }
    
    ///Returns the gramatical string format of the difference between Self and start of the month in which Self lies.
    ///
    /// - Parameters:
    ///     - day: number of days between the dates
    ///     - numOfDays: num of days in the ending year till the month in which Self lies
    /// - Returns: String
    func getDays(day: Int, numOfDays: Int) -> String {
        var diff = ""
        ///Day +1 is made so that current day (self) and end Date is included in calculations. as per requirements
        let modDay = (day + 2) % numOfDays
        if modDay > 0 {
            if day > 1 {
                diff += "\(modDay) days "
            } else {
                diff += "\(modDay) day "
            }
            return diff
        }
        
        return ""
    }
    
    /// Returns the gramatical string format of the difference between Self and the Hour sent
    ///
    /// - Parameter hours: End Hour in comparision
    /// - Returns: String
    func getHours(hours: Int) -> String {
        var diff = ""
        let hour = hours % 24
        if hour > 0 {
            if hour > 1 {
                diff += "\(hour) hours "
            } else {
                diff += "\(hour) hour "
            }
            return diff
        }
        
        return ""
    }
    
    /// Gets the number of days in a particular month for a particular year
    ///
    /// - Parameters:
    ///     - year: Current Year to which the month belongs
    ///     - currentMonth: The month to which days is to be calculated
    /// - Returns: Number of days in Int.
    func getDaysInMonth(year: String, currentMonth: Int) -> Int {
        let dateComponents = NSDateComponents()
        let calendar = NSCalendar.current
        dateComponents.month = currentMonth
        dateComponents.year = Int(year) ?? 0
        let date = calendar.date(from: dateComponents as DateComponents) ?? Date()
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    /// Returns the gramatical string format of the difference between initialized and given date.
    ///
    /// - Parameter date: Date to which, it is to be compared.
    /// - Returns: Offset in string.
    func differenceOffset(date: Date) -> String {
        var diff = ""
        var numOfDays = 0
        
        let year = getYears(year: years(from: date as Date))
        diff += year
        
        let monthMod = months(from: date as Date) % 12  // To exclude the months which was calculated in getYears.
        let month = getMonths(monthMod: monthMod)
        diff += month
        
        if monthMod > 0 {
            for index in 0...monthMod {
                numOfDays += getDaysInMonth(year: Date().string(fromDate: self, format: "yyyy") ?? "", currentMonth: index)
            }
            
            if numOfDays > 0 {
                let offsetDays = getDays(day: days(from: startOfMonth()), numOfDays: numOfDays)
                diff += offsetDays
            }
        } else {
            if days(from: date) != 0 {
                let offsetDays = days(from: date)
                diff = offsetDays != -1 ? String(-days(from: date)) + " days" : ""
            }
        }
        if diff.isEmpty {
            if hours(from: date) != 0 {
                let offsetHours = hours(from: date)
                diff = offsetHours != -1 ? "1 day " + getHours(hours: -hours(from: date)) : "1 hour"
            } else {
                diff = "0 days"
            }
        }
        return diff
    }
    
    /// Returns the date by converting the given date string with given format. Returns nil if the convertion is not succeded.
    ///
    /// - Parameters:
    ///   - string: Date in string
    ///   - format: Date format string
    /// - Returns: Optional Date based on convertion.
    static func date(fromString string: String, format: String) -> Date? {
        var date: Date?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        date = dateFormatter.date(from: string)
        return date
    }
    
    /// Returns the string by converting the given date with given format. Returns nil if the convertion is not succeded.
    ///
    /// - Parameters:
    ///   - date: Date to convert
    ///   - format: Date format string
    /// - Returns: Optional String based on convertion.
    func string(fromDate date: Date?, format: String) -> String? {
        var dateString: String?
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            dateString = formatter.string(from: date)
        }
        return dateString
        
    }
    
    /// Method to return the given day in ordinal style. Example - Passing 27 returns 27th
    /// 
    /// - Parameter dayAsString: Day to be converted to ordinal style
    func getDayInOrdinalStyle(day dayAsString: String) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        guard let dayAsInt = Int(dayAsString) else { return nil }
        
        let dayAsNSNumber = NSNumber(value: dayAsInt)
        guard let dayInOrdinalStyle = numberFormatter.string(from: dayAsNSNumber) else { return nil }
        
        return dayInOrdinalStyle
    }
}
