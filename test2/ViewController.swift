//
//  ViewController.swift
//  Accelerometer
//
//  Created by nir oren on 8/9/22.
//

import UIKit
import CoreMotion
import AudioToolbox



class ViewController: UIViewController {
    @IBOutlet weak var Gyrox: UILabel!
    @IBOutlet weak var Gyroz: UILabel!
    @IBOutlet weak var Gyroy: UILabel!
    
    
//    @IBOutlet weak var Accelx: UILabel!
//    @IBOutlet weak var Accely: UILabel!
//    @IBOutlet weak var Accelz: UILabel!
//
    @IBOutlet weak var ball: UIImageView!
    @IBOutlet weak var ball_shadow: UIImageView!
    
//    let screenSize =
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var motion = CMMotionManager()
    
    var positionX = 157.0
    var positionY = 140.0
    
    var currentPositionX = 157.0
    var currentPositionY = 140.0
    
    var initialSize = 100.0
    
    var upDownMaximum = 2000.0
    
    var upDownCounter = 0.0
    var ballSize = 0.0
    var shadowSize = 0.0
    
    var gyroMaximumX = 0.0
    var gyroMaximumY = 0.0
    
    var shadowHitZero = 0.0
    var shadowReleaseFrom =  -1.0
    
    var AccelZ = 0.0
    
    var sideCounter = 0.0
    
    var started = false
    var inAir = false
    var goingDown = false
    
    var max_x = 0.0
    
    // update every interval for gyro
    var GyroX = 0.0
    var GyroY = 0.0
    
    //update every throw- to move the ball
    var pitch = 0.0
    var roll = 0.0
    
