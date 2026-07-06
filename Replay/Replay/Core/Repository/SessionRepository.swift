//
//  SessionRepository.swift
//  Replay
//
//  Created by Anandhakrishnan on 03/07/26.
//

import CoreData

@MainActor
final class SessionRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Fetch
    
    func fetchAll(for gameID: UUID) throws -> [Session] {
        let request = SessionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "game.id == %@", gameID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SessionEntity.date, ascending: false)]
        let entities = try context.fetch(request)
        return entities.map { $0.toDomain() }
    }
    
    func fetch(id: UUID) throws -> Session? {
        let request = SessionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first?.toDomain()
    }
    
    // MARK: - Create
    
    @discardableResult
    func create(
        gameID: UUID,
        mood: Mood,
        note: String? = nil,
        durationMinutes: Int? = nil,
        date: Date = .now
    ) throws -> Session {
        guard let gameEntity = try fetchGameEntity(id: gameID) else {
            throw RepositoryError.notFound
        }
        
        let entity = SessionEntity(context: context)
        entity.mood = mood.rawValue
        entity.note = note
        entity.durationMinutes = Int32(durationMinutes ?? 0)
        entity.date = date
        entity.game = gameEntity
        
        try context.save()
        return entity.toDomain()
    }
    
    // MARK: - Update
    
    @discardableResult
    func update(_ session: Session) throws -> Session {
        guard let entity = try fetchEntity(id: session.id) else {
            throw RepositoryError.notFound
        }
        
        entity.mood = session.mood.rawValue
        entity.note = session.note
        entity.durationMinutes = Int32(session.durationMinutes ?? 0)
        entity.date = session.date
        
        try context.save()
        return entity.toDomain()
    }
    
    // MARK: - Delete
    
    func delete(id: UUID) throws {
        guard let entity = try fetchEntity(id: id) else { return }
        context.delete(entity)
        try context.save()
    }
    
    // MARK: - Private helpers
    
    private func fetchEntity(id: UUID) throws -> SessionEntity? {
        let request = SessionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchGameEntity(id: UUID) throws -> GameEntity? {
        let request = GameEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
