//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import Foundation
import RxSwift

// Responsibility: Scene Transition (Window, CurrentVC)
class SceneCoordinator: SceneCoordinatorType {
  
  private var window: UIWindow
  private var currentVC: UIViewController {
    didSet {
      window.rootViewController = currentVC
    }
  }
  
  init(window: UIWindow) {
    self.window = window
    self.currentVC = window.rootViewController!
  }
  
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
    let subject = PublishSubject<Void>()
    let target = scene.instantiate()
    
    switch style {
    case .root:
      currentVC = target
      subject.onCompleted()
    case .push:
      guard let nav = currentVC.navigationController else {
        subject.onError(TransitionError.navitationControllerMissing)
        break
      }
      
      nav.pushViewController(target, animated: animated)
      currentVC = target
      subject.onCompleted()
    case .modal:
      currentVC.present(target, animated: animated) {
        subject.onCompleted()
      }
      currentVC = target
    }
    return subject.ignoreElements().asCompletable()
  }
  
  @discardableResult
  func close(animated: Bool) -> Completable {
    return Completable.create { [unowned self] completable in
      if let presentingVC = self.currentVC.presentingViewController {
        self.currentVC.dismiss(animated: animated) {
          self.currentVC = presentingVC
          completable(.completed)
        }
      } else if let nav = self.currentVC.navigationController {
        if nav.popViewController(animated: animated) == nil {
          completable(.error(TransitionError.cannotPop))
          return Disposables.create()
        }
        self.currentVC = nav.viewControllers.last!
        completable(.completed)
      } else {
        completable(.error(TransitionError.unknown))
      }
      return Disposables.create()
    }
  }
}
