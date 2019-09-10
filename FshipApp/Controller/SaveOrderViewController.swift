//
//  SaveOrderViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/11/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON
class SaveOrderViewController: UIViewController {
    
    //var orderProcessing = Order()
    var destinationPlace : GMSPlace!
    var sourcePlace : GMSPlace!
    var distance = Distance()
    @IBOutlet weak var orderNameTextField : UITextField!
    @IBOutlet weak var orderNamePersonTextField : UITextField!
    @IBOutlet var orderPhoneField : UITextField!
    @IBOutlet var orderValueTextField : UITextField!
    @IBOutlet var orderAddressTextField : UITextField!
    @IBOutlet var orderNoteTextView : UITextView!
    @IBOutlet var moneyShipLable: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        distance.downloadDistance {
            self.moneyShipLable.text = "Chi phí ship: \(self.distance.distanceCost!) VND"
        }
        orderNoteTextView.isScrollEnabled = false
        orderNoteTextView.layer.borderColor = UIColor.black.cgColor
        orderNoteTextView.layer.borderWidth = 2.0
        orderNoteTextView.layer.cornerRadius = 5
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.borderColor = UIColor.black.cgColor
        orderAddressTextField.isEnabled = false
        orderAddressTextField.text = destinationPlace.name
//        guard  let distanceCost = cost else {
//            return
//        }
        //print("T dc in trc")
        //moneyShipLable.text = "Phí ship : \(distance.distanceCost) VND"
        
    }
    func showAlert (titleAlert: String){
        let alertController = UIAlertController(title: "Thông báo", message:
            titleAlert, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    func showAlertDone (titleAlert:String){
        let alertController = UIAlertController(title: "Thông báo", message:
            titleAlert, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default){(action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func confirmButton(_ sender: Any) {
        guard let name = orderNameTextField.text, name != "" else { showAlert(titleAlert: "Chưa nhập tên sản phẩm")
            return  }
        guard let namePerson = orderNamePersonTextField.text, namePerson != "" else{
            showAlert(titleAlert: "Chưa nhập tên người nhận")
            return
        }
        guard let phone = orderPhoneField.text, phone != "" , let check = Int(orderPhoneField.text!) else {
            showAlert(titleAlert: "Số điện thoại chưa đúng")
            return
        }
       guard let value = Double(orderValueTextField.text!) else {
            showAlert(titleAlert: "Giá trị sản phẩm chưa đúng")
            return
        }
        guard let address = orderAddressTextField.text, address != "" else {
            showAlert(titleAlert: "Chưa nhập địa chỉ nhận")
            return
        }
        let user = UserDefaults.standard.value(forKey: "UserLogined") as! [String: Any]
        let parameter = [
            "order_name": "\(name)",
            "order_sender": user["id"] as! Int ,
            "order_address_des":"\(address)",
            "order_address_sou":"\(sourcePlace.name!)",
            "order_value":Int(value),
            "order_cost": distance.distanceCost!,
            "receiver_name":"\(namePerson)",
            "receiver_phone":"\(phone)",
            "note":"\(orderNoteTextView.text!)",
            "sender_phone": user["number"] as! String
            ] as [String : Any]
        
        //navigationController?.popViewController(animated: true)
        requestSaveOrderApi(parameter: parameter) {
            self.showAlertDone(titleAlert: "Đơn đã hoàn thành")
        }
        
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func requestSaveOrderApi(parameter : Dictionary<String, Any>,completed : @escaping DownloadComplete ){
        let url = "http://\(ipAddress):9898/order/add"
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default , headers: nil)
            .responseJSON { response in
                let result = response.result
                let json = result.value
                guard json != nil else{
                    self.showAlert(titleAlert: "Không thành công")
                    return
                }
                completed()
                
        }
    }
}
