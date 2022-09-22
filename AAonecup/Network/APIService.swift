//
//  APIService.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/21.
//

import Foundation
import RxSwift

let MenuUrl = "https://api.chucknorris.io/jokes/random"

class APIService {
    static func fetchAllMenus(onComplete: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: MenuUrl)!) { data, res, err in
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
    
    static func fetchAllMenusRx() -> Observable<Data>{
        return Observable.create{emitter in
            fetchAllMenus{result in
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
