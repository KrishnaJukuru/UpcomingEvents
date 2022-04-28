//
//  EventsModel.swift
//  Events
//
//  Created by Krishna Jukuru on 04/27/22.
//  Copyright © 2022 Krishna Jukuru. All rights reserved.
//

import Foundation

struct Event: Decodable {
    let title: String?
    let start: String?
    let end: String?
    let groupStartDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case title
        case start
        case end
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try? values.decodeIfPresent(String.self, forKey: .title)
        start = try? values.decodeIfPresent(String.self, forKey: .start)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy hh:mm a"
        if let date = dateFormatter.date(from: start ?? "") {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            groupStartDate = Calendar.current.date(from: components)
        } else {
            groupStartDate = nil
        }
        
        end = try? values.decodeIfPresent(String.self, forKey: .end)
    }
}
