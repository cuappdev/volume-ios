//
//  SettingsView.swift
//  Volume
//
//  Created by Vin Bui on 4/24/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Constants
    
    private struct Constants {
        static let font: Font = .newYorkRegular(size: 16)
        static let imageSize: CGSize = CGSize(width: 24, height: 24)
        static let navHeaderText: Font = .newYorkMedium(size: 20)
        static let sidePadding: CGFloat = 24
        static let textLeftPadding: CGFloat = 16
        static let topPadding: CGFloat = 24
        static let vertSpacing: CGFloat = 32
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack(spacing: Constants.vertSpacing) {
            settingsRowDestination(image: Image.volume.info, label: "About Volume", destination: .internalView(.aboutUs(AboutVolumeView())))
            
            settingsRowDestination(image: Image.volume.flag, label: "Send feedback", destination: .externalLink(Secrets.feedbackForm))
            
            settingsRowDestination(image: Image.volume.link, label: "Visit our website", destination: .externalLink(Secrets.appdevWebsite))
            
            settingsRowDestination(image: Image.volume.lock, label: "Organization login", destination: .internalView(.organizationLogin(OrgsLoginView())))
                        
            Spacer()
        }
        .padding(.horizontal, Constants.sidePadding)
        .padding(.top, Constants.topPadding)
        .toolbar {
            ToolbarItem(placement: .principal) {
                UnderlinedText("Settings")
                    .font(Constants.navHeaderText)
                    .padding(.top)
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
    
    @ViewBuilder
    private func settingsRowDestination(image: Image, label: String, destination: Destination) -> some View {
        switch destination {
        case .externalLink(let urlString):
            if let url = URL(string: urlString) {
                Link(destination: url) {
                    settingsRow(image: image, label: label)
                }
                .buttonStyle(EmptyButtonStyle())
            }
         case .internalView(let destinationView):
            NavigationLink {
                switch destinationView {
                case .aboutUs(let aboutUsView):
                    aboutUsView
                case .organizationLogin(let orgsLoginView):
                    orgsLoginView
                }
            } label: {
                settingsRow(image: image, label: label)
            }
            .buttonStyle(EmptyButtonStyle())
        }
    }
    
    private func settingsRow(image: Image, label: String) -> some View {
        HStack {
            image
                .resizable()
                .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                .foregroundColor(.black)
            
            Text(label)
                .font(Constants.font)
                .padding(.leading, Constants.textLeftPadding)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .background(Color.volume.backgroundGray)
    }
    
}

extension SettingsView {
    
    enum Destination {
        case externalLink(String)
        case internalView(SettingsInternalView)
    }
    
    enum SettingsInternalView {
        case aboutUs(AboutVolumeView)
        case organizationLogin(OrgsLoginView)
    }
    
}

// MARK: - Uncomment below if needed

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
