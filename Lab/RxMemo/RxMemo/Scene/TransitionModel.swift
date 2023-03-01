//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import Foundation

enum TransitionStyle {
  case root
  case push
  case modal
}

enum TransitionError: Error {
  case navitationControllerMissing
  case cannotPop
  case unknown
}
