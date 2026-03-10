//
//  RickAndMortyEpisodeApp.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/6/26.
//

import SwiftUI

@main
struct RickAndMortyEpisodeApp: App {
    private let recordDataStorage = DataStorageManager()
    var body: some Scene {
        WindowGroup {
            RecordListView(viewModel: ListViewModel(recordService: recordDataStorage))
        }
    }
}
