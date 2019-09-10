//
//  Order.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/3/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import Foundation

struct Order : Codable {
    var orderId : Int?
    var orderName : String?
    var orderShipper : Int?
    var orderValue: Double?
    var orderCost: Double?
    var orderStatus: Int?
    var orderAddressDes: String?
    var orderReceiverName: String?
    var orderNumberReceiver: String?
    var orderAddressSource: String?
    //var orderLocation: Location?
    //var orderSenderName : String?
    var orderShipperTakeName: String?
    var orderNotes : String?
    var orderSender: Int?
    var orderNumberSender: String?
    var orderCreatedDate : String?
    
    init() {
        
    }
}
