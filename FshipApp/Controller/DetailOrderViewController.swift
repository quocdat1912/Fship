//
//  DetailOrderViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/15/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class DetailOrderViewController: UIViewController {
    @IBOutlet weak var orderNameTextField : UITextField!
    @IBOutlet weak var orderNamePersonTextField : UITextField!
    @IBOutlet var orderPhoneReceiverField : UITextField!
    @IBOutlet weak var orderPhoneSenderField: UITextField!
    @IBOutlet var orderValueTextField : UITextField!
    @IBOutlet var orderAddressTextField : UITextField!
    @IBOutlet var orderNoteTextView : UITextView!
    @IBOutlet var moneyShipLable: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    var order : Order?
    var para : Dictionary<String, Int>?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        para = ["orderId": order!.orderId!]
    }
    @IBAction func canceTap(_ sender: Any) {
        let url = "http://\(ipAddress):9898/order/cancel"
        requestApi(parameter: para!, url: url) {
            self.showAlertDone(titleAlert: "Hủy đơn thành công")
        }
    }
    @IBAction func doneTap(_ sender: Any) {
        let url = "http://\(ipAddress):9898/order/done"
        requestApi(parameter: para!, url: url) {
            self.showAlertDone(titleAlert: "Đã hoàn thành")
        }
    }
    @IBAction func confirmTap(_ sender: Any) {
        let user = UserDefaults.standard.value(forKey: "UserLogined") as! [String: Any]
        let url = "http://\(ipAddress):9898/order/confirm"
        let x = ["orderId": order!.orderId!,
                "shipperId": user["id"] as! Int
                ]
        requestApi(parameter: x, url: url) {
            self.showAlertDone(titleAlert: "Nhận đơn thành công")
        }
    }
    
    func setUI() {
        orderNameTextField.isEnabled = false
        orderNamePersonTextField.isEnabled = false
        orderPhoneReceiverField.isEnabled = false
        orderValueTextField.isEnabled = false
        orderAddressTextField.isEnabled = false
        orderNoteTextView.isEditable = false
        orderPhoneSenderField.isEnabled = false
        orderNoteTextView.isScrollEnabled = false
        orderNoteTextView.layer.borderColor = UIColor.black.cgColor
        orderNoteTextView.layer.borderWidth = 2.0
        orderNoteTextView.layer.cornerRadius = 5
        
        orderNameTextField.text = order?.orderName
        orderNamePersonTextField.text = order?.orderReceiverName
        orderPhoneReceiverField.text = order?.orderNumberReceiver
        orderPhoneSenderField.text = order?.orderNumberSender
        orderValueTextField.text = "\(order!.orderValue!)"
        orderAddressTextField.text = order?.orderAddressDes
        orderNoteTextView.text = order?.orderNotes
        moneyShipLable.text = "\(order!.orderCost!) VND"
        let session = UserDefaults.standard.value(forKey: "UserSession") as! Int
        if session == 1{
            if order?.orderStatus == 0 {
                doneButton.isHidden = true
                confirmButton.isHidden = true
            }
            else{
                cancelButton.isHidden = true
                doneButton.isHidden = true
                confirmButton.isHidden = true
            }
        }
        else{
            if order?.orderStatus == 0 {
                doneButton.isHidden = true
                cancelButton.isHidden = true
            }
            else{
                if order?.orderStatus == 1{
                    cancelButton.isHidden = true
                    confirmButton.isHidden = true
                }
                else{
                    doneButton.isHidden = true
                    cancelButton.isHidden = true
                    confirmButton.isHidden = true
                }
            }
        }
    }
    func requestApi(parameter : Dictionary<String, Any>, url : String, completed : @escaping DownloadComplete ){
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
        completed()
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
    

}
