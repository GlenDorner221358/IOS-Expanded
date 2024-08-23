//
//  BioAuthManager.swift
//  bababooie
//
//  Created by student on 2024/08/02.
//

import Foundation
import LocalAuthentication //faceid & touchid

class BioAuthManager: ObservableObject {
    
    private var context = LAContext()
    private var canEvaluatePolicy = false
    
    @Published var biometricType: LABiometryType = .none
    
    init() {
        getBiometricType()
    }
    
    func getBiometricType(){
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        biometricType = context.biometryType
    }
    
    func authenticate() async {
        if(canEvaluatePolicy) {
            let reason = "Login with biometrics to keep data safe"
            
            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                
                if(success) {
                    print("successful authentication with biometrics")
                    
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                }
                
            } catch {
                print(error.localizedDescription)
                
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            }
        }
    }
    
}
