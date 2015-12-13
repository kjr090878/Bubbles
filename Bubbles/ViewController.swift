//
//  ViewController.swift
//  Bubbles
//
//  Created by Kelly Robinson on 11/9/15.
//  Copyright © 2015 Kelly Robinson. All rights reserved.
//

import UIKit

import AVFoundation


class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate, AVAudioPlayerDelegate {
    
    var session = AVCaptureSession()
    
    var players: [AVAudioPlayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        
        let captureInput = try? AVCaptureDeviceInput(device: captureDevice!)
      
        
     
        if session.canAddInput(captureInput) {
      
        session.addInput(captureInput)
        
        }
        
        let captureOutput = AVCaptureAudioDataOutput()
        
        if session.canAddOutput(captureOutput) {
            
            session.addOutput(captureOutput)
            
        }
        
        captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
//
//        captureOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        
        session.startRunning()
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
       
        
        guard let channel = connection.audioChannels.first else { return }
//        
//        print("APL : \(channel?.averagePowerLevel) PHL : \(channel?.peakHoldLevel)")
//        
        if channel.averagePowerLevel > -5 {
            
//            print("Blowing")
            
            
            dispatch_async(dispatch_get_main_queue())  {
            
                let bubbleSize = CGFloat(arc4random_uniform(15)*5) + 30
                // randomize width and height
                let bubble = Bubble(frame: CGRect(origin: CGPointZero, size: CGSize(width: bubbleSize, height: bubbleSize)))
                
                bubble.backgroundColor = UIColor.clearColor()
                
                bubble.spacing = CGFloat(arc4random_uniform(10))
                
            
                
                bubble.setNeedsDisplay()
                
                let colors = [UIColor.blackColor(),UIColor.redColor(),UIColor.purpleColor()]

                let randomColorIndex = Int(arc4random_uniform(3))

                // randomize color between blue and purple

                bubble.color = colors[randomColorIndex]
                
                bubble.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.maxY)
                
                self.view.addSubview(bubble)
                
//            bubble.isMemberOfClass(Bubble)
             
            
            let randomDuration = Double(abs(channel.averagePowerLevel))
                
                let randomX = CGFloat(arc4random_uniform(UInt32(self.view.frame.maxX)))
                
                let randomY = CGFloat(arc4random_uniform(UInt32(self.view.frame.midY)))
            
            UIView.animateWithDuration(randomDuration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                
                
                
                // randomize the bubble.center x & y
                bubble.center.y = randomY
                bubble.center.x = randomX
                
                })  { (finished) -> Void in
                
                    // play pop sound
                    bubble.removeFromSuperview()
                    
                    let popData = NSDataAsset(name: "Pop")
                    
                    let player = try?AVAudioPlayer(data: popData!.data)
                    
                    self.players.append(player!)
                    
                    player?.delegate = self
                    player?.play()
                }
            }
           
        }
        
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        guard let index = players.indexOf(player) else { return }
        players.removeAtIndex(index)
        
        print(players.count)
    }

}

