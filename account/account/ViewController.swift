//
//  ViewController.swift
//  account
//
//  Created by eliana on 2022/11/10.
//

import UIKit

class ViewController: UIViewController {
    var theMoneyInfo = MoneyInfo()
    var day = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var all: UILabel!

    @IBOutlet weak var refresh: UIButton!

    @IBOutlet weak var card: UILabel!
    
    
    @IBOutlet weak var otherMoney: UILabel!
    
    @IBOutlet weak var days: UILabel!
    
    @IBOutlet weak var adddays: UIButton!
    var addCard = 0
    var add = 0
    
    @IBOutlet weak var perdayCard: UILabel!
    
    @IBOutlet weak var perday: UILabel!
    
    @IBAction func add(_ sender: Any) {
        var caddCard = 0
        var cadd = 0
        for i in theMoneyInfo.moneyCollection{
            let temp = i as! Money
            cadd = cadd + Int(temp.num)
            if(temp.summary == "card"){
                caddCard = caddCard + Int(temp.num)
            }
        }
        addCard = caddCard
        add = cadd
        all.text = String(add)
        card.text = String(addCard)
        otherMoney.text = String(add-addCard)
        perdayCard.text = String(addCard/day)
        perday.text = String(add/day)
    }
    
    @IBAction func addDay(_ sender: Any) {
        day = day + 1
        days.text = String(day)
        perdayCard.text = String(addCard/day)
        perday.text = String(add/day)
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let des = segue.destination as! analyseViewControl
        des.theday = day
        des.cardAll = addCard
        des.all = add
    }*/
    
    /*@IBAction func confirm(_ sender: Any) {
        let info = ["card":self.perdayCard.text!,"all":self.perday.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"forAnalyse"), object: nil,userInfo: info)
    }*/
}

