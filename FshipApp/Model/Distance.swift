//
//  Distance.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/11/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import GooglePlaces

class Distance {
   
    var distance : Double!
    var distanceText : String!
    var duration : Int!
    var durationText : String!
    var  distanceCost : Double!
    
    
    func downloadDistance(completed: @escaping DownloadComplete) {
        let distance_API_URL = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=place_id:\(Location.shared.origin.placeID!)&destinations=place_id:\(Location.shared.destination.placeID!)&key=AIzaSyBHqnCt5RmcfZCQEFKEoJb_-DNUFLDbRqU"
        print(distance_API_URL)
        Alamofire.request(distance_API_URL).responseJSON { (response) in
        let result = response.result
        let json = JSON(result.value)
        print(json)
        self.distance = JSON(json)["rows"][0]["elements"][0]["distance"]["value"].double
        self.distanceText = JSON(json)["rows"][0]["elements"][0]["distance"]["text"].stringValue
        self.duration = json["rows"][0]["elements"][0]["duration"]["value"].int
        self.durationText =  json["rows"][0]["elements"][0]["duration"]["text"].stringValue
            print(self.distance)
            print(self.durationText)
            self.distanceCost = self.costCalculation(self.distance)
            print("\(self.distanceCost)")
            print(Location.shared.origin.name)
            print(Location.shared.destination.name)
            completed()
        }
        
    }
    func costCalculation(_ dist: Double!) -> Double {
        let km  = distance/1000
        switch km {
        case 0...5 :
            let cost = 14000 + 2000 * km
            return cost - (cost.truncatingRemainder(dividingBy: 1000))
        case 5.1...10:
            let cost = 14000 + 3000 * km
            return cost - (cost.truncatingRemainder(dividingBy: 1000))
        case 11.1...15:
            let cost = 14000 + 4000 * km
            return cost - (cost.truncatingRemainder(dividingBy: 1000))
        case 16.1...20:
            let cost = 14000 + 4500 * km
            return cost - (cost.truncatingRemainder(dividingBy: 1000))
        case let x where x > 20 :
            let cost = 5 * km
            return cost - (cost.truncatingRemainder(dividingBy: 1000))
            
        default:
            return 0
        
        }
    }
    
}
