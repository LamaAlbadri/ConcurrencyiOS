//
//  ViewController.swift
//  networkLayer
//
//  Created by Lama Albadri on 27/06/2022.
//

import UIKit

class ViewController: UIViewController {

    
    let api: RepositoriesAPIProtocol = RepositoriesAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api.getRepos(username: AuthonationProvider.shared.username) { (result) in
                 switch result {
                 case .success(let sucess):
                     print(sucess)
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
             }
    }


}

