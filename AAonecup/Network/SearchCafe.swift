//
//  SearchCafe.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/27.
//

import Foundation
import UIKit
import RxSwift

class LoadSEARCHnewsAPI {
    
    static var shared = LoadSEARCHnewsAPI()
    
    let jsconDecoder: JSONDecoder = JSONDecoder()

    func urlTaskDone() {
        let item = dataManager.shared.searchResult?.items[0]
        print(dataManager.shared.searchResult)
    }
    
    func requestAPIToNaver(queryValue: String) {
        
        let clientID: String = client_ID
        let clientKEY: String = client_Secret
        
        let query: String  = "https://openapi.naver.com/v1/search/local.json?query=\(queryValue)&display=5&sort=comment"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
       
        var requestURL = URLRequest(url: queryURL)
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else { print(error); return }
            guard let data = data else { print(error); return }
            
            do {
                let searchInfo: Cafe = try self.jsconDecoder.decode(Cafe.self, from: data)
                dataManager.shared.searchResult = searchInfo
                self.urlTaskDone()
            } catch {
                print(fatalError())
            }
        }
        task.resume()
    }
    
}