    var sideDistance = 0.0
    var upDownDistance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyGyro()
        BallThrow()
        MyAccel()
//        RPY()
    }
    func MyGyro(){
        motion.gyroUpdateInterval = 0.5
        motion.startGyroUpdates(to: OperationQueue.current!){ (data,error) in
            if let trueData = data{
                self.Gyrox.text = "\(trueData.rotationRate.x)"
                self.Gyroy.text = "\(trueData.rotationRate.y)"
                self.Gyroz.text = "\(trueData.rotationRate.z)"
                self.GyroX = trueData.rotationRate.x
                self.GyroY = trueData.rotationRate.y
            }
        }
    }
    func MyAccel(){
        motion.accelerometerUpdateInterval = 0.02
        motion.startAccelerometerUpdates(to: OperationQueue.current!){ (data,error) in
            if let trueData = data{
                self.AccelZ = trueData.acceleration.z
                
            }
        }
    }
    func RPY(){
        motion.accelerometerUpdateInterval = 0.02
        self.ball.frame = CGRect(x: self.positionX, y: self.positionY, width: self.initialSize, height: self.initialSize)
        self.ball_shadow.frame = CGRect(x: self.positionX, y: self.positionY, width: self.initialSize, height: self.initialSize)
        motion.startDeviceMotionUpdates(to: OperationQueue.current!){ (data,error) in
            if let trueData = data{
                if(trueData.attitude.yaw > 0.2){
                    print("yaw: \(trueData.attitude.yaw)")
                }
                if(trueData.attitude.roll > 0.2){
                    print("roll: \(trueData.attitude.roll)")
                }
                if(trueData.attitude.pitch > 0.2){
                    print("pitch: \(trueData.attitude.pitch)")
                }
//                print("pitch: \(data?.attitude.pitch)")
//                print("roll: \(data?.attitude.roll)")
            }}
                //print(self.upDownCounter)
//                self.Accelx.text = "\(trueData.acceleration.x)"
//                self.Accely.text = "\(trueData.acceleration.y)"
//                self.Accelz.text = "\(trueData.acceleration.z)"
        
    
    }
    
    
    func CustomVirbate(counter : Double){
//        print("this: \(counter - self.initialSize)")
        if self.upDownMaximum - counter < 3.0{
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        else if self.upDownMaximum - counter < 5.0{
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        else if self.upDownMaximum - counter < 8.0{
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
   
    
    func BallThrow(){
        motion.accelerometerUpdateInterval = 0.02
        motion.deviceMotionUpdateInterval = 0.02
        self.ball.frame = CGRect(x: self.positionX, y: self.positionY, width: self.initialSize, height: self.initialSize)
        self.ball_shadow.frame = CGRect(x: self.positionX, y: self.positionY, width: self.initialSize, height: self.initialSize)
        motion.startDeviceMotionUpdates(to: OperationQueue.current!){ (data,error) in
            if let trueData = data{
                //print(self.upDownCounter)
//                self.Accelx.text = "\(trueData.acceleration.x)"
//                self.Accely.text = "\(trueData.acceleration.y)"
//                self.Accelz.text = "\(trueData.acceleration.z)"
                if (trueData.attitude.pitch > 0.5) && (!self.inAir) || (trueData.attitude.roll > 0.5) && (!self.inAir) || (trueData.attitude.pitch < -0.5) && (!self.inAir) || (trueData.attitude.roll < -0.5) && (!self.inAir){
                    print(self.AccelZ)
                    // INITIALIZING THROW
                    self.inAir = true
                    self.goingDown = false
                    self.ball.tintColor = .blue
                    self.upDownCounter = 0
                    self.pitch = trueData.attitude.pitch
                    self.roll = trueData.attitude.roll
                    
                    
                    
                    self.upDownMaximum = round(75.0 * trueData.attitude.pitch)
                    
                    if abs(trueData.attitude.pitch)>=abs(trueData.attitude.roll){
                        if (trueData.attitude.pitch > 0.5) && (!self.inAir) {
                            print("pitch")
                            self.upDownMaximum = abs(round(60.0 * trueData.attitude.pitch))
                            self.upDownDistance = self.pitch * -5.0
                            if (trueData.attitude.roll > 0.5) && (!self.inAir){
                                self.sideDistance = self.roll * -5.0
                            }
                            else{
                                self.sideDistance = self.roll * 5.0
                                
                            }
                        }
                        else{
                            print("pitch")
                            self.upDownMaximum = abs(round(60.0 * trueData.attitude.pitch))
                            self.upDownDistance = self.pitch * 5.0
                            if (trueData.attitude.roll > 0.5) && (!self.inAir){
                                self.sideDistance = self.roll * -5.0
                            }
                            else{
                                self.sideDistance = self.roll * 5.0
                                
                            }
                        }
                    }
                    else{
                        if (trueData.attitude.roll > 0.5) && (!self.inAir){
                            print("roll")
                            self.upDownMaximum = abs(round(60.0 * trueData.attitude.roll))
                            self.sideDistance = self.roll * -5.0
                            if (trueData.attitude.pitch > 0.5){
                                self.upDownDistance = self.pitch * -5.0
                            }
                            else{
                                self.upDownDistance = self.pitch * 5.0
                            }
                        }
                        else{
                            print("roll")
                            self.upDownMaximum = abs(round(60.0 * trueData.attitude.roll))
                            self.sideDistance = self.roll * 5.0
                            if (trueData.attitude.pitch > 0.5){
                                self.upDownDistance = self.pitch * -5.0
                            }
                            else{
                                self.upDownDistance = self.pitch * 5.0
                            }
                        }
                    }
                    
                    print("maximum: \(self.upDownMaximum), pitch: \(self.pitch), roll: \(self.roll), up: \(self.upDownDistance), side: \(self.sideDistance)")
                    print("positionX: \(self.ball.frame.origin.x), positionY: \(self.ball.frame.origin.y)")
                    self.max_x = (-self.upDownMaximum/2.0)
                    
                    
                    
                    
                    
                    
//                    print("X maximum:\((-1.0 * (self.max_x)*(self.max_x-self.upDownMaximum )+self.initialSize))")
                    
                    
                    
                }
                else if (self.inAir){
//                    if self.currentPositionX + self.sideDistance > 50.0 && self.ball.frame.origin.x < 270.0{
//                        //print("moving sideDistance: \(self.sideDistance)")
//                        self.currentPositionX = self.currentPositionX + self.sideDistance
//                    }
//                    if self.currentPositionY - self.upDownDistance > 50.0 && self.ball.frame.origin.y < 710.0{
//                        self.currentPositionY =  self.currentPositionY + self.upDownDistance
//                        //print("moving upDownDistance: \(self.upDownDistance)")
//                    }
                    
                    
                    if self.sideDistance > 0 && self.ball.frame.origin.x + self.sideDistance < 270.0{
                        //print("moving sideDistance: \(self.sideDistance)")
                        self.currentPositionX = self.currentPositionX + self.sideDistance
                    }
                    else if self.sideDistance <= 0 && self.ball.frame.origin.x + self.sideDistance > 50{
                        //print("moving sideDistance: \(self.sideDistance)")
                        self.currentPositionX = self.currentPositionX + self.sideDistance
                    }
                    if self.upDownDistance > 0.0 && self.ball.frame.origin.y < 710.0{
                        self.currentPositionY =  self.currentPositionY + self.upDownDistance
                        //print("moving upDownDistance: \(self.upDownDistance)")
                    }
                    if self.upDownDistance <= 0.0 && self.ball.frame.origin.y > 50.0{
                        self.currentPositionY =  self.currentPositionY + self.upDownDistance
                        //print("moving upDownDistance: \(self.upDownDistance)")
                    }
                    
                    
                    
//                    self.ballSize = -1.0 * (self.upDownCounter - sqrt(self.upDownMaximum))^2 + self.upDownMaximum + self.initialSize
                    self.ballSize = (-1.0 * (self.upDownCounter)*(self.upDownCounter-self.upDownMaximum )+self.initialSize)
                    self.shadowSize = (self.upDownCounter/5.0)*(self.upDownCounter-self.upDownMaximum)+self.initialSize
                    
                    self.ball.frame = CGRect(x: self.currentPositionX, y: self.currentPositionY, width: self.ballSize, height: self.ballSize)
                    
                    
                    
                    if self.shadowSize >= 0.0{
                        self.ball_shadow.frame = CGRect(x: self.currentPositionX, y: self.currentPositionY, width: self.shadowSize, height: self.shadowSize)}
                    else{
                        self.ball_shadow.frame = CGRect(x: self.currentPositionX, y: self.currentPositionY, width: 0, height: 0)
                    }
                    if self.upDownCounter > self.upDownMaximum / 2.0{
//                        print("NOW")
                        self.CustomVirbate(counter : self.upDownCounter)
                    }
                    
                    self.upDownCounter += 1
                    
                    if self.upDownCounter >= self.upDownMaximum{
//                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        self.inAir = false
                        self.upDownCounter = 0.0
                        self.ball.tintColor = .red
                        self.ball_shadow.frame = CGRect(x: self.currentPositionX, y: self.currentPositionY, width: (self.initialSize), height: (self.initialSize))
                        self.ball.frame = CGRect(x: self.currentPositionX, y: self.currentPositionY, width: (self.initialSize), height: (self.initialSize))
                    }
                }
                //self.trashIcon.tintColor = .red
                
            }
        }
        
    }

}


