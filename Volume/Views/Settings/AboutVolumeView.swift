//
//  AboutVolumeView.swift
//  Volume
//
//  Created by Vin Bui on 4/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct AboutVolumeView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Constants
    private struct Constants {
        static let headerSpacing: CGFloat = 8
        static let memberFont: Font = .newYorkRegular(size: 16)
        static let missionFont: Font = .helveticaRegular(size: 16)
        static let navHeaderText: Font = .newYorkMedium(size: 20)
        static let sectionSpacing: CGFloat = 24
        static let semesterFont: Font = .newYorkMedium(size: 16)
        static let semesterSpacing: CGFloat = 40
        static let sidePadding: CGFloat = 24
        static let subteamFont: Font = .newYorkMedium(size: 20)
        static let teamSpacing: CGFloat = 8
    }
    
    // MARK: - UI
    
    var body: some View {
        List {
            Group {
                missionView
                teamView
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("About Volume")
                    .font(Constants.navHeaderText)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.volume.backArrow
                }
                .buttonStyle(EmptyButtonStyle())
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.volume.backgroundGray)
    }
    
    private var missionView: some View {
        Section {
            Text(AboutConstants.missionStatement)
                .font(Constants.missionFont)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, Constants.headerSpacing)
                .padding(.bottom, Constants.sectionSpacing)
        } header: {
            Header("Our Mission")
                .foregroundColor(Color.black)
        }
        .padding(.horizontal, Constants.sidePadding)
        .background(Color.volume.backgroundGray)
    }
    
    private var teamView: some View {
        Section {
            ForEach(AboutConstants.volumeRoster, id: \.self) { roster in
                VStack(alignment: .leading, spacing: 2 * Constants.teamSpacing) {
                    Text(roster.semester)
                        .font(Constants.semesterFont)
                    
                    subteamView(subteams: roster.subteams)
                }
                .padding(.bottom, Constants.semesterSpacing)
            }
            .padding(.top, Constants.headerSpacing)
        } header: {
            Header("The Team")
                .foregroundColor(Color.black)
        }
        .padding(.horizontal, Constants.sidePadding)
        .background(Color.volume.backgroundGray)
    }
    
    private func subteamView(subteams: [AboutConstants.Subteam]) -> some View {
        ForEach(subteams, id: \.self) { subteam in
            VStack(alignment: .leading, spacing: Constants.teamSpacing) {
                switch subteam {
                case .android(let members):
                    Text("Android")
                        .font(Constants.subteamFont)
                    
                    memberNamesView(names: members)
                case .backend(let members):
                    Text("Backend")
                        .font(Constants.subteamFont)
                    
                    memberNamesView(names: members)
                case .design(let members):
                    Text("Design")
                        .font(Constants.subteamFont)
                    
                    memberNamesView(names: members)
                case .ios(let members):
                    Text("iOS")
                        .font(Constants.subteamFont)
                    
                    memberNamesView(names: members)
                case .marketing(let members):
                    Text("Marketing")
                        .font(Constants.subteamFont)
                    
                    memberNamesView(names: members)
                case .podLead(let member):
                    Text("Pod Lead")
                        .font(Constants.subteamFont)
                    
                    Text(member)
                        .font(Constants.memberFont)
                }
            }
        }
    }
    
    private func memberNamesView(names: [String]) -> some View {
        Text(names.joined(separator: ", "))
            .font(Constants.memberFont)
            .fixedSize(horizontal: false, vertical: true)
    }
    
}

// MARK: - Uncomment below if needed

//struct AboutVolumeView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutVolumeView()
//    }
//}
