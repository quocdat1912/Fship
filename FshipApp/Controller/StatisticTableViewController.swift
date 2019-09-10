//
//  StatisticTableViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 5/7/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class StatisticTableViewController: UITableViewController {

    var order : [Order] = []
    var textField : UITextField?
    let menu = ["Thống kê hôm nay", "Thống kê theo ngày", "Thống kê theo tháng"]
    var session : Int!
    var user : [String: Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        session = UserDefaults.standard.value(forKey: "UserSession") as? Int
        user = UserDefaults.standard.value(forKey: "UserLogined") as! [String: Any]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        order.removeAll()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let url = "http://\(ipAddress):9898/statistic/today"
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let result = dateFormatter.string(from: date)
            print(result)
            var para : [String : Any]
            if session == 0 {
                para = [
                    "shipperId" : user!["id"] as! Int ,
                    //"date" : result ] as [String : Any]
                    "date" : "\(result)" ]
            }
            else {
                para = [
                    "userId" : user!["id"] as! Int ,
                    "date" : result ] as [String : Any]
            }
            print(para)
            requestAPI(parameter: para, url: url) {
                self.performSegue(withIdentifier: "resultSegue", sender: nil)
            }
            break
        case 1:
            showDayAlert()
            break
        case 2:
            showMonthAlert()
            break
        default:
            break
        }
    }
    
    func showDayAlert (){
        let alert = UIAlertController(title: "Nhập ngày", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "(dd/MM/yyyy)"
            self.textField = textField
            
        }
        let okeAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            let dateformater = DateFormatter()
            dateformater.dateFormat = "dd/MM/yyyy"
            guard let resultCheck = dateformater.date(from: self.textField!.text!)  else {
                self.showAlert(titleAlert: "Nhập sai ngày")
                return
            }
            dateformater.dateFormat = "yyyy-MM-dd"
            let result = dateformater.string(from: resultCheck)
            var para : [String : Any]
            if self.session == 0 {
                para = [
                    "shipperId" : self.user!["id"] as! Int ,
                    //"date" : result ] as [String : Any]
                    "date" : "\(result)" ]
            }
            else {
                para = [
                    "userId" : self.user!["id"] as! Int ,
                    "date" : result ] as [String : Any]
            }
            let url = "http://\(ipAddress):9898/statistic/day"
            self.requestAPI(parameter: para, url: url, completed: {
                self.performSegue(withIdentifier: "resultSegue", sender: nil)
            })
            
        }
        let cancelAction = UIAlertAction(title: "Hủy", style: .cancel){
            (UIAlertAction) in
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
        alert.addAction(okeAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
        
    }
    func showMonthAlert (){
        let alert = UIAlertController(title: "Nhập tháng", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            self.textField = textField
            textField.placeholder = "1-12"
        }
        let okeAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            guard let resultCheck = Int(self.textField!.text!), resultCheck >= 1, resultCheck <= 12   else {
                self.showAlert(titleAlert: "Nhập sai tháng")
                return
            }
            var para : [String : Any]
            if self.session == 0 {
                para = [
                    "shipperId" : self.user!["id"] as! Int ,
                    //"date" : result ] as [String : Any]
                    "month" : "\(resultCheck)" ]
            }
            else {
                para = [
                    "userId" : self.user!["id"] as! Int ,
                    "month" : resultCheck ] as [String : Any]
            }
            let url = "http://\(ipAddress):9898/statistic/month"
            self.requestAPI(parameter: para, url: url, completed: {
                self.performSegue(withIdentifier: "resultSegue", sender: nil)
            })
            
        }
        let cancelAction = UIAlertAction(title: "Hủy", style: .cancel){
            UIAlertAction in
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }
        alert.addAction(okeAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
        
    }
    func showAlert (titleAlert: String){
        let alertController = UIAlertController(title: "Thông báo", message:
            titleAlert, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default){(UIAlertAction) in
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        })
        self.present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultStatisticTableViewController
        resultVC.orders = order
    }
    
    func requestAPI(parameter : Dictionary<String, Any>, url : String,completed : @escaping DownloadComplete ){
        //let url = "http://\(ipAddress):9898/order/add"
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default , headers: nil)
            .responseJSON { response in
                let result = response.result
                let json = result.value
                
                let jsondata = JSON(json)
                print(jsondata)
                for order in jsondata.arrayValue {
                    var x = Order()
                    x.orderAddressDes = order["orderAddressDes"].string
                    x.orderAddressSource = order["orderAddressSource"].string
                    x.orderCost = order["orderCost"].double
                    x.orderCreatedDate = order["orderCreatedDate"].string
                    x.orderId = order["orderId"].int
                    x.orderName = order["orderName"].string
                    x.orderNotes = order["orderNotes"].string
                    x.orderNumberReceiver = order["orderNumberReceiver"].string
                    x.orderNumberSender = order["orderNumberSender"].string
                    x.orderReceiverName = order["orderReceiverName"].string
                    x.orderSender = order["orderSender"].int
                    x.orderShipper = order["orderShipper"].int
                    x.orderShipperTakeName = order["orderShipperTakeName"].string
                    x.orderStatus = order["orderStatus"].int
                    x.orderValue = order["orderValue"].double
                    self.order.append(x)
                }
//                self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
                guard self.order.count != 0 else {
                    self.showAlert(titleAlert: "Không có hóa đơn nào")
                    return
                }
                completed()
                
        }
    }
}
