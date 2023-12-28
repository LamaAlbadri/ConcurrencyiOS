//
//  RepositoriesAPI.swift
//  networkLayer
//
//  Created by Lama Albadri on 27/06/2022.
//

import Foundation
import Alamofire

protocol RepositoriesAPIProtocol {
    func getRepos(username: String, completionHandler: @escaping (Result<[Repository], NSError>) -> Void)
}


class RepositoriesAPI: BaseAPI<RepositoriesNetworking>, RepositoriesAPIProtocol {
    
    func getRepos(username: String, completionHandler: @escaping (Result<[Repository], NSError>) -> Void) {
        self.fetchData(target: .getRepos(username: username), responseClass: [Repository].self) { (result) in
            DispatchQueue.global().asyncAfter(deadline: .now()+5, execute: {
                completionHandler(result)
            })
//            completionHandler(result)
        }
    }
    
}
