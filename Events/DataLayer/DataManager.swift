//
//  DataManager.swift
//  Events
//
//  Created by Krishna Jukuru on 04/27/22.
//  Copyright © 2022 Krishna Jukuru. All rights reserved.
//

import Foundation
typealias resultBlock = (_ isSuccess: Bool, _ error: String?) -> Void

class DataManager {
    static let shared = DataManager()
    
    func getAllEvents(completionBlock: @escaping (_ events: [Event]?,
                                                     _ status: String?) -> Void) {
        guard let jsonData = parseResponseFromJsonFile("events") else {
            return
        }
        var resultArray:[Event] = []
        let (parsedData, errorStr) = self.processData(decodableType: [Event].self, data: jsonData)
        if errorStr == nil, let eventObj = parsedData {
            for event in eventObj {
                resultArray.append(event)
            }
            completionBlock(resultArray, nil)
        } else {
            completionBlock(nil, errorStr)
        }
    }
}

extension DataManager {
    func parseResponseFromJsonFile(_ file: String) -> Data? {
        let testBundle = Bundle.main
        if let path = testBundle.path(forResource: file, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path),
                                        options: NSData.ReadingOptions.mappedIfSafe)
                return jsonData
            } catch let error as NSError {
                print("Error opening file. \(error), \(error.userInfo)")
                return nil
            }
        }
        return nil
    }
    
    func processData<T: Decodable>(decodableType: T.Type, data: Data?) -> (T?, String?) {
        if let resultdata = data {
            do {
                let decoder = JSONDecoder()
                let decodedObj = try decoder.decode(decodableType, from: resultdata)
                return (decodedObj, nil)
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:\(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' value not found:\(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch:\(context.debugDescription)")
                print("codingPath: \(context.codingPath)")
            } catch(let err) {
                print(err.localizedDescription)
                return (nil, err.localizedDescription)
            }
        }
        return (nil, "Data Unavailable")
    }
}
