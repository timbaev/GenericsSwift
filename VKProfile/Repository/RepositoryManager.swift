//
//  RepositoryManager.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 27.11.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation


class RepositoryManager: Repository {
    
    func syncSave<T>(with object: T) where T : Storable {
        object.id = Int(arc4random())
        let objectName = NSStringFromClass(T.self)
        if var objects: [T] = getData(key: objectName) {
            objects.append(object)
            saveData(array: objects, key: objectName)
        } else {
            saveData(array: [object], key: objectName)
        }
    }
    
    func asyncSave<T>(with object: T, completionBlock: @escaping (Bool) -> ()) where T : Storable {
        OperationQueue().addOperation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.syncSave(with: object)
            completionBlock(true)
        }
    }
    
    func syncGetAll<T>() -> [T] where T : Storable {
        let objectName = NSStringFromClass(T.self)
        return getData(key: objectName) ?? [T]()
    }
    
    func asyncGetAll<T>(completionBlock: @escaping ([T]) -> ()) where T : Storable {
        OperationQueue().addOperation { [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.syncGetAll())
        }
    }
    
    func syncSearch<T>(id: Int, type: T.Type) -> T? where T : Storable {
        let objectName = NSStringFromClass(type)
        let objects = getData(key: objectName) ?? [T]()
        if objects.isEmpty {
            return nil
        }
        return objects.first(where: { $0.id == id })
    }
    
    func asyncSearch<T>(id: Int, type: T.Type, completionBlock: @escaping (T?) -> ()) where T : Storable {
        OperationQueue().addOperation { [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.syncSearch(id: id, type: type))
        }
    }
    
    private func saveData<T: Storable>(array: [T], key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: array)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    private func getData<T>(key: String) -> [T]? where T: Storable {
        if let data = UserDefaults.standard.data(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [T]
        }
        return nil
    }

}
