//
//  FuncAndStuffs.swift
//  Sepiki
//
//  Created by Alva Wijaya on 28/01/19.
//  Copyright © 2019 Adi Sukarno Rachman. All rights reserved.
//

import Foundation

struct LessonData {
    let title: String
    let subtitle: String
}
struct HistoryData {
    let title: String
    let detail: String
    let subtitle: String
}


func firstDayOfMonth(date : Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components)!
}



func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    return dateFormat.date(from: str)!
}


