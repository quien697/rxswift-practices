//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import CoreData

class MemoListViewModel: CommonViewModel {
 
  var memoList: Observable<[Memo]> {
    return storage.listMemo()
  }
  
  func perfromUpdate(memo: Memo) -> Action<String, Void> {
    return Action { input in
      return self.storage
        .updateMemo(memo: memo, content: input)
        .map { _ in }
    }
  }
  
  func perfromCancel(memo: Memo) -> CocoaAction {
    return Action {
      return self.storage
        .deleteMemo(memo: memo)
        .map { _ in }
    }
  }
  
  func makeCreateAction() -> CocoaAction {
    return CocoaAction { _ in
      return self.storage.createMemo(content: "")
        .flatMap { memo -> Observable<Void> in
          // actions -> Cancel, Update
          let composeViewModel = MemoComposeViewModel(title: "New Memo", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.perfromUpdate(memo: memo), cancelAction: self.perfromCancel(memo: memo))
          let composeScene = Scene.compose(composeViewModel)
          return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true) .asObservable().map { _ in }
        }
    }
  }
  
  lazy var detailAction: Action<Memo, Void> = {
    return Action { memo in
      let detailViewModel = MemoDetailViewModel(title: "View Memo", sceneCoordinator: self.sceneCoordinator, storage: self.storage, memo: memo)
      let detailScene = Scene.detail(detailViewModel)
      return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true) .asObservable().map { _ in }
    }
  }()
  
}
