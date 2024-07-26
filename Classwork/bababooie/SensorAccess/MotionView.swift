//
//  MotionView.swift
//  class-demo
//
//  Created by OW on 2024/07/17.
//

import SwiftUI
import Charts

import CoreMotion //this is our framework that we import

struct MotionView: View {
    
    //pitch, roll & rotate state variables
    @State var pitch: Double = 0.00
    @State var roll: Double = 0.00
    @State var rotate: Double = 0.00
    
    @State var isTracking: Bool = false
    
    
    //motion view values
    var motionManager = CMMotionManager()
    var que = OperationQueue()
    
    //running motion detection
    func startTrackingMotion(){
        
        motionManager.deviceMotionUpdateInterval = 3
        
        motionManager.startDeviceMotionUpdates(to: self.que) { (data: CMDeviceMotion?, error: Error?) in
            
            //attitude => the orientation of our device
            let attitude: CMAttitude = data!.attitude
 
            print("Pitch: \(attitude.pitch)") //y
            print("Roll: \(attitude.roll)") //x
            print("Rotation: \(attitude.rotationMatrix)") //z
            
            pitch = Double(attitude.pitch)
            roll = Double(attitude.roll)
            rotate = Double(attitude.rotationMatrix.m11)
            
            isTracking = true
        }
        
    }
    
    //stopping motion detection
    func stopTrackingMotion(){
        motionManager.stopDeviceMotionUpdates()
        isTracking = false
    }
    
    
    var body: some View {
        
        VStack {
            if(isTracking) {
                Button(action: {
                    stopTrackingMotion()
                }, label: {
                    Text("Stop")
                }).padding()
            } else {
                Button(action: {
                    startTrackingMotion()
                }, label: {
                    Text("Start Tracking Motion")
                }).padding()
            }
            
            Text("X: \(roll)")
            Text("Y: \(pitch)")
            Text("Z: \(rotate)")
            
            
            
            Chart {
                
                PointMark(x: .value("Roll", roll), y: .value("Roll", 0.00)).foregroundStyle(.red)
                PointMark(x: .value("Pitch", 0), y: .value("Pitch", pitch)).foregroundStyle(.blue)
                PointMark(x: .value("Rotate", 0), y: .value("Rotate", rotate)).foregroundStyle(.green)
                
            }
            
        }
    }
}

#Preview {
    MotionView()
}
