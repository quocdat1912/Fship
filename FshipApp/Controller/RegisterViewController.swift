//
//  RegisterViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/19/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegisterViewController: UIViewController {

    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var rePassText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    func setUI () {
        registerButton.layer.borderColor = UIColor.black.cgColor
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.cornerRadius = 2.0
        alreadyButton.layer.cornerRadius = 2.0
        alreadyButton.layer.borderWidth = 1.0
        alreadyButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        guard let fullname = fullnameTextField.text, fullname != "", let email = emailTextField.text, email != "", let phone = phoneTextField.text, phone != "", let username = userNameTextField.text, username != "", let pass = passTextField.text, pass != "", let repass = rePassText.text, repass != "" else {
            showAlert(titleAlert: "Không được để trống")
            return
        }
        guard passTextField.text == rePassText.text else {
            showAlert(titleAlert: "Mật khẩu không trùng")
            return
        }
        let paramater = [
            "full_name": fullname,
            "phone_number": phone,
            "pass_word": pass,
            "user_name": username,
            "email": email
        ]
        requestRegisterAPI(parameter: paramater) {
            self.showAlertDone(titleAlert: "Đăng ký thành công")
        }
    }
    func requestRegisterAPI (parameter : Dictionary<String, Any>, completed : @escaping DownloadComplete){
        
        
            let apiString = "http://\(ipAddress):9898/user/register"
        Alamofire.request(apiString, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
            let result = response.result
            let json = result.value
                guard json != nil else {
                    self.showAlert(titleAlert: "Tài khoản đã tồn tại")
                    return
                }
               completed()
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
            self.performSegue(withIdentifier: "backToLogin", sender: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LoginViewController
        vc.userNameTextField.text = userNameTextField.text
        vc.passWordTextField.text = passTextField.text
    }
}
