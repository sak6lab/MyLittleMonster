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
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var monsterHappy = false
    var currentImage: UInt32 = 0
    
    var penalties = 0
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        skull.alpha = DIM_ALPHA
        skull2.alpha = DIM_ALPHA
        skull3.alpha = DIM_ALPHA
        
        do{
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: ".mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: ".wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: ".wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: ".wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: ".wav")!))
                
        }catch let err as NSError {
            print(err.debugDescription )
        }
        
        musicPlayer.prepareToPlay()
        musicPlayer.play()
        sfxBite.prepareToPlay()
        sfxHeart.prepareToPlay()
        sfxDeath.prepareToPlay()
        sfxSkull.prepareToPlay()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ViewController.itemDroppedOnCharacter) , name: "onTargetDropped", object: nil)
        startTimer()
        
        
    }
    
    func itemDroppedOnCharacter(notif :AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentImage == 0 {
            sfxBite.play()
        } else {
            sfxHeart.play()
        }
    }
    func startTimer(){
        if timer != nil{
            timer.invalidate()
        }
            timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
        
    }
    func changeGameState(){
        
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
                
                skull3.alpha = OPAQUE
                timer.invalidate()
                monsterImg.playDeathAnimation()
                
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
                
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
                
                sfxDeath.play()
                
            } else {
                
                skull.alpha = DIM_ALPHA
                skull2.alpha = DIM_ALPHA
                skull3.alpha = DIM_ALPHA
            }
            
        }
        let rand = arc4random_uniform(2)
        
        if rand == 1 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
        }
        currentImage = rand
        monsterHappy = false
    }
    
}

