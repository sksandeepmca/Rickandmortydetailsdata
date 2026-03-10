//
//  RecordListView.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/7/26.
//

import SwiftUI
// MARK: - View to handle episode records in list view with error handling and retry api calling option
public struct RecordListView: View {
    @StateObject private var viewModel: ListViewModel
    public init(viewModel: ListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    public var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView("Fetching Records...")
                        .controlSize(.regular)
                        .tint(.black)
                case .error(let message):
                    VStack(spacing: 24) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 32))
                            .foregroundColor(.orange)
                        Text(message)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Retry") {
                            Task {
                                await viewModel.getRecords()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                case .success(let records):
                    if records.isEmpty {
                        ContentUnavailableView(
                            "No Records Found", systemImage: "briefcase",
                            description: Text("pull to refresh."))
                    } else {
                        List(records) { record in
                            NavigationLink(destination: RecordListViewDetail(record: record)) {
                                JobRowView(record: record)
                            }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewModel.getRecords(isRefresh: true)
                        }
                    }
                }
            }
            .onAppear {
                if case .loading = viewModel.state {
                    Task {
                        await viewModel.getRecords()
                    }
                }
            }
            .navigationTitle("Episode Records")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - jobRowView is handling list row with episode records fields like image,name,status etc.

struct JobRowView: View {
    let record: Results
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: record.image ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "building.2")
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 4) {
                Text(record.name ?? "")
                    .font(.headline)
                    .lineLimit(2)
                Text(record.status ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
