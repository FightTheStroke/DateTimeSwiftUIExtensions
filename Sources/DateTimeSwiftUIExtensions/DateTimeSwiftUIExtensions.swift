//  DateTimeTools.swift
//
//  Created by Roberto D’Angelo on 21/04/2020.
//  Copyright © 2020 FightTheStroke Foundation. All rights reserved.
//

import Foundation
import SwiftUI

internal let dateFormatter = DateFormatter()

// extension for easily handle timeinterval outcomes in string and different formats
@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
public class MainTimer: ObservableObject {
    public static var shared = MainTimer()
    
    @Published public var now: TimeInterval = Date().timeIntervalSince1970
    @Published public var sinceStartingTime: TimeInterval = 0
    
    private var startingTime: TimeInterval?
    
    public init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.now = Date().timeIntervalSince1970
                guard let startingTime = self.startingTime else {
                    return
                }
                self.sinceStartingTime = self.now - startingTime
            }
        }
    }
    
    public func startTimer() {
        sinceStartingTime = 0
        startingTime = Date().timeIntervalSince1970
    }
    
    public func stopTimer() {
        startingTime = nil
    }
}

public extension TimeInterval {
    internal static let timeStampFormatterHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    func timeClockFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func timeClockFullFormatter() -> String {
        Self.timeStampFormatterHHmmss.string(from: Date(timeIntervalSince1970: self))
    }
    
    func secsOnly() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        return formatter.string(from: Date(timeIntervalSince1970: self))
    }
    
    func toTimeStampFormatter() -> String {
        Self.timeStampFormatterHHmmss.string(from: Date(timeIntervalSince1970: self))
    }
    
    func timeStampHHmmFormatter() -> String {
        Self.timeStampFormatterHHmmss.string(from: Date(timeIntervalSince1970: self))
    }
    
    func toHHmmssString() -> String {
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        let returnedHs = (hours == 0 ? "00:" : (hours < 10 ? "0\(hours):" : "\(hours):"))
        let returnedStringMin = (minutes == 0 ? "00:" : (minutes < 10 ? "0\(minutes):" : "\(minutes):"))
        let returnedSeconds = (seconds == 0 ? "00" : (seconds < 10 ? "0\(seconds)" : "\(seconds)"))
        return (returnedHs + returnedStringMin + returnedSeconds)
    }
    
    func toSmartHHMMssString() -> String {
        var returnedStringMin: String
        var returnedStringHH: String
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        if hours > 0 {
            returnedStringHH = ((hours < 10) ? "0\(hours):" : "\(hours):")
        } else {
            returnedStringHH = ""
        }
        if minutes > 0 {
            returnedStringMin = (minutes < 10 ? "0\(minutes):" : "\(minutes):")
        } else {
            returnedStringMin = ""
        }
        
        let returnedSeconds = ((seconds < 10 && minutes > 0) ? "0\(seconds)" : "\(seconds)")
        return (returnedStringHH + returnedStringMin + returnedSeconds)
    }
    
    func toFullHHMMssString() -> String {
        var returnedStringMin: String
        var returnedStringHH: String
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        if minutes > 0 {
            returnedStringMin = (minutes < 10 ? "0\(minutes):" : "\(minutes):")
        } else {
            returnedStringMin = "00:"
        }
        
        if hours > 0 {
            returnedStringHH = ((hours < 10) ? "0\(hours):" : "\(hours):")
        } else {
            returnedStringHH = "00:"
        }
        let returnedSeconds = ((seconds < 10) ? "0\(seconds)" : "\(seconds)")
        return (returnedStringHH + returnedStringMin + returnedSeconds)
    }
    
    func toMMssStringWatch() -> String {
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let returnedStringMin = (minutes < 10 ? "0\(minutes):" : "\(minutes):")
        let returnedSeconds = (seconds < 10 ? "0\(seconds)" : "\(seconds)")
        return ((minutes > 0 ? returnedStringMin : "") + returnedSeconds)
    }
    
    func toFullText() -> String {
        let time = Int(self)
        let milliSeconds = String(Int(truncatingRemainder(dividingBy: 1) * 1000))
        let seconds = String(time % 60)
        let minutes = String((time / 60) % 60)
        let hours = String(time / 3600)
        return (hours + ":" + minutes + ":" + seconds + ":" + milliSeconds)
    }
    
    func toHHmmss() -> String {
        let time = Int(self)
        let seconds = String(time % 60)
        let minutes = String((time / 60) % 60)
        let hours = String(time / 3600)
        return (hours + ":" + minutes + ":" + seconds)
    }
    
    func toHHmm() -> String {
        let time = Int(self)
        let minutes = String((time / 60) % 60)
        let hours = String(time / 3600)
        return (hours + " hs : " + minutes + " min")
    }
    
    func toHistoryViewFormat() -> String {
        let dateTmp = Date(timeIntervalSince1970: self)
        return dateTmp.returnDDmmYY()
    }
}

// it enables to easily have date in string formats
public extension Date {
    //    Date.yesterday    // "Oct 28, 2018 at 12:00 PM"
    //    Date()            // "Oct 29, 2018 at 11:01 AM"
    //    Date.tomorrow     // "Oct 30, 2018 at 12:00 PM"
    //
    //    Date.tomorrow.month   // 10
    //    Date().isLastDayOfMonth  // false
    
