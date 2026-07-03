//
//  GameRepository.swift
//  Replay
//
//  Created by Anandhakrishnan on 30/06/26.
//

import CoreData

@MainActor
final class GameRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Fetch
    
    func fetchAll() throws -> [Game] {
        let request = GameEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GameEntity.dateAdded, ascending: false)]
        let entities = try context.fetch(request)
        return entities.map { $0.toDomain() }
    }
    
    func fetch(id: UUID) throws -> Game? {
        let request = GameEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first?.toDomain()
    }
    
    // MARK: - Create
    
    @discardableResult
    func create(title: String, coverURL: URL? = nil, platform: String? = nil, releaseDate: Date? = nil, igdbID: Int64? = nil) throws -> Game {
        let entity = GameEntity(context: context)
        entity.title = title
        entity.coverUrl = coverURL
        entity.platform = platform
        entity.releaseDate = releaseDate
        entity.igdbId = igdbID ?? 0
        
        try context.save()
        return entity.toDomain()
    }
    
    // MARK: - Delete
    
    func delete(id: UUID) throws {
        guard let entity = try fetchEntity(id: id) else { return }
        context.delete(entity)
        try context.save()
    }
    
    // MARK: - Update
    
    @discardableResult
    func update(_ game: Game) throws -> Game {
        guard let entity = try fetchEntity(id: game.id) else {
            throw RepositoryError.notFound
        }
        
        entity.title = game.title
        entity.coverUrl = game.coverURL
        entity.platform = game.platform
        entity.releaseDate = game.releaseDate
        entity.igdbId = game.igdbID ?? 0
        
        try context.save()
        return entity.toDomain()
    }
    
    // MARK: - Private helpers
    
    private func fetchEntity(id: UUID) throws -> GameEntity? {
        let request = GameEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
