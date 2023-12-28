//
//  RepositoriesNetworking.swift
//  networkLayer
//
//  Created by Lama Albadri on 27/06/2022.
//

import Foundation
import Alamofire

enum RepositoriesNetworking {
    case getRepos(username: String)
}

extension RepositoriesNetworking: TargetType {
    var baseURL: String {
        switch self {
        default:
            return Constant.Server.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .getRepos(let username):
            return "/users/\(username)/repos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRepos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getRepos:
            return .requestPlain // use requestPlain beaucse i don't need any parameter if i want to use parameter i'll use .requestParameters and pass them
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return [:]
        }
    }
    
}
