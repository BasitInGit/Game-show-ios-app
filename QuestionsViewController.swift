//
//  QuestionsViewController.swift
//  TheChase2
//
//  Created by Adedeji, Basit on 06/11/2024.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    @IBOutlet weak var questionlabel: UILabel!
    @IBOutlet weak var ans1label: UIButton!
    @IBOutlet weak var ans2label: UIButton!
    @IBOutlet weak var ans3label: UIButton!
    @IBOutlet weak var clockDisplay: UILabel!
    @IBOutlet weak var clabel1: UILabel!
    
    @IBOutlet weak var clabel3: UILabel!
    @IBOutlet weak var clabel2: UILabel!
    var timer: Timer?
    var timer2: Timer?
    var timerCount = 15
    var timerCount2 = 2
    var correct_ans = 0
    var label_num = 0
    var label_num2 = 0
    var answers_array: [String] = []
    var no_ans_selected = 0
    var chaser_num = 0
    var chaser_num2 = 0
    var selectedPrice = 0
    var isFirstLoad = true
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toView" {
            let ViewController = segue.destination as!
            ViewController
            ViewController.label_num = label_num
            ViewController.label_num2 = label_num2
            ViewController.chaser_num = chaser_num
            ViewController.chaser_num2 = chaser_num2
            ViewController.selectedPrice = selectedPrice
            ViewController.isFirstLoad = isFirstLoad
        }
    }
    // Struct to decode the quiz data from a JSON file
    struct QuizQuestionData: Codable {
        let category : String
        var questions: [QuestionItems]
    }

    struct QuestionItems: Codable {
        let question_text : String
        let answers : [String]
        let correct : Int
    }

    func getJSONQuestionData() -> QuizQuestionData? {
        let bundleFolderURL = Bundle.main.url(forResource: "chase_questions_v2", withExtension: "json")!
        do {
            let retrievedData = try Data(contentsOf: bundleFolderURL)
            do {
                let theQuizData = try JSONDecoder().decode(QuizQuestionData.self, from: retrievedData)
                return theQuizData
            } catch {
                print("couldn't decode file contents"); return nil
            }
        } catch {
            print("couldn't retrieve file contents"); return nil
        }
    }
    // Function that handles the chaser answer selection and how it gets displayed in the UI
    func chaser() {
        let random_num2 = Int.random(in: 0...4)
        if random_num2 < 4 {
            if correct_ans == 1 {
                border_color(1, "Blue")
            }
            else if correct_ans == 2{
                border_color(2, "Blue")
            }
            else if correct_ans == 3{ border_color(3, "Blue")}
            chaser_num = chaser_num + 1
        }
        else {
            if correct_ans == 1 {
                border_color(3, "Blue")
            }
            else if correct_ans == 2{
                border_color(1, "Blue")}
            else if correct_ans == 3{ border_color(2, "Blue")}
        }
    }
    // Helper function to update the border color of option buttons, called for chaser and  correct answer
    func border_color(_ ans: Int,_ color: String){
        if color == "Blue" {
            let chaser_label = self.view.viewWithTag(ans+3) as? UILabel
            let ansLabel = self.view.viewWithTag(ans) as? UIButton
            ansLabel!.layer.borderColor =  UIColor.systemBlue.cgColor
            ansLabel!.layer.borderWidth = 4
            chaser_label!.text = "chaser"
        }
        else if color == "Green" {
            let ansLabel = self.view.viewWithTag(ans) as? UIButton
            ansLabel!.layer.borderColor =  UIColor.systemGreen.cgColor
            ansLabel!.layer.borderWidth = 4
        }
    }
    func Btn_action(_ Btn_num: Int){
        // Disable user interaction for all answer buttons once an answer is selected
        ans1label.isUserInteractionEnabled = false
        ans2label.isUserInteractionEnabled = false
        ans3label.isUserInteractionEnabled = false
        
        timer?.invalidate()
        timer = nil
        // Change the background color of the selected answer button to indicate selection
        let ansLabel = self.view.viewWithTag(Btn_num) as? UIButton
        ansLabel!.backgroundColor = UIColor.systemPink
        
        if Btn_num == correct_ans{
            label_num+=1
        }
        timerCount = 1
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    // Actions for the answer buttons
    @IBAction func ans1Btn(_ sender: Any) {
        Btn_action(1)
    }
    
    @IBAction func ans2Btn(_ sender: Any) {
        Btn_action(2)
    }
    
    @IBAction func ans3Btn(_ sender: Any) {
        Btn_action(3)
    }
    
    // Timer function that handles the secondary timer after an answer is selected
    @objc  func timerFired2(){
        timerCount2 -= 1
        if timerCount2 == 0{
            timer2?.invalidate()
            timer2 = nil
            
            if correct_ans == 1 {
                border_color(1, "Green")
            }
            else if correct_ans == 2{
                border_color(2, "Green")
            }
            else if correct_ans == 3{
                border_color(3, "Green")}
            // After a short delay, perform the segue to the next screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.performSegue(withIdentifier: "toView", sender: self)
            }
        }
    }
    // Main countdown timer function
    @objc  func timerFired() {
        timerCount -= 1
        clockDisplay.text = String(format: "%02d", timerCount)
        if timerCount == 0{
            timer?.invalidate()
            timer = nil
            // Trigger the "chaser" function when time runs out
            chaser()
            
            timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired2), userInfo: nil, repeats: true)
         }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ans1label.isUserInteractionEnabled = true
        ans2label.isUserInteractionEnabled = true
        ans3label.isUserInteractionEnabled = true
        
        // Initialize the clock display
        clockDisplay.text = "15"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        // handles question selection
        let  theQuizQuestions = getJSONQuestionData()
        if theQuizQuestions != nil {
            if let questions = theQuizQuestions?.questions {
                let random_num = Int.random(in: 0..<questions.count)
                let aQuestion = questions[random_num]
                questionlabel.text = aQuestion.question_text
                answers_array = aQuestion.answers
                ans1label.setTitle(answers_array[0], for: .normal)
                ans2label.setTitle( answers_array[1], for: .normal)
                ans3label.setTitle( answers_array[2], for: .normal)
                correct_ans = aQuestion.correct
                
            }
        }
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
