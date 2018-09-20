//
//  DateExtension.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/09/20.
//

import Foundation

extension Date {
    static func from(string:String, dateFormat : String = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX") -> Date? {
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone   = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone   = TimeZone(abbreviation: "GMT")
        
        return dateFormatter.date(from: string)
    }
}
