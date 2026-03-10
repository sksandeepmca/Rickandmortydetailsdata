//
//  RecordListViewDetail.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/7/26.
//

import SwiftUI

// MARK: - Recordlistviewdetails is handled view when user click on listview
// MARK: - and show further details of episode records.
public struct RecordListViewDetail: View {
    public let record: Results
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    public  var body: some View {
            HStack(alignment: .top, spacing: 16) {
                AsyncImage(url: URL(string: record.image ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo.on.rectangle")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 8) {
                    Text(record.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(record.status ?? "")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            Divider()
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                Detailinfo(
                    title: "Name", value: record.name ?? "NA")
                Detailinfo(title: "Status", value: record.status ?? "NA")
                Detailinfo(title: "species", value: record.species ?? "NA")
                Detailinfo(title: "type", value: record.type ?? "NA")
                Detailinfo(title: "gender", value: record.gender ?? "NA")
                Detailinfo(title: "url", value: record.url ?? "NA")
                Detailinfo(title: "episode count", value: "\(record.episode?.count ?? 0)")
            }
        .padding(.horizontal)
        .navigationTitle("Episode Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct Detailinfo: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            Spacer()
        }
    }
}
