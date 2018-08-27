//
//  Date+extension.swift
//  SwiftEssentials
//
//  Created by Anil Santo on 27/08/18.
//  Copyright © 2018 Anil Santo. All rights reserved.
//

import Foundation


public extension Date{
    fileprivate struct AssociatedKeys {
        static var TimeZone = "timepiece_TimeZone"
    }
    
    func hour() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.hour, from: self)
        return dateComponent.hour!
    }
    
    func second() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.second, from: self)
        return dateComponent.second!
    }
    
    func minute() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.minute, from: self)
        return dateComponent.minute!
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.day, from: self)
        return dateComponent.day!
    }
    
    func weekday() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.weekday, from: self)
        return dateComponent.weekday!
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.month, from: self)
        return dateComponent.month!
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.year, from: self)
        return dateComponent.year!
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    var timeZone: NSTimeZone {
        return objc_getAssociatedObject(self, &AssociatedKeys.TimeZone) as? NSTimeZone ?? calendar.timeZone as NSTimeZone
    }
    
    fileprivate var components: DateComponents {
        return (calendar as NSCalendar).components([.year, .month, .weekday, .day, .hour, .minute, .second], from: self)
    }
    
    fileprivate var calendar: NSCalendar {
        return (NSCalendar.current as NSCalendar)
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self as Date)))!
    }
    
    func endOfMonth() -> Date {
        let dateComponent = NSDateComponents()
        dateComponent.day = -1
        dateComponent.month = 1
        return Calendar.current.date(byAdding: dateComponent as DateComponents, to: self.startOfMonth() as Date)!
    }
    
    static func getDayOfWeek(date:String)->String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        if let todayDate = formatter.date(from: date) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday! - 1
            let weekdays : NSArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            return weekdays.object(at: weekDay) as? String
        } else {
            return nil
        }
    }
    
    static func weeksInMonth(month: Int, year: Int) -> (Int)? {
        let calendar = NSCalendar.current
        var comps = DateComponents()
        comps.month = month+1
        comps.year = year
        comps.day = 0
        guard let last = calendar.date(from:comps) else {
            return nil
        }
        let tag = calendar.dateComponents([.weekOfMonth,.weekOfYear,
                                           .yearForWeekOfYear,.weekday,.quarter], from: last)
        return tag.weekOfMonth
    }
    
    static func dateFrom(string : String,format : String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_GB")
        let timeZone : TimeZone = TimeZone(abbreviation: "GMT")!
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: string)
    }
    
    func dateTo(format : String) ->  String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format as String
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.locale = Locale(identifier: "en_GB")
        let timeZone : TimeZone = TimeZone(abbreviation: "GMT")!
        dateFormatter.timeZone = timeZone
        let date : String = dateFormatter.string(from: self as Date)
        return date
    }
    
    static func formatDateWith(dateString : String,fromFormat : String, toFormat : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dateFormatter.locale = Locale(identifier: "en_GB")
        let timeZone : TimeZone = TimeZone(abbreviation: "GMT")!
        dateFormatter.timeZone = timeZone
        let dateFromString = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = toFormat
        if dateFromString != nil{
            let dateString = dateFormatter.string(from: dateFromString!)
            return dateString
        }
        return ""
    }
    
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    static func addTo(date : Date, day : Int) -> Date{
        return addTo(date: date, day: day, month: 0, year: 0)
    }
    
    static func addTo(date : Date, day : Int,month : Int,year : Int) -> Date{
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let dateComponent = NSDateComponents()
        dateComponent.day = day
        dateComponent.month = month
        dateComponent.year = year
        let newDate = calendar?.date(byAdding: dateComponent as DateComponents, to: date as Date, options:.matchStrictly)
        return newDate! as Date
    }
}
