//
//  JTAppleCalendarDelegateProtocol.swift
//  JTAppleCalendar
//
//  Created by JayT on 2016-09-19.
//
//


protocol JTAppleCalendarDelegateProtocol: class {
    var itemSize: CGFloat? {get set}
    var registeredHeaderViews: [JTAppleCalendarViewSource] {get set}
    var cachedConfiguration: ConfigurationParameters! {get set}
    var monthInfo: [Month] {get set}
    var monthMap: [Int: Int] {get set}
    var totalDays: Int {get}
    var lastIndexOffset: (IndexPath, UICollectionElementCategory)? {get set}
    var allowsDateCellStretching: Bool {get set}
    
    func numberOfRows() -> Int
    func hasStrictBoundaries() -> Bool
    func cachedDate() -> (start: Date, end: Date, calendar: Calendar)
    func numberOfMonthsInCalendar() -> Int
    func referenceSizeForHeaderInSection(_ section: Int) -> CGSize
    func rowsAreStatic() -> Bool
}

extension JTAppleCalendarView: JTAppleCalendarDelegateProtocol {

    func cachedDate() -> (start: Date, end: Date, calendar: Calendar) {
        return (start: startDateCache,
                end: endDateCache,
                calendar: calendar)
    }
    
    func hasStrictBoundaries() -> Bool {
        return cachedConfiguration.hasStrictBoundaries
    }

    func numberOfRows() -> Int {
        return cachedConfiguration.numberOfRows
    }

    func numberOfMonthsInCalendar() -> Int {
        return numberOfMonths
    }

    func referenceSizeForHeaderInSection(_ section: Int) -> CGSize {
        return calendarViewHeaderSizeForSection(section)
    }

    func rowsAreStatic() -> Bool {
        // jt101 is the inDateCellGeneration check needed? because tillEndOfGrid will always compenste
        return cachedConfiguration.generateInDates != .off && cachedConfiguration.generateOutDates == .tillEndOfGrid
    }
}
