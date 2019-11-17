//
//  GameViewController.swift
//  scrambleApp
//
//  Created by Os on 2019-03-05.
//  Copyright © 2019 Os. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
var topScores = UserDefaults.standard

var score = 0

class GameViewController: UIViewController {
    
    @IBOutlet weak var CategoryLabel: UILabel!
    
    @IBOutlet var categoryButton: [UIButton]!
    
   
    @IBOutlet var letterButton: [UIButton]!
    
    @IBOutlet var currentWordLetters: [UIButton]!
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var giveUpButton: UIButton!  //Creating outlets for buttons
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreStaticTextLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var whichButtonsCanTheyTypeIn: [UIButton] = []
    
    let categoriesString = ["Cold Places", "Winter Sports", "Clothing" , "Random Winter Words"]
   
    var currentActiveGuessButton: [UIButton] = []
    //var score = 0
    
    var username: String? = nil
    
    //var allStoredScores = UserDefaults.standard
    
    class func scrambleThisWord(_ inputtedString: inout String) -> String {
        var temporaryCharacterArray: [Character] = []
        var shuffledCharacterArray: [Character] = []
        var randomNumber:Int
        temporaryCharacterArray.append(contentsOf: inputtedString)
        
        for _ in 1...temporaryCharacterArray.count{ //scrambles a string
            randomNumber = Int.random(in: 0..<temporaryCharacterArray.count)
            shuffledCharacterArray.append(temporaryCharacterArray[randomNumber])
            temporaryCharacterArray.remove(at: randomNumber)
        }
        
        inputtedString = String(shuffledCharacterArray)
        return inputtedString
    }
    
    
    class func shuffleTheseArrays (questionArray: inout [String], hintArray: inout [String]) -> ([String],[String],[String]) {
        var answersArray:[String] = []
        var randomNumber = 0    //Shuffles an array
        var shuffledArray: [String] = []
        var shuffledHintArray: [String] = []
        
        for _ in 1...questionArray.count{
            randomNumber = Int.random(in: 0..<questionArray.count)
            
            shuffledArray.append(questionArray[randomNumber])
            shuffledHintArray.append(hintArray[randomNumber])
            answersArray.append(questionArray[randomNumber])
            
            questionArray.remove(at: randomNumber)
            hintArray.remove(at: randomNumber)
        }
        
        return (shuffledArray,shuffledHintArray,answersArray)
    }
    
    
    
    struct leaderBoard {
        var firstPlaceScore:Int? = nil
        var firstPlaceName:String? = nil
        var secondPlaceScore:Int? = nil
        var secondPlaceName:String? = nil
        var thirdPlaceScore:Int? = nil
        var thirdPlaceName:String? = nil
        
        mutating func initializeLeaderboards() {
            firstPlaceScore = topScores.object(forKey:"first") as? Int ?? Int()
            firstPlaceName = topScores.object(forKey:"firstName") as? String ?? String()
            
            secondPlaceScore = topScores.object(forKey:"second") as? Int ?? Int()
            secondPlaceName = topScores.object(forKey:"secondName") as? String ?? String()
            
            thirdPlaceScore = topScores.object(forKey:"third") as? Int ?? Int()
            thirdPlaceName = topScores.object(forKey:"thirdName") as? String ?? String()
        }
        
        
        
        mutating func updateLeaderboards(score: Int, name: String) {
            
            if  score >= firstPlaceScore! {
                
                
                        topScores.removeObject(forKey: "third")
                        topScores.removeObject(forKey: "thirdName")
                topScores.set(secondPlaceScore, forKey: "third")
                topScores.set(secondPlaceName, forKey: "thirdName")
                
                //       topScores.removeObject(forKey: "firstName")
                        topScores.removeObject(forKey: "second")
                        topScores.removeObject(forKey: "secondName")
        
                topScores.set(firstPlaceScore, forKey: "second")
                topScores.set(firstPlaceName, forKey: "secondName")
                
                topScores.removeObject(forKey: "first")
                topScores.removeObject(forKey: "firstName")
        
                topScores.set(score, forKey: "first")
                topScores.set(name, forKey: "firstName")
                
                
            } else if score >= secondPlaceScore! {
                
                topScores.removeObject(forKey: "third")
                topScores.removeObject(forKey: "thirdName")
                topScores.set(secondPlaceScore, forKey: "third")
                topScores.set(secondPlaceName, forKey: "thirdName")
                
                topScores.removeObject(forKey: "second")
                topScores.removeObject(forKey: "secondName")
                topScores.set(score, forKey: "second")
                topScores.set (name, forKey: "secondName")
                
            } else if score >= thirdPlaceScore! {
                
                topScores.removeObject(forKey: "third")
                topScores.removeObject(forKey: "thirdName")
                
                topScores.set(Int(score), forKey: "third")
                topScores.set(name, forKey: "thirdName")
                
                
            }
        }
    }
    
