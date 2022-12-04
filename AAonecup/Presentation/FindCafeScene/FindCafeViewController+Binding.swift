//
//  FindViewController+Binding.swift
//  AAonecup
//
//  Created by dohankim on 2022/11/22.
//

import UIKit
import RxSwift


extension FindCafeViewController{
    // MARK: Binding
    func bindingObject() {
        viewModel.cafeListObservable
            .observe(on: MainScheduler.instance)
            .bind(to: cafeTableView.rx.items(cellIdentifier: cellId, cellType: CafeTableViewCell.self)) {
                index, item, cell in
                cell.cafeNameLabel.text = item.cafeName
                    .replacingOccurrences(of: "<b>", with:" ")
                    .replacingOccurrences(of: "</b>", with:" ")
                cell.cafeAddressLabel.text = item.cafeAddress
                cell.cafeDistance.text = "\(Double(item.distance).prettyDistance)"
            }
            .disposed(by: disposeBag)
        
        viewModel.isSearchLimitTimeIsOver
            .subscribe { remainSecond in
                DispatchQueue.main.async {
                    if remainSecond.element ?? 60 == 0{
                        UIView.animate(withDuration: 0.6) {
                            self.cafeFindButton.setTitle(" 재탐색하기", for: .normal)
                            self.cafeFindButton.isEnabled = true
                            self.cafeFindButton.backgroundColor = UIColor(named: "Brown")
                            self.cafeFindButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
                            self.cafeFindButton.tintColor = .white
                            
                        }
                    }
                    else{
                        UIView.animate(withDuration: 0.6) {
                            self.cafeFindButton.setTitle(" 카페 찾기 \(remainSecond.element ?? 60)초", for: .normal)
                            self.cafeFindButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
                        }
                    }
                }
            }
        
        cafeTableView.rx.modelSelected(CafeInfo.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {item in
                self.pushNavi(route: item.route, coords: item.coords,cafeName: item.cafeName,address: item.cafeAddress,distance: item.distance)
            })
            .disposed(by: disposeBag)
        
        cafeTableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { index in
                self.cafeTableView.deselectRow(at: index, animated: true)
            }
        viewModel.isProgressAnimationContinue.bind{
            if $0{
                self.progressAnimationtimer?.invalidate()
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.6) {
                        self.cafeTableView.alpha = 1.0
                        self.coffeeImageView.alpha = 0.3
                        self.cafeFindButton.backgroundColor = UIColor(named: "disableColor")
                        self.cafeFindButton.tintColor = UIColor(named: "disableTextColor")
                        self.scrollToTop()
                    }
                    self.viewModel.limitSearchTime(inputSeconds: 60)
                }
            }
        }
        
        viewModel.isProgressOutOfTime.bind  {
            if $0{
                self.progressAnimationtimer?.invalidate()
                self.viewModel.cafeListObservable.onNext([CafeInfo]())
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.6) {
                        self.cafeTableView.alpha = 1.0
                        self.coffeeImageView.alpha = 0.3
                        self.cafeFindButton.backgroundColor = UIColor(named: "disableColor")
                        self.cafeFindButton.setTitleColor(UIColor(named: "disableTextColor"), for: .disabled)
                    }
                    self.mainTitle.text = "No Cafe!"
                    self.mainTitle.alpha = 1.0
                    self.viewModel.limitSearchTime(inputSeconds: 60)
                }
            }
        }
    }
}
