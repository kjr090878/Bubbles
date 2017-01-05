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
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
        
        let captureInput = try? AVCaptureDeviceInput(device: captureDevice!)
      
        
     
        if session.canAddInput(captureInput) {
      
        session.addInput(captureInput)
        
        }
        
        let captureOutput = AVCaptureAudioDataOutput()
        
        if session.canAddOutput(captureOutput) {
            
            session.addOutput(captureOutput)
            
        }
        
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .background))
        
        session.startRunning()
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
       
        
        guard let channel = connection.audioChannels.first else { return }
//        
//        print("APL : \(channel?.averagePowerLevel) PHL : \(channel?.peakHoldLevel)")
//        
        if (channel as AnyObject).averagePowerLevel > -5 {
            
            print("Blowing")
            
            
            DispatchQueue.main.async()  {
            
                let bubbleSize = CGFloat(arc4random_uniform(15)*5) + 30
                // randomize width and height
                let bubble = Bubble(frame: CGRect(origin: CGPoint(x:0, y:0), size: CGSize(width: bubbleSize, height: bubbleSize)))
                
                bubble.backgroundColor = UIColor.clear
                
                bubble.spacing = CGFloat(arc4random_uniform(10))
                
            
                
                bubble.setNeedsDisplay()
                
                let colors = [UIColor.black,UIColor.red,UIColor.purple]

                let randomColorIndex = Int(arc4random_uniform(3))

                // randomize color between blue and purple

                bubble.color = colors[randomColorIndex]
                
                bubble.center = CGPoint(x: self.view.frame.midX, y: self.view.frame.maxY)
                
                self.view.addSubview(bubble)
                
//            bubble.isMemberOfClass(Bubble)
             
            
            let randomDuration = Double(abs((channel as AnyObject).averagePowerLevel))
                
                let randomX = CGFloat(arc4random_uniform(UInt32(self.view.frame.maxX)))
                
                let randomY = CGFloat(arc4random_uniform(UInt32(self.view.frame.midY)))
            
            UIView.animate(withDuration: randomDuration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                
                
                
                // randomize the bubble.center x & y
                bubble.center.y = randomY
                bubble.center.x = randomX
                
                })  { (finished) -> Void in
                
                    // play pop sound
                    bubble.removeFromSuperview()
                    
                    let balloonData = NSDataAsset(name: "Balloon")
                    
                    let player = try?AVAudioPlayer(data: balloonData!.data)
                    
                    self.players.append(player!)
                    
                    player?.delegate = self
                    player?.play()
                }
            }
           
        }
        
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        guard let index = players.index(of: player) else { return }
        players.remove(at: index)
        
        print(players.count)
    }

}

