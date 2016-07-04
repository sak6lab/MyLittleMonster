//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Saketh D on 7/1/16.
//  Copyright © 2016 Saketh D. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImg: DragImage!
    @IBOutlet weak var foodImg: DragImage!
    @IBOutlet weak var skull3: UIImageView!
    @IBOutlet weak var skull: UIImageView!
    @IBOutlet weak var skull2: UIImageView!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var minerImg: MinerImg!
    @IBOutlet weak var boulderImg: DragImage!
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxHit: AVAudioPlayer!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var monsterHappy = false
    var currentImage: UInt32 = 0
    
    var outMiner = false
    var penalties = 0
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        boulderImg.dropTarget = monsterImg
        
        skull.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
        
        pickNeed()
        
        do{
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: ".mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: ".wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: ".wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: ".wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: ".wav")!))
            try sfxHit = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("hit", ofType: ".wav")!))
                
        }catch let err as NSError {
            print(err.debugDescription )
        }
        
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        sfxBite.prepareToPlay()
        sfxHeart.prepareToPlay()
        sfxDeath.prepareToPlay()
        sfxSkull.prepareToPlay()
        sfxHit.prepareToPlay()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.itemDroppedOnCharacter) , name: "onTargetDropped", object: nil)
        startTimer()
        
        
    }
    @IBAction func restartPress(sender: AnyObject){
        restartGame()
    }
    func itemDroppedOnCharacter(notif :AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        boulderImg.alpha = DIM_ALPHA
        boulderImg.userInteractionEnabled = false
        
        if currentImage == 0 {
            sfxBite.play()
        } else  if currentImage == 1{
            sfxHeart.play()
        } else {
            monsterImg.playAttackAnimation()
            sfxHit.play()
            minerImg.playHideAnimation()
            outMiner = false
        }
    }
    func startTimer(){
        if timer != nil{
            timer.invalidate()
        }
            timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
        
    }
    func changeGameState(){
        
        pickNeed()
        if !monsterHappy {
            if penalties < 4 {
                penalties += 1
            }
            
            sfxSkull.play()
            
            if penalties == 1 {
                skull.alpha = OPAQUE
                skull2.alpha = DIM_ALPHA
            }
            else if penalties == 2 {
                skull2.alpha = OPAQUE
                skull3.alpha = DIM_ALPHA
            }
            else if penalties == 3 {
                gameOver()
            }
        }
        monsterHappy = false
    }
    func pickNeed(){
        if penalties < 4{
            let rand = arc4random_uniform(3)
            
            if rand == 1 {
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
                
                heartImg.alpha = OPAQUE
                heartImg.userInteractionEnabled = true
                
                boulderImg.alpha = DIM_ALPHA
                boulderImg.userInteractionEnabled=false
            } else if rand == 0{
                foodImg.alpha = OPAQUE
                foodImg.userInteractionEnabled = true
                
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
                
                boulderImg.alpha = DIM_ALPHA
                boulderImg.userInteractionEnabled = false
            } else {
                minerImg.hidden = false
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
                
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
                
                boulderImg.alpha = OPAQUE
                boulderImg.userInteractionEnabled = true
                if !outMiner {
                    minerImg.playAppearAnimation()
                    outMiner = true
                }
            }
            currentImage = rand
        }
        
    }
    func restartGame(){
        penalties = 0
        monsterImg.playIdleAnimation()
        startTimer()
        skull.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
        restartBtn.hidden = true
    }
    func gameOver(){
        skull3.alpha = OPAQUE
        timer.invalidate()
        monsterImg.playDeathAnimation()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        boulderImg.alpha = DIM_ALPHA
        boulderImg.userInteractionEnabled = false
        minerImg.playHideAnimation()
        outMiner = false
        
        restartBtn.hidden = false
        
        sfxDeath.play()
    }
}

