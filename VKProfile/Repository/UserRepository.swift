//
//  UserRepository.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 30.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

class UserRepository {
    
    static let instance = UserRepository()
    
    private var users = [
        UserVK(name: "Тимур", surname: "Шафигуллин", email: "iOSDeveloper@icloud.com", phoneNumber: "+79172513599", age: 19, city: "Казань", password: "qwe")
    ]
    
    func register(_ user: UserVK) {
        users.append(user)
    }
    
    func check(with email: String, and password: String) -> Bool {
        return users.contains(where: { $0.email == email && $0.password == password })
    }
    
    func search(with email: String) -> UserVK? {
        return users.first(where: { $0.email == email })
    }
    
}
