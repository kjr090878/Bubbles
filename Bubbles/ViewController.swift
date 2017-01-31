//
//  ViewController.swift
//  Bubbles
//
//  Created by Kelly Robinson on 11/9/15.
//  Copyright © 2015 Kelly Robinson. All rights reserved.
//

import UIKit

import AVFoundation


class ViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate {
    
    var session = AVCaptureSession()
    var players: [AVAudioPlayer] = []
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)
    var captureInput : AVCaptureDeviceInput?
    var captureOutput : AVCaptureAudioDataOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureInput = try? AVCaptureDeviceInput(device: captureDevice)
      
        if session.canAddInput(captureInput) {
      
        session.addInput(captureInput)
        
        }
        
        captureOutput = AVCaptureAudioDataOutput()
        
        if session.canAddOutput(captureOutput) {
            
            session.addOutput(captureOutput)
            
        }
        
        captureOutput?.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .background))
        
        NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: nil) { n in
            
            self.players = []
            for s in self.view.subviews { s.removeFromSuperview() }
            self.session.stopRunning()
            
        }
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { n in
            
            self.session.startRunning()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
         session.startRunning()
        
        let alertController = UIAlertController(title: "Instructions", message: "Blow into microphone to produce bubbles.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
       
        
        guard let channel = connection.audioChannels.first as? AVCaptureAudioChannel else { return }

        print("APL : \(channel.averagePowerLevel) PHL : \(channel.peakHoldLevel)")
        
        if channel.averagePowerLevel > -5 {
            
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
             
            
            let randomDuration = Double(abs(channel.averagePowerLevel))
                
                let randomX = CGFloat(arc4random_uniform(UInt32(self.view.frame.maxX)))
                
                let randomY = CGFloat(arc4random_uniform(UInt32(self.view.frame.midY)))
            
            UIView.animate(withDuration: randomDuration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                
                
                
                // randomize the bubble.center x & y
                bubble.center.y = randomY
                bubble.center.x = randomX
                
                })  { (finished) -> Void in
                
                    // play pop sound
                    bubble.removeFromSuperview()
                    
                    guard let balloonData = NSDataAsset(name: "Balloon") else { return }
                    guard let player = try? AVAudioPlayer(data: balloonData.data) else { return }
                    
                    self.players.append(player)
                    
                    player.delegate = self
                    player.play()
                    
                }
                
            }
           
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        guard let index = players.index(of: player) else { return }
        players.remove(at: index)
        
        print(players.count)
        
    }
    
    deinit {
        print("Cleaned up ")
    }

}

