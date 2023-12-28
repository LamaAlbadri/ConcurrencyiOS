//
//  Task.swift
//  networkLayer
//
//  Created by Lama Albadri on 27/06/2022.
//

import Foundation
import Alamofire

//enum Task with two cases one for the requests with parameters and one without.
enum Task {
    
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}
