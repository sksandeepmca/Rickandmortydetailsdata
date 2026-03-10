//
//  ListViewModel.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/6/26.
//

import Foundation
import SwiftUI
import Combine
// MARK: - enum to handle view state and API response success and failure state.
enum ViewState {
    case loading
    case success([Results])
    case error(String)
}
@MainActor
public class ListViewModel: ObservableObject {
@Published var state: ViewState = .loading
@Published var records: [Results] = []
// Service interface as dependancy instead of hard coded for better testability  or reuseability
private let recordService: APIServiceProtocol
init(recordService: APIServiceProtocol) {
self.recordService = recordService
    }
// MARK: - Get records from server if its return nil we will try to fetch records from persistance storage.
public func getRecords(isRefresh: Bool = false) async {
        if !isRefresh {
            state = .loading
        }
        do {
            let getRecords = try await recordService.getRecords()
            self.records = getRecords
            self.state = .success(getRecords)
        } catch {
            print("Failed fetching Records: \(error)")
            // Fallback to local if possible already handled in JobRepository,
            // but if that fails too, show an error.
            if let serviceError = error as? NetworkError {
                self.state = .error(serviceError.localizedDescription)
            } else {
                self.state = .error("An unexpected error occurred.")
            }
            // Get persistance records from local database if exists otherwise throw error
            do {
                let persistanceRecords = try await recordService.getPersistanceRecords()
                if !persistanceRecords.isEmpty {
                    self.records = persistanceRecords
                    self.state = .success(persistanceRecords)}
            } catch {
                print("Failed fetching persistance Records: \(error)")
                if let serviceError = error as? NetworkError {
                    self.state = .error(serviceError.localizedDescription)
                } else {
                    self.state = .error("An unexpected error occurred.")
                }}}}}
