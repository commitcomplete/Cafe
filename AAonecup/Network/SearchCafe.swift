//
//  SearchCafe.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/27.
//

import Foundation
import UIKit
import RxSwift


//MARK: 네이버 검색 API를 이용한 버전 : 현재는 MAPKit으로 전환함

class  naverAPI {
    static var shared = naverAPI()
    let jsonDecoder: JSONDecoder = JSONDecoder()
    
    static func urlTaskDone() {
        let item = dataManager.shared.searchResult?.items[0]
    }
    
    static func findNearCafeAPIToNaver(queryValue: String , onComplete: @escaping (Result<Data, Error>) -> Void){
        //MARK: 네이버 검색API 사용시 사용했던 Key값
//        let clientID: String = client_ID
//        let clientKEY: String = client_Secret
        
        let query: String  = "https://openapi.naver.com/v1/search/local.json?query=\(queryValue)&display=5&sort=comment"
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
        var requestURL = URLRequest(url: queryURL)
//        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
//        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
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
        }.resume()
        
    }
    
    static func rxFindNearCafeAPItoNaver(query : String) -> Observable<Data>{
        return Observable.create { emitter in
            findNearCafeAPIToNaver(queryValue: query){result in
                switch result{
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(err):
                    emitter.onError(err)
                }
            }
            return Disposables.create()
        }
    }
}


