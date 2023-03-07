//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import NSObject_Rx


class MemoDetailViewModel: CommonViewModel {
  
  let memo: Memo
  var contents: BehaviorSubject<[String]>
  let bag = DisposeBag()
  
  init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, memo: Memo) {
    self.memo = memo
    self.contents = BehaviorSubject<[String]>(value: [
      memo.content ?? "",
      memo.insertDate?.formatted() ?? Date().formatted()
    ])
    
    super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
  }
  
  func performUpdate(memo: Memo) -> Action<String, Void> {
    return Action { input in
      self.storage.updateMemo(memo: memo, content: input)
        .subscribe(
          onNext: { updated in
            self.contents.onNext([
              updated.content ?? "",
              updated.insertDate?.formatted() ?? Date().formatted()
            ])
          }
        )
        .disposed(by: self.bag)
      return Observable.empty()
    }
  }
  
  func makeEditAction() -> CocoaAction {
    return CocoaAction { _ in
      let composeViewModel = MemoComposeViewModel(
        title: "Edit Memo",
        sceneCoordinator: self.sceneCoordinator,
        storage: self.storage,
        content: self.memo.content,
        saveAction: self.performUpdate(memo: self.memo)
      )
      let composeScene = Scene.compose(composeViewModel)
      return self.sceneCoordinator
        .transition(to: composeScene, using: .modal, animated: true)
        .asObservable().map { _ in }
    }
  }
  
  func makeDeleteAction() -> CocoaAction {
    return Action {
      self.storage.deleteMemo(memo: self.memo)
      return self.sceneCoordinator
        .close(animated: true)
        .asObservable().map { _ in }
    }
  }
  
}
