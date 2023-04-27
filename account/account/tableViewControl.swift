//
//  tableViewControl.swift
//  account
//
//  Created by eliana on 2022/11/10.
//

import Foundation
import UIKit
class moneyPerformanceTableViewControl:UITableViewController{
    
    //var moneyInfo ：MoneyInfo!不知道为什么这个写法不行
    var moneyInfo = MoneyInfo()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//传递数据给别的页面
        let thehomeViewControl = segue.destination as! ViewController
        thehomeViewControl.theMoneyInfo = moneyInfo
    }
    @IBAction func addmoney(_ sender: Any) {
        let alert = UIAlertController(title: "添加一条金钱记录",
                                      message: "请依次输入数额，备注",
                                      preferredStyle: .alert)
        
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder = "数额"}
        alert.addTextField{(textField: UITextField) -> Void in textField.placeholder = "备注"}
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            
            let theNum = alert.textFields?[0].text
            let theSummary = alert.textFields?[1].text

            
            let theMoney = self.moneyInfo.addMoney(num: Int(theNum!)!, summary: theSummary!)
            
            if let theIndex = self.moneyInfo.moneyCollection.firstIndex(of: theMoney) {
                
                let theIndexPath = IndexPath(row: theIndex, section: 0)
                
                self.tableView.insertRows(at: [theIndexPath], with: .automatic)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
       
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    //@IBAction func addMoney(_ sender: UIBarButtonItem) {
        
    //}
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let theMoney = moneyInfo.moneyCollection[indexPath.row]
            
            moneyInfo.deleteMoney(theMoney as! Money)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        moneyInfo.transferPosition(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        
    }
    override func viewDidLoad() {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        
        tableView.contentInset = insets
        
        tableView.scrollIndicatorInsets = insets
        
        //add refreshControl into view
        let theRefreshControl = UIRefreshControl()
        
        theRefreshControl.attributedTitle = NSAttributedString(string: "refreshing")
        
        theRefreshControl.addTarget(self, action: #selector(refreshing), for: UIControl.Event.valueChanged)
        
        refreshControl = theRefreshControl
        
    }
    @objc func refreshing() {
        
        if (refreshControl?.isRefreshing == true) {
            
            refreshControl?.attributedTitle = NSAttributedString(string: "loading...")
         
            refreshControl?.endRefreshing()
            
            refreshControl?.attributedTitle = NSAttributedString(string: "refreshing")
            
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moneyInfo.moneyCollection.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath) as! MoneyCell
        
        let money = moneyInfo.moneyCollection[indexPath.row]
        
        cell.nums.text = "\(money.value(forKey: "num") as! Int16)"
        cell.summarys.text = money.value(forKey: "summary") as? String

        print(money.value(forKey: "num") as! Int16)
        return cell
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMoneyDetail" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                
                let theMoney = moneyInfo.moneyCollection[row]
                
                //let theMoneyDetailViewController = segue.destination as! MoneyDetailViewController
                
                //theSMOneyDetailViewController.theMoney = theMoneyt as! Money
                
            }
        }
    }*/
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
  override func viewWillDisappear(_ animated: Bool) {
        moneyInfo.saveMoney()
    }
    
    
    @IBAction func back(_ sender: Any) {
        moneyInfo.saveMoney()
        //self.dismiss(animated: true,completion: nil)
        
    }
}

