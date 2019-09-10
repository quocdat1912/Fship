//
//  File.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/3/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import Foundation

struct User
{
  static  var sharetUser = User()
    var userFullName : String?
    var userEmail : String?
    var userNumber : String?
    var userAddress: String?
    var userAccount: String?
    var userPass: String?
    var userRole: Int?//customer = true, shipper = fall
    var userIDnumber: Int?
    var userSettingRad :Int?
}
