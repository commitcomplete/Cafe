//
//  SearchCafe.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/27.
//

import Foundation
import UIKit
import RxSwift

class  naverAPI {
    
    static var shared = naverAPI()
    
    let jsonDecoder: JSONDecoder = JSONDecoder()

    static func urlTaskDone() {
        let item = dataManager.shared.searchResult?.items[0]
        print(dataManager.shared.searchResult)
    }
    
    static func findNearCafeAPIToNaver(queryValue: String , onComplete: @escaping (Result<Data, Error>) -> Void){
        
        let clientID: String = client_ID
        let clientKEY: String = client_Secret
        
        let query: String  = "https://openapi.naver.com/v1/search/local.json?query=\(queryValue)&display=5&sort=random"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        var requestURL = URLRequest(url: queryURL)
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode,
                                            userInfo: nil)))
                return
            }
            onComplete(.success(data))
            
            
            
//            do {
//                searchInfo = try shared.jsonDecoder.decode(Cafe.self, from: data)
//                dataManager.shared.searchResult = searchInfo
//
//                self.urlTaskDone()
//            } catch {
//                print(fatalError())
//
//            }
        }.resume()
        
    }
    
    static func rxFindNearCafeAPItoNaver(query : String) -> Observable<Data>{
        return Observable.create { emitter in
            findNearCafeAPIToNaver(queryValue: query){result in
                     switch result{
                     case let .success(data):
                         print("rx 도착")
                         emitter.onNext(data)
                         emitter.onCompleted()
                     case let .failure(err):
                         print("실패")
                         emitter.onError(err)
                     }
                }
            return Disposables.create()
            }
        }
    }
    

