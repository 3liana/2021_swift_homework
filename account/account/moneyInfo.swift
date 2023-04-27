
//  moneyInfo.swift
//  熟悉storyboard
//
//  Created by eliana on 2022/11/2.
//

import Foundation
import UIKit
import CoreData
class MoneyInfo{
    var moneyCollection: [NSManagedObject] = []
    //NSManagedObject大概可以等同于coredata里面的一个类？
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()//定义容器
    func saveMoney() -> Bool {//方法：保存
        
        let managedContext = persistentContainer.viewContext
        
        if managedContext.hasChanges{
            do {
                try managedContext.save()
            } catch  {
                let nsError = error as NSError
                print("Error in saving data!", nsError.localizedDescription)
            }
        }
        
        return true
    }
    init() {//初始化
        
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Money")
        
        do {
            
            moneyCollection = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
        
    }
    func addMoney(num:Int, summary:String) -> Money {//添加
        
        let managedContext = persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Money", in: managedContext)!
        
        let theMoney = NSManagedObject(entity: entity, insertInto: managedContext)
        
        theMoney.setValue(num, forKey: "num")
        theMoney.setValue(summary, forKey: "summary")
        //定义一个theMoney把值填进去，然后添加进moneycollection这个数组里面
        moneyCollection.append(theMoney)
        
        return theMoney as! Money//返回一个Money类型的值
        
    }
    func deleteMoney(_ theMoney: Money) {
        
        if let theIndex = moneyCollection.firstIndex(of: theMoney) {
        
            moneyCollection.remove(at: theIndex)
            
            let managedContext = persistentContainer.viewContext

            managedContext.delete(theMoney)
            
        }
        
    }
    func transferPosition(sourceIndex: Int, destinationIndex: Int) {
        
        if sourceIndex != destinationIndex {
            
            let theMoney = moneyCollection[sourceIndex]
            
            moneyCollection.remove(at: sourceIndex)
            
            moneyCollection.insert(theMoney, at: destinationIndex)
            
        }
        
        return
        
    }

}