    var newLeaderboard = leaderBoard()      //Initializes leaderboard
    
    struct Game {
        var wordsArray: [String] = []                       //Game struct that has arrays for all words, scrambled and not
        var scrambledWordsArray: [String] = []
        var scrambledHintWordsArray: [String] = []
        var answersArray: [String] = []
        var correctWordArray: [Character] = []
        var currentWord: [Character] = [] // creates a game instance
        var lastButtonEntered:[UIButton]? = nil
        
        init() {
        }
            init(gameWordsArray: inout [String], scrambledHintWordsInputArray: inout [String]) {
                wordsArray = []
                scrambledWordsArray = []
                scrambledHintWordsArray = []
                answersArray = []
                correctWordArray = []
                currentWord = []
                lastButtonEntered = nil
                
            let wordsAndHints = shuffleTheseArrays(questionArray: &gameWordsArray, hintArray: &scrambledHintWordsInputArray)
            wordsArray = wordsAndHints.0
            scrambledHintWordsArray = wordsAndHints.1
            answersArray = wordsAndHints.2
            
            for index in 0..<wordsArray.count {
                var scrambledWord = ""
                
                scrambledWord = scrambleThisWord(&wordsArray[index])  //scrambles the words of inputted string
                scrambledWordsArray.append(scrambledWord)
            }
                currentWord = GameViewController.Game.stringToArray(scrambledWordsArray[0])
                correctWordArray = GameViewController.Game.stringToArray(answersArray[0])
                print(answersArray[0])
        }
        
        static func stringToArray(_ thisString: String) -> [Character] {
            var charArray: [Character] = []
            charArray.append(contentsOf: thisString)
            return charArray
        }
    }
    
    struct selectedButtonPair {
        var letterButtonOriginal: UIButton? = nil
        var letterButtonFinal: UIButton? = nil
        var letterButtonOriginalTitle: Character? = nil //Figures out what button was submitted by the user and displays it
        var letterButtonFinalTitle: Character? = nil
        
        var isInitialized = false
        
        mutating func unInitialize() {
            letterButtonOriginal?.setTitle(String(letterButtonFinalTitle!), for: .normal)
                letterButtonOriginal?.isHidden = false
            letterButtonFinal?.setTitle("", for: .normal) // Resets all buttons
            self.letterButtonOriginal = nil
            self.letterButtonFinal = nil
            self.letterButtonOriginalTitle = nil
            self.letterButtonFinalTitle = nil
            self.isInitialized = false
           
        }
        
        mutating func reinitialize(whereDidItComeFrom: UIButton, whereDidItGo: UIButton) {
            letterButtonOriginal = whereDidItComeFrom
            letterButtonFinal = whereDidItGo                                    //Puts buttons back
            letterButtonOriginalTitle = Character(whereDidItComeFrom.title(for: .normal)!)
            letterButtonFinalTitle = Character(whereDidItGo.title(for: .normal)!)
            isInitialized = true
            
        }
        init() {
        }
    }
    
    var firstChoice = selectedButtonPair()
    var secondChoice = selectedButtonPair()
    var thirdChoice = selectedButtonPair()
    var fourthChoice = selectedButtonPair()
    var fifthChoice = selectedButtonPair()
    var sixthChoice = selectedButtonPair()
    var seventhChoice = selectedButtonPair()
    var eighthChoice = selectedButtonPair()
    var ninthChoice = selectedButtonPair() //Initializes every single pair
    var tenthChoice = selectedButtonPair()
    var eleventhChoice = selectedButtonPair()
    var twelvethChoice = selectedButtonPair()
    
    

    
   var coldPlacesCategory = ["CANADA", "RUSSIA","ANTARCTICA","ASPEN","QUEBEC","EVEREST", "SWEDEN" , "SIBERIA" , "ALASKA" , "GREENLAND","POLAND","ICELAND","YUKON"]
    
