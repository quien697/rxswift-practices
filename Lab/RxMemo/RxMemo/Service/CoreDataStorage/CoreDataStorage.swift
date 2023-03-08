//
//  CoreDataStorage.swift
//  RxMemo
//
//  Created by Quien on 2023/3/7.
//

import Foundation
import CoreData
import RxSwift
import RxCoreData

class CoreDataStorage: MemoStorageType {
  
  // Reference to managed object context
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  
  func createMemo(content: String) -> RxSwift.Observable<Memo> {
    let memo = Memo(context: context)
    let insertDate = Date()
    memo.insertDate = insertDate
    memo.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    do {
      try self.context.save()
      return Observable.just(memo)
    } catch {
      return Observable.error(error)
    }
  }
  
  func listMemo() -> RxSwift.Observable<[Memo]> {
    let request = Memo.fetchRequest() as NSFetchRequest
    // Set the Sortoing on the request
    let sort = NSSortDescriptor(key: "identity", ascending: true)
    request.sortDescriptors = [sort]
    
    return context.rx
      .entities(fetchRequest: request)
      .asObservable()
  }
  
  
  func updateMemo(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
    let updatedMemo = Memo(context: context)
    updatedMemo.content = content
    updatedMemo.insertDate = memo.insertDate
    updatedMemo.identity = memo.identity
    
    do {
      context.delete(memo)
      try context.save()
      return Observable.just(updatedMemo)
    } catch {
      return Observable.error(error)
    }
  }
  
  func deleteMemo(memo: Memo) -> RxSwift.Observable<Memo> {
    do {
      context.delete(memo)
      try context.save()
      return Observable.just(memo)
    } catch {
      return Observable.error(error)
    }
  }
  
}
