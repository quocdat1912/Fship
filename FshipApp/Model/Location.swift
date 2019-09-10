//
//  Location.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/3/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import Foundation
import GooglePlaces
struct Location {
    static var shared = Location()
    var origin : GMSPlace!
    var destination : GMSPlace!
    
}
