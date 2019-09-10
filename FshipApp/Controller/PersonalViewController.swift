//
//  PersonalViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/15/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import Alamofire
class PersonalViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTexField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var radSearchTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUI()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let name = nameTextField.text, name != "", let phone = phoneTextField.text, phone != "", let email = emailTextField.text, email != "", let address = addressTexField.text, address != "", let newPass = newPassTextField.text, newPass != ""
            else{
                showAlert(titleAlert: "Chưa nhập đủ thông tin")
                return
            }
        let user = UserDefaults.standard.value(forKey: "UserLogined") as! [String:Any]
            let parameter = ["username":"\(user["account"] as! String)" ,
                         "name": "\(name)" ,
                         "email": "\(email)",
                         "address": "\(address)" ,
                         "phone": "\(phone)",
                         "pass": "\(newPass)"]
        requestSaveInforApi(parameter: parameter) {
            let userDict = ["id": user["id"] as! Int,"pass":newPass, "number":phone,"account": user["account"] as! String, "fullname":name, "role":user["role"] as! Int, "address": address, "email": email] as [String : Any]
            UserDefaults.standard.removeObject(forKey: "UserLogined")
            UserDefaults.standard.set(userDict, forKey: "UserLogined")
            self.showAlertDone(titleAlert: "Cập nhập thành công")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func setUI (){
        let user = UserDefaults.standard.value(forKey: "UserLogined") as! [String:Any]
        nameTextField.text = user["fullname"] as? String
        phoneTextField.text = user["number"] as? String
        emailTextField.text = user["email"] as? String
        addressTexField.text = user["address"] as? String
        newPassTextField.text = user["pass"] as? String
//        nameTextField.text = User.sharetUser.userFullName
//        phoneTextField.text = User.sharetUser.userNumber
//        emailTextField.text = User.sharetUser.userEmail
//        addressTexField.text = User.sharetUser.userAddress
//        newPassTextField.text = User.sharetUser.userPass
        //radSearchTextField.text = String?(User.sharetUser.userSettingRad)
    }
    func requestSaveInforApi(parameter : Dictionary<String, Any>,completed : @escaping DownloadComplete ){
        let url = "http://\(ipAddress):9898/user/update"
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
}
