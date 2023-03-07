//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class MemoDetailViewController: UIViewController, ViewModelBindableType {
  
  @IBOutlet weak var titleNavigationItem: UINavigationItem!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var deleteButton: UIBarButtonItem!
  @IBOutlet weak var editButton: UIBarButtonItem!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  
  var viewModel: MemoDetailViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func bindViewModel() {
    viewModel.title
      .drive(titleNavigationItem.rx.title)
      .disposed(by: rx.disposeBag)
    
    viewModel.contents
      .bind(to: tableView.rx.items) { (tableView, row, value) in
        switch row {
        case 0:
          let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell")!
          cell.textLabel?.text = value
          return cell
        case 1:
          let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell")!
          cell.textLabel?.text = value
          return cell
        default:
          fatalError("invaid cell")
        }
      }
      .disposed(by: rx.disposeBag)
    
    deleteButton.rx.action = viewModel.makeDeleteAction()
    
    editButton.rx.action = viewModel.makeEditAction()
    
    shareButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let memo = self?.viewModel.memo.content else { return }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        self?.present(vc, animated: true)
      })
      .disposed(by: rx.disposeBag)
  }
  
}


