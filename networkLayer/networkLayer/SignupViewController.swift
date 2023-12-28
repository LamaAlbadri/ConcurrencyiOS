//
//  SignupViewController.swift
//  networkLayer
//
//  Created by Lama Albadri on 25/12/2023.
//

import Foundation
import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
      @IBOutlet weak var errorLabel: UILabel!
    var usernameAvailabilityWorkItem: DispatchWorkItem?
    let api: RepositoriesAPIProtocol = RepositoriesAPI()
    
    override func viewDidLoad() {
        errorLabel.text = "No a vaild userName"
        errorLabel.textColor = .red
        usernameTextField.delegate = self
    }
    
    func checkUsernameAvailability(username: String) {
         //[1] cancel() if we have any before DispatchWorkItem that's excute
         usernameAvailabilityWorkItem?.cancel()
         //[2] make dispatch work item
        // init a new DispatchWorkItem
         let workItem: DispatchWorkItem = DispatchWorkItem {
             
             self.api.getRepos(username: AuthonationProvider.shared.username) { [weak self] completion in
                 DispatchQueue.main.async {
                     self?.errorLabel.isHidden = false
                 }
             }
         }
        //[3] set the new DispatchWorkItem to the global one
        
         usernameAvailabilityWorkItem = workItem
        //[4] excute that workItem in global queue or background qeueu after 1 second
         DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1), execute: workItem)
     }
}


extension SignupViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorLabel.isHidden = true
        if textField == usernameTextField {
            checkUsernameAvailability(username: textField.text?.appending(string) ?? "")
        }
        return true
    }
}
