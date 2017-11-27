//
//  NewsRepository.swift
//  VKProfile
//
//  Created by Тимур Шафигуллин on 26.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import Foundation

class NewsRepository {
    
    @objc private var news = [News]()
    @objc var currentID = 1
    
    init() {
        let savedCurrentID = UserDefaults.standard.integer(forKey: #keyPath(NewsRepository.currentID))
        if (savedCurrentID != 0) {
            currentID = savedCurrentID
        }
        if let newsData = UserDefaults.standard.data(forKey: #keyPath(NewsRepository.news)) {
            news = News.unarchive(with: newsData) ?? [News]()
        }
    }
    
    func syncSave(with news: News) {
        news.id = currentID
        self.news.append(news)
        currentID += 1
        saveData()
    }
    
    func asyncSave(with news: News, completionBlock: @escaping (Bool) -> ()) {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.syncSave(with: news)
            completionBlock(true)
        }
    }
    
    func syncGetAll() -> [News] {
        return news
    }
    
    func asyncGetAll(completionBlock: @escaping ([News]) -> ()) {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.news)
        }
    }
    
    func syncSearch(id: Int) -> News? {
        return news.first(where: { $0.id == id })
    }
    
    func asyncSearch(id: Int, completionBlock: @escaping (News?) -> ()) {
        let operationQueue = OperationQueue()
        operationQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            completionBlock(strongSelf.syncSearch(id: id))
        }
    }
    
    private func saveData() {
        UserDefaults.standard.set(News.archive(news), forKey: #keyPath(NewsRepository.news))
        UserDefaults.standard.set(currentID, forKey: #keyPath(NewsRepository.currentID))
    }
    
}
