//
//  FindCafeViewModel.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay


class FindCafeViewModel{
    lazy var nameObservable = PublishSubject<Joke>()
    lazy var cafeListObservable = PublishSubject<[Item]>()
    lazy var firstJoke = nameObservable.map{
        $0.value
    }
    .map{"\($0 ?? "firstjoke")"}
    lazy var firstJokeurl = nameObservable.map{
        $0.url
    }.map{"\($0 ?? "firstjokeurl")"}
    
    func onTapButton(){
        APIService.fetchAllMenusRx()
            .map{ data -> Joke in
                let response = try! JSONDecoder().decode(Joke.self,from: data)
                return response
            }
            .subscribe(onNext: {
                self.nameObservable.onNext($0)
            })
        
    }
    
    func getCafeList(query : String){
        var itemArray = PublishSubject<[Item]>()
        naverAPI.rxFindNearCafeAPItoNaver(query: query)
            .map{ data -> Cafe in
                let response = try! JSONDecoder().decode(Cafe.self, from: data)
//                print(response.items.last?.title)
                return response
            }
            .subscribe(onNext: {
//                print("도착")
                self.cafeListObservable.onNext($0.items)
//                print("\($0.items.last?.title)")
            })
        
    }
    
}
