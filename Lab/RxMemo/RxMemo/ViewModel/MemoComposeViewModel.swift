//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoComposeViewModel: CommonViewModel {
  
  private let content: String?
  var initialText: Driver<String?> {
    return Observable.just(content)
      .asDriver(onErrorJustReturn: nil)
  }
  
  let saveAction: Action<String, Void>
  let cancelAction: CocoaAction
  
  init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, content: String? = nil, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
    self.content = content
    self.saveAction = Action<String, Void> { input in
      if let action = saveAction {
        action.execute(input)
      }
      return sceneCoordinator.close(animated: true).asObservable().map{ _ in }
    }
    self.cancelAction = CocoaAction {
      if let action = cancelAction {
        action.execute(())
      }
      return sceneCoordinator.close(animated: true).asObservable().map{ _ in }
    }
    
    super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
  }
  
}