    func weekDaySymbol() -> String {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        return Calendar.current.weekdaySymbols[components.weekday! - 1]
    }
    
    func weekDayInt() -> Int? {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        return components.weekday
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static var yesterday: Date { Date().dayBefore }
    static var tomorrow: Date { Date().dayAfter }
    static var todayDiary: Date { Date().today }
    static let stdDateFormat = "dd-MM-yyyy HH:mm:ss"
    static let preciseDateFormat = "dd-MM-yy HH:mm:ss.SSS"
    static let dayMonthYear = "dd-MM-yyyy"
    static let preciseTime = "HH:mm:ss.SSS"
    static let stdTime = "HH:mm:ss"
    static let nightInterval = [21, 8]
    
    var startOfDay: Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        let date = Calendar.current.date(byAdding: components, to: startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
    
    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var today: Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var midnight: Date {
        Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    func toStdString() -> String {
        dateFormatter.dateFormat = Date.stdDateFormat
        return dateFormatter.string(from: self)
    }
    
    func toDayMonthYear() -> String {
        dateFormatter.dateFormat = Date.dayMonthYear
        return dateFormatter.string(from: self)
    }
    
    func toPreciseTime() -> String {
        dateFormatter.dateFormat = Date.preciseTime
        return dateFormatter.string(from: self)
    }
    
    func toStdTime() -> String {
        dateFormatter.dateFormat = Date.stdTime
        return dateFormatter.string(from: self)
    }
    
    func toPreciseString() -> String {
        dateFormatter.dateFormat = Date.preciseDateFormat
        return dateFormatter.string(from: self)
    }
    
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    
    var isLastDayOfMonth: Bool {
        dayAfter.month != month
    }
    
    func returnHHmm() -> String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    static func fromStdDateString(_ dateString: String) -> Date? {
        dateFormatter.dateFormat = Date.stdDateFormat
        return dateFormatter.date(from: dateString)
    }
    
    func returnDDmmYY() -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let day = components.day!
        let month = components.month!
        let year = components.year!
        let monthName = DateFormatter().monthSymbols[month - 1]
        return "\(day), \(monthName) \(year)"
    }
    
    func returnCloudPathForML() -> String {
        dateFormatter.dateFormat = "/yyyy/MM/dd/"
        return dateFormatter.string(from: self)
    }
    
    func addMonth(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: number, to: self)!
    }
    
    func addDay(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: number, to: self)!
    }
    
    func addSec(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: number, to: self)!
    }
    
    func monthsAgo(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: -number, to: self)!
    }
    
    func daysAgo(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: -number, to: self)!
    }
    
    func hoursAgo(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .hour, value: -number, to: self)!
    }
    
    func addHour(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .hour, value: number, to: self)!
    }
    
    func minsAgo(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .minute, value: -number, to: self)!
    }
    
    func addMins(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .minute, value: number, to: self)!
    }
    
    func secsAgo(number: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: -number, to: self)!
    }
    
    func lastDays(_ number: Int) -> Date {
        let delta = TimeInterval(number * 24 * 60 * 60)
        let newTime = timeIntervalSince1970 - delta
        return Date(timeIntervalSince1970: newTime)
    }
    
    func deltaHours(_ number: Int) -> Date {
        let delta = TimeInterval(number * 60 * 60)
        let newTime = timeIntervalSince1970 + delta
        return Date(timeIntervalSince1970: newTime)
    }
    
    func hours2Int() -> Int {
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: self)) ?? 0
    }
    
    func minutes() -> String {
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    func seconds() -> String {
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: self)
    }
    
#if os(iOS)
    func isNight() -> Bool {
        var isNight = false
        if hours2Int() < Date.nightInterval[1] || hours2Int() > Date.nightInterval[0] {
            isNight = true
        }
        return isNight
    }
    
    func isDay() -> Bool {
        var isDay = false
        if hours2Int() >= Date.nightInterval[1] || hours2Int() <= Date.nightInterval[0] {
            isDay = true
        }
        return isDay
    }
#endif
}

public extension Date {
    //    static let stdDateFormat = "dd-MM-yyyy HH:mm:ss"
    
    func returnFileName() -> String {
        dateFormatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
        return dateFormatter.string(from: self)
    }
    
    func toShort() -> String {
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    func day() -> String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    func compareVideoLogDates() -> String {
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
    
    func timelineDateHeader() -> String {
        let components = get(.day, .month, .year, .weekday)
        
        let weekday = components.weekday ?? 1
        let weekDay = Calendar.current.shortWeekdaySymbols[weekday - 1]
        let month = components.month ?? 1
        let monthSymbol = Calendar.current.shortMonthSymbols[month - 1]
        let weekdayString = "\(weekDay)".capitalizingFirstLetter()
        let monthString = "\(monthSymbol)".capitalizingFirstLetter()
        return weekdayString + " \(components.day ?? 0) " + monthString + " \(components.year ?? 1970)"
    }
    
    static func fromTimeLineDateHeader2Date(dateHeader: String) -> Date {
        dateFormatter.dateFormat = "E dd MMMM yyyy"
        return dateFormatter.date(from: dateHeader) ?? Date(timeIntervalSince1970: 0)
    }
    
    func dateHeader() -> String {
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: self)
    }
}

public extension String {
    func local() -> String {
        NSLocalizedString(self, bundle: Bundle.module, comment: "")
    }

    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = capitalizingFirstLetter()
    }
}
