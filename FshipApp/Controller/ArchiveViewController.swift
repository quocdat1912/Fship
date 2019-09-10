//
//  ArchiveViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/10/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ArchiveViewController: UITableViewController {

    var waitOrder = [Order]()
    var didOrder = [Order]()
    var doneOrder = [Order]()
    var order : [[Order]] = []
    var jsondata : Any?
    let tittleForSession = ["Order chưa được nhận","Order đã được nhận","Order đã hoàn thành"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.order = [self.waitOrder, self.didOrder,self.didOrder]
        //print(self.waitOrder[0].orderName)
        print(self.order[0].count)
        print(self.order[1].count)
        print(self.order[2].count)
    }
    override func viewWillAppear(_ animated: Bool) {
        let user = UserDefaults.standard.value(forKey: "UserLogined") as! [String: Any]
        let para = [
            "id": user["id"] as! Int
        ]
        requestSaveOrderApi(parameter: para) {
            self.order = [self.waitOrder, self.didOrder,self.doneOrder]
            self.tableView.reloadData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        waitOrder.removeAll()
        didOrder.removeAll()
        doneOrder.removeAll()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
       return tittleForSession.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tittleForSession[section]

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return order[section].count
        
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        switch indexPath.section {
        case 0:
            cell.nameOrderLabel.text = waitOrder[indexPath.row].orderName
            cell.addressOrderLabel.text = waitOrder[indexPath.row].orderAddressDes
            cell.dateOrderLabel.text = waitOrder[indexPath.row].orderCreatedDate
            break
        case 1:
            cell.nameOrderLabel.text = didOrder[indexPath.row].orderName
            cell.addressOrderLabel.text = didOrder[indexPath.row].orderAddressDes
            cell.dateOrderLabel.text = didOrder[indexPath.row].orderCreatedDate
            break
        case 2:
            cell.nameOrderLabel.text = doneOrder[indexPath.row].orderName
            cell.addressOrderLabel.text = doneOrder[indexPath.row].orderAddressDes
            cell.dateOrderLabel.text = doneOrder[indexPath.row].orderCreatedDate
            break
        default:
            break
        }
        return cell
    }
    func requestSaveOrderApi(parameter : Dictionary<String, Any>,completed : @escaping DownloadComplete ){
        let session = UserDefaults.standard.value(forKey: "UserSession") as! Int
        var url = ""
        if session == 1 {
            url = "http://\(ipAddress):9898/order/list"}
        else {
            url = "http://\(ipAddress):9898/order/shipperlist"
        }
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default , headers: nil)
            .responseJSON { response in
                let result = response.result
                let json = result.value
                
                guard json != nil else { self.showAlert(titleAlert: "Loi roi")
                    return}
                let jsonData = JSON(json)
                for order  in jsonData["waitOrders"].arrayValue {
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
                    self.waitOrder.append(x)
                }
                for order  in jsonData["didOrders"].arrayValue {
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
                    self.didOrder.append(x)
                }

                for order  in jsonData["doneOrders"].arrayValue {
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
                    self.doneOrder.append(x)
                }
                completed()
        }
                
    }
    func showAlert (titleAlert: String){
        let alertController = UIAlertController(title: "Thông báo", message:
            titleAlert, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailOrderViewController
        if let index = tableView.indexPathForSelectedRow {
            vc.order = order[index.section][index.row]
        }
    }
}
    
 


