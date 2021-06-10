//
//  DatabaseManager.swift
//  veganBegan
//
//  Created by RelMac User Exercise3 on 2021/05/16.
//  Copyright © 2021 Release. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
/*
struct Menu {
    var name: String
    var type1: String
    var type2: String
}

struct Restaurant {
    var num: Int
    var name: String
    var food: String
    var hp: String
    var addr: String
    var detail: String
    var latitude: Double
    var longitude: Double
    var menu: [Menu]
    var type_max: String
    var type_min: String
    var rating: Double
    var rating_count: Int
}
*/
class DatabaseManager {
    static var ref: DatabaseReference! = Database.database(url: "https://veganbegan-6322d-default-rtdb.firebaseio.com/").reference()
    static var vegetarian_type = [[String: Any]]()
    static let maxElement = 45
 
    static func sortbyDistance(latitude: Double, longitude: Double) -> [[String: Any]] {
        var result = [[String: Any]]()
        DatabaseManager.ref.child("restaurant").observeSingleEvent(of: .value, with: { snapshot in
            result = snapshot.value as! [[String: Any]]
            result.sort(by: {
                let x1 = $0["Latitude"] as! Double - latitude
                let x2 = $0["Longitude"] as! Double - longitude
                let y1 = $1["Latitude"] as! Double - latitude
                let y2 = $1["Longitude"] as! Double - longitude
                return x1*x1 + x2*x2 < y1*y1 + y2*y2
            })
            if result.count > maxElement {result.removeLast(result.count - maxElement)}
        })
        return result
    }
    
    static func sortbyFoodCategory(category: String) -> [[String: Any]] {
        var result = [[String: Any]]()
        if category == "기타" {
            // exclude "한식, 양식, 일식, 중식, 카페, 분식"
            let exclude = Set(["분식", "양식", "일식", "중식", "카페", "한식"])
            let queryResult = DatabaseManager.ref.child("restaurant").queryOrdered(byChild: "food")
            queryResult.observeSingleEvent(of: .value, with: {snapshot in
                result = snapshot.value as! [[String: Any]]
                result.removeAll(where: {item in
                    exclude.contains(item["food"] as! String)
                })
                if result.count > maxElement {result.removeLast(result.count - maxElement)}
            })
        }
        else {
            let queryResult = DatabaseManager.ref.child("restaurant").queryEqual(toValue: category, childKey: "food")
            queryResult.observeSingleEvent(of: .value, with: {snapshot in
                result = snapshot.value as! [[String: Any]]
                if result.count > maxElement {result.removeLast(result.count - maxElement)}
            })
        }
        return result
    }
    
    static func sortbyRating() ->[[String: Any]] {
        var result = [[String: Any]]()
        let queryResult = DatabaseManager.ref.child("restaurant").queryOrdered(byChild: "rating")
        queryResult.observeSingleEvent(of: .value, with: {snapshot in
            result = snapshot.value as! [[String: Any]]
            result.sort(by: {(a, b) in
                (a["rating"] as! Double) < (b["rating"] as! Double)
            })
            if result.count > maxElement {result.removeFirst(result.count - maxElement)}
            result.reverse()
        })
        return result
    }
    
    static func sortbyRelevance(type: String) -> [[String: Any]] {
        var result = [[String: Any]]()
        struct initialize {
            static var value = true
        }
        if initialize.value {
            // fetch the vegetarian type info.
            let queryResult = DatabaseManager.ref.child("vege_type").queryOrdered(byChild: "level")
            queryResult.observeSingleEvent(of: .value, with: {snapshot in
                DatabaseManager.vegetarian_type = snapshot.value as! [[String: Any]]
            })
            initialize.value = false
        }
        DatabaseManager.ref.child("restaurant").observeSingleEvent(of: .value, with: {snapshot in
            let level_user = DatabaseManager.vegetarian_type.first(where: {item in (item["name"] as! String) == type})!["level"] as! Int
            result = snapshot.value as! [[String: Any]]
            /* remove restaurants that do not provide any foods the user can consume */
            result.removeAll(where: {item in
                let level_item = DatabaseManager.vegetarian_type[item["type_min"] as! Int]["level"] as! Int
                return (level_item < level_user) || (level_item == level_user && (DatabaseManager.vegetarian_type[item["type_min"] as! Int]["name"] as! String) != type)
            })
            result.sort(by: {(a, b) in
                let level_a = DatabaseManager.vegetarian_type[a["type_max"] as! Int]["level"] as! Int
                let level_b = DatabaseManager.vegetarian_type[b["type_max"] as! Int]["level"] as! Int
                return level_a < level_b
            })
            if result.count > maxElement {result.removeLast(result.count - maxElement)}
        })
        
        return result
    }
    
    static func updateRating(id: Int, rating: Int) {
        var ratingAvg: Double = 0.0
        var ratingCount: Int = 0
        self.ref.child("restaurant/\(id)").getData(completion: { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                let value = snapshot.value as! [String: Any]
                ratingAvg = value["rating"] as? Double ?? 0.0
                ratingCount = value["rating_count"] as? Int ?? 0
                
                ratingCount += 1
                ratingAvg = (ratingAvg * (Double(ratingCount)-1) + Double(rating)) / Double(ratingCount)
                self.ref.child("restaurant/\(id)/rating").setValue(ratingAvg)
                self.ref.child("restaurant/\(id)/rating_count").setValue(ratingCount)
            }
            else {
                print("No data available")
            }
        })
    }
        
    func test() {
        var testName: String = ""
        var testNum: Int = 0
        DatabaseManager.ref.child("restaurant/0").getData(completion: { (error, snapshot) in
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                let value = snapshot.value as? NSDictionary
                testName = value?["name"] as? String ?? ""
                testNum = value?["num"] as? Int ?? 0
                print("Name: \(testName), Num: \(testNum)")
            }
            else {
                print("No data available")
            }
        })
    }
}
