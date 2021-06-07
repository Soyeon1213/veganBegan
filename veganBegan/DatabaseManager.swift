//
//  DatabaseManager.swift
//  veganBegan
//
//  Created by RelMac User Exercise3 on 2021/05/16.
//  Copyright © 2021 Release. All rights reserved.
//

import Foundation
import Firebase

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

class DatabaseManager {
    static var ref: DatabaseReference! = Database.database(url: "https://veganbegan-6322d-default-rtdb.firebaseio.com/").reference()
    let veganTypeRange = ["비건", "락토", "오보", "락토/오보", "락토오보", "페스코", "일반식"]
 
    static func sortbyDistance(latitude: Double, longitude: Double) -> [[String: Any]] {
        var result = [[String: Any]]()
        let queryResult = DatabaseManager.ref.child("restaurant")
        queryResult.getData(completion: {(error, snapshot) in
            let value = snapshot.value as! [[String: Any]]
            result = value.sorted(by: {
                let x1 = $0["latitude"]! as! Double - latitude
                let x2 = $0["longitude"]! as! Double - longitude
                let y1 = $1["latitude"]! as! Double - latitude
                let y2 = $1["longitude"]! as! Double - longitude
                return x1*x1 + x2*x2 < y1*y1 + y2*y2
            })
        })
        return result.dropLast(result.count - 45)
    }
    
    static func sortbyFoodCategory(category: String) -> [[String: Any]] {
        var result = [[String: Any]]()
        let queryResult = DatabaseManager.ref.child("restaurant").queryEqual(toValue: category, childKey: "food")
        queryResult.getData(completion: {(error, snapshot) in
            result = snapshot.value as! [[String: Any]]
        })
        print(result.count)
        return result
    }
        /*
    static func updateRating(id: Int, rating: Int) {
        var ratingAvg: Double = restaurantSnapshot["\(id)/rating"] as? Double ?? 0.0
        var ratingCount: Int = restaurantSnapshot["\(id)/rating_count"] as? Int ?? 0
        ratingCount += 1
        ratingAvg = (ratingAvg * (Double(ratingCount)-1) + Double(rating)) / Double(ratingCount)
        ref.child("restaurant/\(id)/rating").setValue(rating)
        ref.child("restaurant/\(id)/rating_count").setValue(ratingCount)
    }*/
        
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
