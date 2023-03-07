//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by Quien on 2023/3/1.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class MemoComposeViewController: UIViewController, ViewModelBindableType {

  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var cancelButton: UIBarButtonItem!
  @IBOutlet weak var contentTextView: UITextView!
  
  var viewModel: MemoComposeViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    contentTextView.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    // if keyboard is shown, it will remove the keyboard
    if contentTextView.isFirstResponder {
      contentTextView.resignFirstResponder()
    }
  }
  
  func bindViewModel() {
    viewModel.title
      .drive(navigationItem.rx.title)
      .disposed(by: rx.disposeBag)
    
    viewModel.initialText
      .drive(contentTextView.rx.text)
      .disposed(by: rx.disposeBag)
    
    saveButton.rx.tap
      .throttle(.microseconds(500), scheduler: MainScheduler.instance)
      .withLatestFrom(contentTextView.rx.text.orEmpty)
      .bind(to: viewModel.saveAction.inputs)
      .disposed(by: rx.disposeBag)
    cancelButton.rx.action = viewModel.cancelAction
  }
  
}
