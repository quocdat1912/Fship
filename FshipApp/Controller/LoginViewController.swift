//
//  LoginViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/10/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        userNameTextField.delegate = self
//        passWordTextField.delegate = self 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let user = UserDefaults.standard.value(forKey: "UserLogined") else {return}
        print(user)
        performSegue(withIdentifier: "loginSuccess", sender: nil)
    }
    @IBAction func loginTapped(_ sender: Any) {
        guard let username = userNameTextField.text , username != "" , let password = passWordTextField.text, password != "" else{
            showAlert(titleAlert: "Chưa nhập username hoặc password")
            return
        }
        let parameter
            =   [
                "username":"\(username)",
                "password":"\(password)"
                ]
        requestLoginApi(parameter: parameter) {
            self.performSegue(withIdentifier: "loginSuccess", sender: nil)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
    }

    func showAlert (titleAlert: String){
        let alertController = UIAlertController(title: "Thông báo", message:
            titleAlert, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    func requestLoginApi(parameter : Dictionary<String, Any>,completed : @escaping DownloadComplete ){
        let login_url_request = "http://\(ipAddress):9898/user/login"
        Alamofire.request(login_url_request, method: .post, parameters: parameter, encoding: JSONEncoding.default) .responseJSON(completionHandler: { (response) in
            let resuilt = response.result
            let json = resuilt.value
            guard json != nil else {
                self.showAlert(titleAlert: "Sai ten va mat khau")
                return
            }
            let jsondata = JSON(json)
            var user = User()
            user.userIDnumber = jsondata["userId"].int
            user.userPass = jsondata["userPass"].string
            user.userNumber = jsondata["userHomephone"].string
            user.userAccount = jsondata["userName"].string
            user.userFullName = jsondata["userFullname"].string
            user.userRole = jsondata["userRoles"].int
            user.userEmail = jsondata["userEmail"].string
            user.userAddress = jsondata["userAddress"].string
            User.sharetUser = user
            let userDict = ["id":user.userIDnumber!,"pass":user.userPass!, "number":user.userNumber!,"account":user.userAccount!, "fullname":user.userFullName!, "role":user.userRole!, "email":user.userEmail!, "address" : user.userAddress ?? ""] as [String : Any]
            print(userDict)
            UserDefaults.standard.setValue(user.userRole, forKey: "UserSession")
            UserDefaults.standard.setValue(userDict, forKeyPath: "UserLogined")
            completed()
        })
    }
}
