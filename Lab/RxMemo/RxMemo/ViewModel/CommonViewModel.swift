//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Quien on 2023/3/2.
//

import Foundation
import RxSwift
import RxCocoa

// For all ViewModel need
class CommonViewModel {
  
  // Using Driver to bind with nav title
  let title: Driver<String>
  
  // Protocol - Easy to change dependencies
  let sceneCoordinator: SceneCoordinatorType
  let storage: MemoStorageType
  
  init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
    self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
    self.sceneCoordinator = sceneCoordinator
    self.storage = storage
  }
  
}
