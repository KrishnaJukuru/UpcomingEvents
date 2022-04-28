//
//  EventsViewModel.swift
//  Events
//
//  Created by Krishna Jukuru on 04/27/22.
//  Copyright © 2022 Krishna Jukuru. All rights reserved.
//

import Foundation
import UIKit

class EventsViewModel {
    
    let cellIdentifier = "Basic"
    
    private var events: [Event] = []
    var eventsGroupedByDate: [Date?: [Event]] = [:]
    var groupKeys : Array = [Date?]()
    
    var headerheight: CGFloat {
        return 30.0
    }
    
    func fetchallEvents(completionBlock: @escaping resultBlock) {
        
        DataManager.shared.getAllEvents {[weak self] (resultEvents, error) in
            if let eventObj = resultEvents, eventObj.count > 0 {
                self?.events = eventObj
                self?.processEventsByDate()
                completionBlock(true, nil)
            } else {
                completionBlock(false, error)
            }
        }
    }

    func processEventsByDate() {
        self.events.sort { lhs, rhs in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
            if let lhsDate = dateFormatter.date(from: lhs.start ?? ""),
               let rhsDate = dateFormatter.date(from: rhs.start ?? "") {
                return lhsDate.compare(rhsDate) == .orderedAscending
            }
            return false
        }

        eventsGroupedByDate = Dictionary(grouping: events) { $0.groupStartDate }
        if let keys = (eventsGroupedByDate as NSDictionary).allKeys as? [Date] {
            groupKeys = keys.sorted(by: { $0.compare($1) == .orderedAscending })
        }
    }
    
    
    //MARK TableView related
    func item(at index:IndexPath) -> String {
        let group = groupKeys[index.section]
        var eventHasConflict = false
        
        if let events = eventsGroupedByDate[group] {
            let requiredEvent = events[index.row]
            
            for event in events {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
                
                if let leftStart = dateFormatter.date(from: requiredEvent.start ?? ""),
                   let leftEnd = dateFormatter.date(from: requiredEvent.end ?? ""),
                   let rightStart = dateFormatter.date(from: event.start ?? ""),
                   let rightEnd = dateFormatter.date(from: event.end ?? "") {
                    
                    if requiredEvent.title == event.title ||
                        leftEnd == rightStart ||
                        leftStart == rightEnd {
                        continue
                    }
                    
                    if leftStart == rightStart || leftEnd == rightEnd {
                        eventHasConflict = true
                        break
                    }
                    
                    if leftStart != rightStart,
                       leftEnd != rightStart {
                        let leftRange = leftStart ... leftEnd
                        let rightRange = rightStart ... rightEnd
                        
                        if leftRange.contains(rightStart) ||
                            leftRange.contains(rightEnd) ||
                            rightRange.contains(leftStart) ||
                            rightRange.contains(leftEnd) {
                            eventHasConflict = true
                            break
                        }
                    }
                }
            }
        }
        
        if let events = eventsGroupedByDate[group] {
            return getEventDetails(for: events[index.row], hasConflict: eventHasConflict)
        }
        return ""
    }
    
    
    private func getEventDetails(for event: Event, hasConflict: Bool) -> String {
        var eventDetails = """
Event: \(event.title ?? "")
Start: \(event.start ?? "")
End: \(event.end ?? "")
"""
        if hasConflict {
            eventDetails += "\n** Has Conflicts **"
        }
        return eventDetails
    }
    
}