    var coldPlacesCategoryHints = ["Home of the maple leaf", "Ra-Ra-Rasputin", "Is this the one on the top or on the bottom?","Popular Skiing Destination","Home of 'Carnaval'", "You can climb it" , "Ikea" ,"Soviet Camps", "Right beside all that Yukon gold", "\"Plague Inc's\" hardest country","Slavic Country","Not as Cold as Greenland","Has alot of Gold"]
    
    var winterSportsCategory = ["HOCKEY", "TOBOGGANING","SKIING" , "BIATHLON" , "SKATING" , "SCULPTING" , "BOBSLEDDING","LUGE","SNOWMOBILE","CURLING","DOGSLED","ICEFISHING","SKELETON"]
    var winterSportsCategoryHints = ["Canada's unofficial sport", "Kid's activity on hills" , "Every polish last name" , "Olympic sport involving Shooting" , "Cute date idea","Ice Art", "Jamaica has their own team during the Olympics","Kids that went professional with sledding", "Rich mans dirtbike", "Sliding stones on ice","Uses Dogs","Fishing but in the winter","Luge but headfirst"]
    
    var clothingCategory = ["LONGJOHNS", "TOQUE", "MITTENS", "GLOVES" , "SNOWPANTS" , "TURTLENECK" , "WOOLEN" , "SCARF" , "PARKA", "VALENKI","COAT","SOCKS","BALACLAVA"]   // Creating strings for each question
    var clothingCategoryHints = ["The opposite would be 'ShortJanes'" , "French headwear", "Popular recreational clothing for hands" , "The warmest type of hand attire you can have", "A must-have for building Snow Forts","Usually worn to hide hickeys","Type of yarn used in most casual winter clothes","Neck attire","Type of coat","Russian Winter Socks","Most Common clothing","Never get these wet","Basically a ski mask"]
    
