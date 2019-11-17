//
//  LeaderboardViewController.swift
//  scrambleApp
//
//  Created by Os on 2019-03-05.
//  Copyright © 2019 Os. All rights reserved.


import UIKit

//var topScores = UserDefaults.standard

class LeaderboardViewController: UIViewController {
    
    @IBOutlet var leaderBoardNames: [UILabel]!
    
    @IBOutlet var leaderBoardScores: [UILabel]!
    
   // var firstPlace: Int = 0
    
   
    struct leaderBoard {
        var firstPlaceScore:Int? = nil
        var firstPlaceName:String? = nil
        var secondPlaceScore:Int? = nil
        var secondPlaceName:String? = nil
        var thirdPlaceScore:Int? = nil
        var thirdPlaceName:String? = nil
        
        
        
        mutating func displayLeaderboards() {
            
            firstPlaceScore = topScores.object(forKey:"first") as? Int ?? Int()
            firstPlaceName = topScores.object(forKey:"firstName") as? String ?? String()
            
            secondPlaceScore = topScores.object(forKey:"second") as? Int ?? Int()
            secondPlaceName = topScores.object(forKey:"secondName") as? String ?? String()
            
            thirdPlaceScore = topScores.object(forKey:"third") as? Int ?? Int()
            thirdPlaceName = topScores.object(forKey:"thirdName") as? String ?? String()
           
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var newLeaderboard = leaderBoard()
        
        newLeaderboard.displayLeaderboards()
        UserDefaults.standard.synchronize()
        
        guard let firstPlaceNameNotNil:String = newLeaderboard.firstPlaceName else { return }
        leaderBoardNames[0].text = firstPlaceNameNotNil
        
        guard let secondPlaceNameNotNil:String = newLeaderboard.secondPlaceName else { return }
        leaderBoardNames[1].text = secondPlaceNameNotNil
    
        guard let thirdPlaceNameNotNil:String = newLeaderboard.thirdPlaceName else { return }
        leaderBoardNames[2].text = thirdPlaceNameNotNil
        
        
        
        guard let firstPlaceScoreNotNil = newLeaderboard.firstPlaceScore else { return }
        leaderBoardScores[0].text = String(firstPlaceScoreNotNil)
        
        guard let secondPlaceScoreNotNil = newLeaderboard.secondPlaceScore else { return }
        leaderBoardScores[1].text = String(secondPlaceScoreNotNil)
        
        guard let thirdPlaceScoreNotNil = newLeaderboard.thirdPlaceScore else { return }
        leaderBoardScores[2].text = String(thirdPlaceScoreNotNil)
        
        
        
        if newLeaderboard.firstPlaceScore == 0 && newLeaderboard.firstPlaceName == "" {
            leaderBoardNames[0].text = "Empty"
            leaderBoardScores[0].text = ""
        }
        if newLeaderboard.secondPlaceScore == 0 && newLeaderboard.secondPlaceName == "" {
            leaderBoardNames[1].text = "Empty"
            leaderBoardScores[1].text = ""
        }
        if newLeaderboard.thirdPlaceScore == 0 && newLeaderboard.thirdPlaceName == "" {
            leaderBoardNames[2].text = "Empty"
            leaderBoardScores[2].text = ""
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
