//
//  NetworkManager.swift
//  ios_assignment
//
//  Created by Shubham Kushwaha on 07/01/23.
//

import Foundation

import Foundation
import Alamofire

class Services {
    
    func fetchDataFromServer(endPoint: String,  onSuccess:(@escaping (Response)->()), onFailure:(@escaping (String)->())) {
        Alamofire.request(endPoint, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: nil).responseData {
            response in
            switch response.result {
            case .success:
                if let json = response.data{
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: json)
                        onSuccess(res)
                        print(res)
                    }
                    catch {
                        onFailure("failed")
                    }
                }
                break
            case .failure:
                onFailure("something went wrong")
                
            }
        }
    }
    
    
}