    var randomCategory = ["SNIFFLE", "DRAFTY", "FRIGID", "GALE", "INSULATION", "SNOWBOUND" ,"SOLSTICE" ,"SUGARPLUM","SLEET","ANORAK","SNOW","ICE", "ARCHERY"]
    var randomCategoryHints = ["You make this noise when sick","Currents of cool air" , "Very cold in temperature" , "A very strong wind","To keep away the cold","Confined in one place by heavy snow","Theres one in the winter and summer","A small round piece of sugary candy", "A mixture of rain and snow or hail" , "A jacket with a hood","This ones everywhere","Do you even need help?", "Uses Arrows"]
    
    
    func whichButtonsToEnable(currentWord: String) -> [Int] {
        //Figures out what buttons to enable in the choice category
        switch currentWord.count {
        case 3:
            whichButtonsCanTheyTypeIn = [letterButton[4], letterButton[5],letterButton[6]]
            return [4,5,6]
        case 4:
        whichButtonsCanTheyTypeIn = [letterButton[4], letterButton[5],letterButton[6],letterButton[7]]
            return [4,5,6,7]
        case 5:
            whichButtonsCanTheyTypeIn = [letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7]]
            return [3,4,5,6,7]
        case 6:
            whichButtonsCanTheyTypeIn = [letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7],letterButton[8]]
            return [3,4,5,6,7,8]
        case 7:
            whichButtonsCanTheyTypeIn = [letterButton[2],letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7],letterButton[8]]
            return [2,3,4,5,6,7,8]
        case 8:
            whichButtonsCanTheyTypeIn = [letterButton[2],letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7],letterButton[8],letterButton[9]]
            return [2,3,4,5,6,7,8,9]
        case 9:
            whichButtonsCanTheyTypeIn = [letterButton[1],letterButton[2],letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7],letterButton[8],letterButton[9]]
            return [1,2,3,4,5,6,7,8,9]
        case 10:
            whichButtonsCanTheyTypeIn = [letterButton[1],letterButton[2],letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7],letterButton[8],letterButton[9],letterButton[10]]
            return [1,2,3,4,5,6,7,8,9,10]
        case 11:
            whichButtonsCanTheyTypeIn = [letterButton[0],letterButton[1],letterButton[2],letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7],letterButton[8],letterButton[9],letterButton[10]]
            return [0,1,2,3,4,5,6,7,8,9,10]
        default:
             whichButtonsCanTheyTypeIn = [letterButton[0],letterButton[1],letterButton[2],letterButton[3],letterButton[4], letterButton[5],letterButton[6],letterButton[7],letterButton[8],letterButton[9],letterButton[10],letterButton[11]]
            return [0,1,2,3,4,5,6,7,8,9,12,11]
            }
    }
    
    
    func pairTwoChosen (sender: UIButton, tempButton:UIButton){
    
    if  firstChoice.isInitialized == false { //Pairs two buttons
        firstChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if secondChoice.isInitialized == false {
        secondChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if thirdChoice.isInitialized == false {
        thirdChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if fourthChoice.isInitialized == false {
        fourthChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if fifthChoice.isInitialized == false {
        fifthChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if sixthChoice.isInitialized == false {
        sixthChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if seventhChoice.isInitialized == false {
        seventhChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if eighthChoice.isInitialized == false {
        eighthChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if ninthChoice.isInitialized == false {
        ninthChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if tenthChoice.isInitialized == false {
        tenthChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if eleventhChoice.isInitialized == false {
        eleventhChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    } else if twelvethChoice.isInitialized == false {
        twelvethChoice.reinitialize(whereDidItComeFrom: sender, whereDidItGo: tempButton)
    
        }
    }
    
    var newGame = Game()    //Creates na instance of class
    
    @IBAction func ColdPlacesAction(_ sender: Any) {
        score = 0
        var randomNum = 0
        var tempButtonArray: [UIButton] = []
        hintLabel.isHidden = false
    
        for button in categoryButton {
        button.isHidden = true
        CategoryLabel.text = categoriesString[0]        //Hides all the category buttons
        }
        
        scoreLabel.isHidden = false   //Shows scores and hintbuttons
        scoreStaticTextLabel.isHidden = false
        giveUpButton.isHidden = false
        hintButton.isHidden = false
        submitButton.isHidden = false
        clearButton.isHidden = false
        
        newGame = Game(gameWordsArray: &coldPlacesCategory, scrambledHintWordsInputArray: &coldPlacesCategoryHints)
        
        for index in whichButtonsToEnable(currentWord: newGame.scrambledWordsArray[0]) {
            currentWordLetters[index].isHidden = false //Enables White buttons
            currentWordLetters[index].setTitle("", for: .normal)
            }

        tempButtonArray = letterButton
        
        for _ in 1...newGame.currentWord.count {
            randomNum = Int.random(in: 0..<tempButtonArray.count)
            currentActiveGuessButton.append(tempButtonArray[randomNum]) //Randomly decides what buttons to display users character options with
            tempButtonArray.remove(at: randomNum)
        }
        for i in 0..<newGame.currentWord.count {
            
            currentActiveGuessButton[i].isHidden = false
            currentActiveGuessButton[i].setTitle(String(newGame.currentWord[0]), for: .normal) //sets the titles of the acivated buttons as characters
            newGame.currentWord.removeFirst()
            }
        newGame.currentWord = Game.stringToArray(newGame.scrambledWordsArray[0])
    }
    
    @IBAction func winterSportsAction(_ sender: Any) {
        score = 0
        var randomNum = 0
        var tempButtonArray: [UIButton] = []        //sets score to 0 and re-enables hint button and labels
        hintLabel.isHidden = false
        
        for button in categoryButton {
            button.isHidden = true
            CategoryLabel.text = categoriesString[1]        //Hides all the category buttons
        }
        
        scoreLabel.isHidden = false     //Displays scores and hintbuttons
        scoreStaticTextLabel.isHidden = false
        giveUpButton.isHidden = false
        hintButton.isHidden = false
        submitButton.isHidden = false
        clearButton.isHidden = false
        
        newGame = Game(gameWordsArray: &winterSportsCategory, scrambledHintWordsInputArray: &winterSportsCategoryHints)
        
        for index in whichButtonsToEnable(currentWord: newGame.scrambledWordsArray[0]) {
            currentWordLetters[index].isHidden = false   //Enables White buttons
            currentWordLetters[index].setTitle("", for: .normal)
        }
        
        tempButtonArray = letterButton
        
        for _ in 1...newGame.currentWord.count {
            randomNum = Int.random(in: 0..<tempButtonArray.count)
            currentActiveGuessButton.append(tempButtonArray[randomNum]) //Randomly decides what buttons to display users character options with
            tempButtonArray.remove(at: randomNum)
        }
        for i in 0..<newGame.currentWord.count {
            
            currentActiveGuessButton[i].isHidden = false
            currentActiveGuessButton[i].setTitle(String(newGame.currentWord[0]), for: .normal) //sets the titles of the acivated buttons as characters
            newGame.currentWord.removeFirst()
        }
        newGame.currentWord = Game.stringToArray(newGame.scrambledWordsArray[0])
    }
    
    
    @IBAction func clothingAction(_ sender: Any) {
        score = 0
        var randomNum = 0
        var tempButtonArray: [UIButton] = []        //sets score to 0 and re-enables hint button and labels
        hintLabel.isHidden = false
        
        for button in categoryButton {
            button.isHidden = true
            CategoryLabel.text = categoriesString[1]        //Hides all the category buttons
        }
        
        scoreLabel.isHidden = false     //Displays scores and hintbuttons
        scoreStaticTextLabel.isHidden = false
        giveUpButton.isHidden = false
        hintButton.isHidden = false
        submitButton.isHidden = false
        clearButton.isHidden = false
        
        newGame = Game(gameWordsArray: &clothingCategory, scrambledHintWordsInputArray: &clothingCategoryHints)
        
        for index in whichButtonsToEnable(currentWord: newGame.scrambledWordsArray[0]) {
            currentWordLetters[index].isHidden = false   //Enables White buttons
            currentWordLetters[index].setTitle("", for: .normal)
        }
        
        tempButtonArray = letterButton
        
        for _ in 1...newGame.currentWord.count {
            randomNum = Int.random(in: 0..<tempButtonArray.count)
            currentActiveGuessButton.append(tempButtonArray[randomNum]) //Randomly decides what buttons to display users character options with
            tempButtonArray.remove(at: randomNum)
        }
        for i in 0..<newGame.currentWord.count {
            
            currentActiveGuessButton[i].isHidden = false
            currentActiveGuessButton[i].setTitle(String(newGame.currentWord[0]), for: .normal) //sets the titles of the acivated buttons as characters
            newGame.currentWord.removeFirst()
        }
        newGame.currentWord = Game.stringToArray(newGame.scrambledWordsArray[0])
    }
    
    @IBAction func randomWinterWordsAction(_ sender: Any) {
        score = 0
        var randomNum = 0
        var tempButtonArray: [UIButton] = []        //sets score to 0 and re-enables hint button and labels
        hintLabel.isHidden = false
        
        for button in categoryButton {
            button.isHidden = true
            CategoryLabel.text = categoriesString[1]        //Hides all the category buttons
        }
        
        scoreLabel.isHidden = false     //Displays scores and hintbuttons
        scoreStaticTextLabel.isHidden = false
        giveUpButton.isHidden = false
        hintButton.isHidden = false
        submitButton.isHidden = false
        clearButton.isHidden = false
        
        newGame = Game(gameWordsArray: &randomCategory, scrambledHintWordsInputArray: &randomCategoryHints)
        
        for index in whichButtonsToEnable(currentWord: newGame.scrambledWordsArray[0]) {
            currentWordLetters[index].isHidden = false   //Enables White buttons
            currentWordLetters[index].setTitle("", for: .normal)
        }
        
        tempButtonArray = letterButton
        
        for _ in 1...newGame.currentWord.count {
            randomNum = Int.random(in: 0..<tempButtonArray.count)
            currentActiveGuessButton.append(tempButtonArray[randomNum]) //Randomly decides what buttons to display users character options with
            tempButtonArray.remove(at: randomNum)
        }
        for i in 0..<newGame.currentWord.count {
            
            currentActiveGuessButton[i].isHidden = false
            currentActiveGuessButton[i].setTitle(String(newGame.currentWord[0]), for: .normal) //sets the titles of the acivated buttons as characters
            newGame.currentWord.removeFirst()
        }
        newGame.currentWord = Game.stringToArray(newGame.scrambledWordsArray[0])
    }
    
    
    @IBAction func hintButtonPressed(_ sender: Any) {
        hintButton.isHidden = true
        hintLabel.isHidden = false
        hintLabel.text = newGame.scrambledHintWordsArray[0]
        score -= 5
        scoreLabel.text = String(score)
    }
    
    @IBAction func pressedButtonZero(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
        let sender: UIButton = letterButton[0]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }

    @IBAction func pressedButtonOne(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
      
        let sender: UIButton = letterButton[1]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
        
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                
                switchedLetter = true
            }
            index += 1
        }
        
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonTwo(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
   
        let sender: UIButton = letterButton[2]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
          
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
             
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonThree(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
  
        let sender: UIButton = letterButton[3]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
         
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
               
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedbuttonFour(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
        
        let sender: UIButton = letterButton[4]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
              
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonFive(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
        
        let sender: UIButton = letterButton[5]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                newGame.lastButtonEntered = [currentWordLetters[index],sender ]
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonSix(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
      
        let sender: UIButton = letterButton[6]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                newGame.lastButtonEntered = [currentWordLetters[index],sender ]
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonSeven(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
        
        let sender: UIButton = letterButton[7]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                newGame.lastButtonEntered = [currentWordLetters[index],sender ]
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonEight(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
       
        let sender: UIButton = letterButton[8]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                newGame.lastButtonEntered = [currentWordLetters[index],sender ]
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonNine(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
       
        let sender: UIButton = letterButton[9]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
}
    @IBAction func pressedButtonTen(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
        
        let sender: UIButton = letterButton[10]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                newGame.lastButtonEntered = [currentWordLetters[index],sender ]
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    @IBAction func pressedButtonEleven(_ sender: Any) {
        var index = 0
        var switchedLetter = false
        var tempButton: UIButton? = nil
        
        let sender: UIButton = letterButton[11]
        
        while switchedLetter == false  {
            if currentWordLetters[index].currentTitle == ""  {
                newGame.lastButtonEntered = [currentWordLetters[index],sender ]
                currentWordLetters[index].setTitle(sender.currentTitle, for: .normal)
                tempButton = currentWordLetters[index]
                
                
                switchedLetter = true
            }
            index += 1
        }
        tempButton!.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        tempButton!.transform = CGAffineTransform.identity  //Code to bounce a button they add in
        },
                       completion: { Void in()  }
        )
        
        sender.isHidden = true
        
        pairTwoChosen(sender: sender, tempButton: tempButton!)
    }
    
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        var currentGuess: [Character] = []
        var unpressedButton:Bool = false
        var tempButtonArray: [UIButton] = []
        var randomNum = 0
        
        for index in letterButton {
            if index.isHidden == false {
            unpressedButton = true      //Checks if any of the buttons are unpressed
            }
        }
        if unpressedButton == false {
        
        for index in 0..<letterButton.count {
            if currentWordLetters[index].currentTitle != nil {
                currentGuess.append(Character(currentWordLetters[index].currentTitle!))
            }
        }       //Adds all the titles to currentGuess array to compare to the correct word later
        }
        
        if unpressedButton == true {
            for index in 0..<letterButton.count { //If a button is not hidden, it will shake the not hidden buttons
                letterButton[index].shake()
            }
                hintLabel.isHidden = false
                hintLabel.text = "You have not chosen all the letters!"
                score -= 2
                scoreLabel.text = String(score)
            
        } else if newGame.scrambledWordsArray.count == 1 && newGame.correctWordArray == currentGuess {
            
            
            
            
            /*
             This code executes at the end of the game
 
 
            */
            
            score += 10
            scoreStaticTextLabel.text = "Final Score:"
            scoreLabel.text = String(score)
            
            hintButton.isHidden = true
            clearButton.isHidden = true
            submitButton.isHidden = true
            hintLabel.text = "Congratulations!"
            for index in letterButton {     //Hides all the buttons
                index.isHidden = true
            }
            for index in currentWordLetters {
                index.isHidden = true
            }
            
            giveUpButton.setTitle("Finish!", for: .normal)

            
            
        } else if newGame.correctWordArray == currentGuess {
            
            
            /*
                If they have guessed the word correctly, and there are more words before the end of the game, this code executes.
 
 
 
            */
            
            currentActiveGuessButton = []
            score += 10
            scoreLabel.text = String(score)
            newGame.scrambledHintWordsArray.removeFirst()
            //newGame.scrambledWordsArray.removeFirst()
            //newGame.correctWordArray.removeFirst()
            newGame.answersArray.removeFirst()
           
            hintLabel.text = "Correct!"
            scoreLabel.text = String(score)
            hintButton.isHidden = false
            
           var tempArray = newGame.scrambledHintWordsArray
            var tempArray2 = newGame.answersArray
            
            
            for index in 0..<letterButton.count{
                letterButton[index].setTitle(nil, for: .normal)
                currentWordLetters[index].setTitle(nil, for: .normal)       //Deactivates all the letter buttons
                letterButton[index].isHidden = true
                currentWordLetters[index].isHidden = true
            }
            
            newGame = Game(gameWordsArray: &tempArray2, scrambledHintWordsInputArray: &tempArray)
            
            for index in whichButtonsToEnable(currentWord: newGame.scrambledWordsArray[0]) {
                currentWordLetters[index].isHidden = false               //Enables White buttons
                currentWordLetters[index].setTitle("", for: .normal)
            }
            
            tempButtonArray = letterButton
            
            for _ in 1...newGame.currentWord.count {
                randomNum = Int.random(in: 0..<tempButtonArray.count)
                currentActiveGuessButton.append(tempButtonArray[randomNum]) //Randomly decides what buttons to display users character options with
                tempButtonArray.remove(at: randomNum)
            }
            for i in 0..<newGame.currentWord.count {
                
                currentActiveGuessButton[i].isHidden = false
                currentActiveGuessButton[i].setTitle(String(newGame.currentWord[0]), for: .normal) //sets the titles of the acivated buttons as characters
                newGame.currentWord.removeFirst()
            }
            newGame.currentWord = Game.stringToArray(newGame.scrambledWordsArray[0])
            
            firstChoice = selectedButtonPair()
            secondChoice = selectedButtonPair()
            thirdChoice = selectedButtonPair()
            fourthChoice = selectedButtonPair()
            fifthChoice = selectedButtonPair()
            sixthChoice = selectedButtonPair()
            seventhChoice = selectedButtonPair()
            eighthChoice = selectedButtonPair()         //Restarts clear function
            ninthChoice = selectedButtonPair()
            tenthChoice = selectedButtonPair()
            eleventhChoice = selectedButtonPair()
            twelvethChoice = selectedButtonPair()
            
        } else {
            
            
            //If incorrect guess, this code exectues
            
            
            
            
            for index in 0..<letterButton.count { //If a button is not hidden, it will shake the not hidden buttons
                letterButton[index].shake()
            }
            score -= 1
            scoreLabel.text = String(score)
            hintLabel.text = "Wrong!"
            
            firstChoice.unInitialize()
            secondChoice.unInitialize()
            thirdChoice.unInitialize()
            fourthChoice.unInitialize()
            fifthChoice.unInitialize()
            sixthChoice.unInitialize()
            seventhChoice.unInitialize()
            eighthChoice.unInitialize() // Clears all typed in buttons
            ninthChoice.unInitialize()
            tenthChoice.unInitialize()
            eleventhChoice.unInitialize()
            twelvethChoice.unInitialize()
            
            }
        }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        firstChoice.unInitialize()
        secondChoice.unInitialize()
        thirdChoice.unInitialize()
        fourthChoice.unInitialize()
        fifthChoice.unInitialize()
        sixthChoice.unInitialize()
        seventhChoice.unInitialize()
        eighthChoice.unInitialize()
        ninthChoice.unInitialize()
        tenthChoice.unInitialize()
        eleventhChoice.unInitialize()
        twelvethChoice.unInitialize()
        
    

    }
    
        
    @IBAction func giveUpButtonPressed(_ sender: Any) {
        
        newLeaderboard.initializeLeaderboards()
        newLeaderboard.updateLeaderboards(score: score, name: username!)
    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
}
