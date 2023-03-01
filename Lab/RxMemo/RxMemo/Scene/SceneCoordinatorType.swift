//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
  @discardableResult
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool ) -> Completable
  
  @discardableResult
  func close(animated: Bool) -> Completable
}
