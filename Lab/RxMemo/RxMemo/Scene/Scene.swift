//
//  Scene.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import UIKit

enum Scene {
  case list(MemoListViewModel)
  case detail(MemoDetailViewModel)
  case compose(MemoComposeViewModel)
}

extension Scene {
  func instantiate(from storyboard: String = "Main") -> UIViewController {
    let storyboard = UIStoryboard(name: storyboard, bundle: nil)
    
    switch self {
    case .list(let viewModel):
      guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
        fatalError("No List Navigation Controller")
      }
      
      guard var listVC = nav.viewControllers.first as? MemoListViewController else {
        fatalError("No MemoListViewController")
      }
      
      listVC.bind(viewModel: viewModel)
      return nav
    case .detail(let viewModel):
      guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
        fatalError("No MemoDetailViewController")
      }

      detailVC.bind(viewModel: viewModel)
      return detailVC
    case .compose(let viewModel):
      guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
        fatalError("No Compose Navigation Controller")
      }
      
      guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
        fatalError("No MemoComposeViewController")
      }
      
      composeVC.bind(viewModel: viewModel)
      return nav
    }
  }
}
