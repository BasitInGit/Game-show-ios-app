//
//  ViewController.swift
//  TheChase2
//
//  Created by Adedeji, Basit on 06/11/2024.
//

import UIKit

class ViewController: UIViewController {
    var label_num = 0
    var label_num2 = 0
    let highPrice = Int.random(in: 15000...40000)
    let midPrice = Int.random(in: 3000...9000)
    let lowPrice = Int.random(in: 500...1200)
    var selectedPrice = 0
    var chaser_num = 0
    var chaser_num2 = 0
    var timerCount = 1
    var timer: Timer?
    var isFirstLoad = true
    var segFromBtn = false
    var currentscore = 0
    var newScore = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestions" {
            let  QuestionsViewController = segue.destination as! QuestionsViewController
            QuestionsViewController.label_num = label_num
            QuestionsViewController.label_num2 = label_num2
            QuestionsViewController.chaser_num = chaser_num
            QuestionsViewController.chaser_num2 = chaser_num2
            QuestionsViewController.selectedPrice = selectedPrice
            QuestionsViewController.isFirstLoad = isFirstLoad
        }
        if segue.identifier == "toStart" {
            let StartViewcontroller = segue.destination as! StartViewController
            StartViewcontroller.currentscore = currentscore
            StartViewcontroller.newScore = newScore
        }
    }
    // Function to update the background color change  for the chaser after each question
    func chaser(_ c_num: Int){
        if c_num>0 {
            if let c_view = view.viewWithTag(c_num) {
                c_view.backgroundColor = UIColor.systemRed
            } else {}
        }
    }
    // Function that sets the price and updates the background of view 2 to 4
    func view2to4 (_ num:Int,_ price:Int){
        
        let label_1  = self.view.viewWithTag(num+7) as? UIButton
        label_1?.setTitle(">    \(price)    <", for: .normal)
        let view_1 = self.view.viewWithTag(num)
        view_1!.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        
        selectlabel.isHidden = true
        label2.isUserInteractionEnabled = false
        label3.isUserInteractionEnabled = false
        label4.isUserInteractionEnabled = false
        // If the function was called after a button click, transition to the QuestionsViewController
        if segFromBtn == true{
            isFirstLoad = false
            performSegue(withIdentifier: "toQuestions", sender: self)
        }
    }
    // Function to handle views when the label number is in the range 5 and above(non button views
    func view5plus(_ v1: Int){
        let label_1  = self.view.viewWithTag(v1+7) as? UILabel
        label_1!.text = ">    \(selectedPrice)    <"
        let view_1 = self.view.viewWithTag(v1)
        view_1!.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        
        selectlabel.isHidden = true
        label2.isUserInteractionEnabled = false
        label3.isUserInteractionEnabled = false
        label4.isUserInteractionEnabled = false
    }
    // Function called when an answer button is clicked to set the price and label number
    func BtnCall (_ btnLabel: Int,_ price: Int) {
        selectedPrice = price
        label_num = btnLabel
        label_num2 = btnLabel
        segFromBtn = true
        view2to4(btnLabel, price)
    }
  
    @IBAction func hardMode(_ sender: Any) {
        BtnCall(2, highPrice)
    }
    
    @IBAction func midMode(_ sender: Any?) {
        BtnCall(3,midPrice)
    }
        
    @IBAction func easyMode(_ sender: Any) {
        BtnCall(4,lowPrice)
    }
    
    // Function to load the previous and current state of the view, called by view will appear and once again by view did appear,
    func load(){
        if [2,3,4].contains(label_num2) {
            view2to4(label_num2,selectedPrice)
        }
        else if [5,6,7].contains(label_num2) {
            view5plus(label_num2)}
    }
    // Timer function that handles game progress and direction of view change
    @objc  func timerFired2() {
        timerCount -= 1
        if timerCount == 0{
            timer?.invalidate()
            timer = nil
            
            if [2, 3, 4, 5, 6, 7].contains(label_num) && chaser_num != label_num{
                performSegue(withIdentifier: "toQuestions", sender: self)
            }
            
            else if chaser_num == label_num{
                selectlabel.isHidden = false
                selectlabel.text = "Game Over"
                newScore = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.performSegue(withIdentifier: "toStart", sender: self)
                }
            }
            else if label_num == 8{
                selectlabel.isHidden = false
                selectlabel.text = "Congratulations \n You won \(selectedPrice)"
                
                currentscore = selectedPrice
                newScore = selectedPrice
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    self.performSegue(withIdentifier: "toStart", sender: self)
                }}}
    }
    //timer function called by view did appear to allow time for view will appear actions to display and calls functions for view did appeaar set up
    @objc  func timerFired() {
        timerCount -= 1
        if timerCount == 0{
            timer?.invalidate()
            timer = nil
            // Clear the label text from previous position on ladder
            if label_num2 < 5 {
                let label_1  = self.view.viewWithTag(label_num2+7) as? UIButton
                label_1!.setTitle("", for: .normal)
            }
            else{
                let label_1  = self.view.viewWithTag(label_num2+7) as? UILabel
                label_1!.text = ""
            }
            //clear background colour osf chaser's previous position on the ladder
            if chaser_num2 != 0 {
                let c_view = view.viewWithTag(chaser_num2)
                c_view!.backgroundColor = UIColor.systemTeal
            }
            
            label_num2 = label_num
            load()
            chaser(chaser_num)
            chaser_num2 = chaser_num
            // Start a secondary timer to allow view did appear set ups to display before transition to net view
            timerCount = 1
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired2), userInfo: nil, repeats: true)
        }
    }

    
    
    
    @IBOutlet weak var selectlabel: UILabel!
    // Called when the view is about to appear on the screen from the second load onwards
    override func viewDidAppear(_ animated: Bool) {
         if !isFirstLoad {
             segFromBtn = false
             timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
         }
         
     }
    // Called when the view is about to appear, just before it's fully visible from the second load onwards
    override func viewWillAppear(_ animated: Bool) {
         if !isFirstLoad {
             // Reset the flag that tracks if the segue was triggered by a button
             segFromBtn = false
             load()
             chaser(chaser_num2)
         }
     }
    // If it's the first load, the prices for each label are set and interactive labels are enabled.
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstLoad {
            
            label2.setTitle( ">    \(highPrice)    <", for: .normal)
            label3.setTitle( ">    \(midPrice)     <", for: .normal)
            label4.setTitle( ">    \(lowPrice)     <", for: .normal)
            
            label2.isUserInteractionEnabled = true
            label3.isUserInteractionEnabled = true
            label4.isUserInteractionEnabled = true
            selectlabel.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var label4: UIButton!
    @IBOutlet weak var label3: UIButton!
    @IBOutlet weak var label2: UIButton!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view3: UIView!
}

