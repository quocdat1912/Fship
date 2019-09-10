//
//  TableViewController.swift
//  FshipApp
//
//  Created by Nguyễn Đạt on 4/8/19.
//  Copyright © 2019 Nguyễn Đạt. All rights reserved.
//

import UIKit
struct Menu {
    var tittleString: String
    var imageString : String
    init(_ tittle: String,_ image: String ) {
        tittleString = tittle
        imageString = image
    }
}
var myIndexpath : Int?
var dataMenu : [Menu] = [Menu("Thông tin cá nhân","iconPersonal"),Menu("Thống kê","iconStatistic"),Menu("Đánh giá","iconPrize"),Menu("Đăng xuất","iconLogout")]
class OptionViewController: UITableViewController{
   
    //@IBOutlet weak var tableViewMenu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewMenu.dataSource = self
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
       return 1
   }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataMenu.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = dataMenu[indexPath.row].tittleString
        cell.imageView?.image = UIImage.init(named: dataMenu[indexPath.row].imageString )

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        myIndexpath = indexPath.row
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "PersonalSegue", sender: self)
            break
        case 1:
            performSegue(withIdentifier: "StatisticSegue", sender: self)
            break
        case 2:
            performSegue(withIdentifier: "PrizeSegue", sender: self)
            break
        case 3:
            
            performSegue(withIdentifier: "unwindToLogin", sender: self)
            break
        default:
            break
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "unwindToLogin":
            //print(UserDefaults.standard.value(forKey: "UserLogined"))
            UserDefaults.standard.removeObject(forKey: "UserLogined")
            UserDefaults.standard.removeObject(forKey: "UserSession")
            break
        default:
            break
        }
    }
    
    

   
    

    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
