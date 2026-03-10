//
//  DataStorageManager.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/6/26.
//

import Foundation
import SwiftData

// MARK: - DataStorageManager is responsible to handle API calling activity as well as persistance data storage.

public class DataStorageManager: APIServiceProtocol {
    private let apiServiceClient: APIServiceProvider
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    public init(apiServiceClient: APIServiceProvider = APIServiceProvider()) {
        self.apiServiceClient = apiServiceClient
        do {
            let schema = Schema([PersistanceRecords.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(
                for: schema, configurations: [modelConfiguration])
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    // MARK: - Get episode records from server through api Or persistance storage.
    // MARK: and returnarray of episode records to display.
    func getRecords() async throws -> [Results] {
        do {
            // Attempt to get server records first
            let serverRecords = try await apiServiceClient.getRecords()
            // Save server records to local staorage
            try await saveRecordsInLocalStorage(records: serverRecords)
            return serverRecords
        } catch {
            let localRecords = try await getPersistanceRecords()
            if localRecords.isEmpty {
                if let  serverError = error as? NetworkError {
                    throw serverError
                }
                throw NetworkError.persistenceError(error)
            }
            return localRecords
        }
    }
    // MARK: - Get episode records from persistance storage and return array of episode records if exists.
    func getPersistanceRecords() async throws -> [Results] {
        let fetchDescriptor = FetchDescriptor<PersistanceRecords>()
        do {
            let localRecords = try modelContext.fetch(fetchDescriptor)
            return localRecords.sorted(by: { $0.savedAt > $1.savedAt }).map { $0.convertpersistanceRecordsToAPIRecords()
            }
        } catch {
            throw NetworkError.persistenceError(error)
        }
    }
    // MARK: - Save API fetched episode records to local persistance database.
    func saveRecordsInLocalStorage(records: [Results]) async throws {
        for persistancerecords in records.map({ PersistanceRecords(from: $0) }) {
            modelContext.insert(persistancerecords)
        }
        do {
            try modelContext.save()
        } catch {
        throw NetworkError.persistenceError(error)
        }
    }
}
