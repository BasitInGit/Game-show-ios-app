//
//  StartViewController.swift
//  TheChase2
//
//  Created by Adedeji, Basit on 14/11/2024.
//

import UIKit

class StartViewController: UIViewController {
    var currentscore = 0
    var newScore = 0
    var highScore = ""

    @IBOutlet weak var HSlabel: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var current: UILabel!
    
    // Action triggered when the player starts a new game
    @IBAction func newGame(_ sender: Any) {
        performSegue(withIdentifier: "startToView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HSlabel.isHidden = true
        score.isHidden = true
        // Retrieve the previous score stored in UserDefaults (if it exists)
        if let scoreSoFar = UserDefaults.standard.string(forKey: "score"){
            let retrieved = Int(scoreSoFar) ?? 0
            currentscore = currentscore + retrieved
        }
        current.text = "\(currentscore)"                   // Display the current score in the 'current' label
        
        // Checks if the round was won or lost
        if newScore != 0{
            UserDefaults.standard.set("\(currentscore)", forKey: "score")}
        else if newScore == 0{
            HSlabel.isHidden = false
            score.isHidden = false
            highScore = UserDefaults.standard.string(forKey: "num") ?? "0"
            let number = Int(highScore) ?? 0
                if currentscore > number{        // Compare the current score with the stored high score
                    score.text = "\(currentscore)"
                    UserDefaults.standard.set("\(currentscore)", forKey: "num")
                }
                else{
                    score.text = "\(number)"}
            UserDefaults.standard.set("0", forKey: "score")}
        
        
       
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
