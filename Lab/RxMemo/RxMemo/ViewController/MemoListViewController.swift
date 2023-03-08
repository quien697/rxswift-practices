//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx
import Foundation

@objcMembers
class MemoListViewController: UIViewController, ViewModelBindableType {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
  var viewModel: MemoListViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func bindViewModel() {
    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: rx.disposeBag)
    
    viewModel.memoList
      .bind(to: tableView.rx.items(cellIdentifier: "MemoCell")) { row, memo, cell in
        cell.textLabel?.text = memo.content
      }
      .disposed(by: rx.disposeBag)
    
    addButton.rx.action = viewModel.makeCreateAction()
    
    tableView.rx
      .modelSelected(Memo.self)
      .bind(to: viewModel.detailAction.inputs)
      .disposed(by: rx.disposeBag)
  }
  
}
