//
//  MagazineDetail.swift
//  Volume
//
//  Created by Justin Ngai on 9/3/2022.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import LinkPresentation
import SDWebImageSwiftUI
import SwiftUI
import PDFKit

struct MagazineReaderView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var networkState: NetworkState

    let initType: ReaderViewInitType<Magazine>
    let navigationSource: NavigationSource

    @State private var magazine: Magazine?
    @State private var queryBag = Set<AnyCancellable>()
    
    let pdfView = PDFViewUnselectable(frame: CGRect(origin: .zero, size: Constants.pdfViewSize))
    @State private var showScrollbar: Bool = false

    private struct Constants {
        static let navbarOpacity: CGFloat = 0.2
        static let navbarRadius: CGFloat = 2
        static let navbarY: CGFloat = 3
        static let navbarLeftComponentHeight: CGFloat = 24
        static let navbarRightComponentHeight: CGFloat = 16
        static let navbarHStackPadding: CGFloat = 16
        static let navbarTitleSize: CGFloat = 12
        static let navbarSubtitle = "Reading in Volume"
        static let navbarSubtitleSize: CGFloat = 10
        static let navbarVStackPadding: CGFloat = 48
        static let navbarHeight: CGFloat = 40
        
        static let toolbarPubImageW: CGFloat = 32
        static let toolbarPubImageH: CGFloat = 32
        static let toolbarRightComponentsPadding: CGFloat = 16
        static let toolbarLeftBorderPadding: CGFloat = 7
        static let toolbarRightBorderPadding: CGFloat = 6
        static let toolbarShoutoutsFontSize: CGFloat = 12
        
        static let pdfViewSize = CGSize(width: 150, height: 220)
        static let scrollbarHeight: CGFloat = 45
    }
    
    // MARK: Data

    private func fetchMagazineById(_ magazineId: String) {
        Network.shared.publisher(
            for: GetMagazineByIdQuery(id: magazineId)
        )
        .compactMap(\.magazine?.fragments.magazineFields)
        .sink { completion in
            networkState.handleCompletion(screen: .magazines, completion)
        } receiveValue: { magazineFields in
            Task {
                magazine = await Magazine(from: magazineFields)
                
                if let pdfDoc = magazine?.pdfDoc {
                    pdfView.document = pdfDoc
                } else {
                    pdfView.document = PDFDocument()
                }
            }
        }
        .store(in: &queryBag)
    }

    // MARK: UI

    private var navbar: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .shadow(color: .black.opacity(Constants.navbarOpacity), radius: Constants.navbarRadius, y: Constants.navbarY)

            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image.volume.leftArrow
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: Constants.navbarLeftComponentHeight)
                        .foregroundColor(.black)
                }

                Spacer()
                
                Image.volume.menu
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: Constants.navbarRightComponentHeight)
                    .foregroundColor(.volume.lightGray)
                    .onTapGesture {
                        showScrollbar.toggle()
                    }
                
            }
            .padding(.horizontal, Constants.navbarHStackPadding)

            VStack {
                Text(magazine?.title ?? "Loading magazine...")
                    .font(.newYorkBold(size: Constants.navbarTitleSize))
                    .truncationMode(.tail)

                Text(Constants.navbarSubtitle)
                    .font(.helveticaRegular(size: Constants.navbarSubtitleSize))
                    .foregroundColor(.volume.lightGray)
            }
            .padding(.horizontal, Constants.navbarVStackPadding)
        }
        .background(Color.white)
        .frame(height: Constants.navbarHeight)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: Constants.navbarHeight)
                                    
                if let pdfDoc = magazine?.pdfDoc {
                    PDFKitView(pdfView: pdfView, pdfDoc: pdfDoc)
                        .overlay(showScrollbar
                                 ? PageIndicatorView(
                                        totalPage: pdfDoc.pageCount,
                                        pdfView: pdfView
                                    ).padding([.top, .trailing])
                                 : nil
                                 ,alignment: .topTrailing)
                } else {
                    PDFKitView(pdfView: pdfView, pdfDoc: PDFDocument())
                }
                
                if showScrollbar {
                    MagsScrollbarView(pdfView: pdfView)
                        .frame(height: Constants.scrollbarHeight)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        .zIndex(1)
                }
                
                ReaderToolbarView(content: magazine, navigationSource: navigationSource)
            }

            VStack(spacing: 0) {
                navbar
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            switch initType {
            case .fetchRequired(let magazineId):
                fetchMagazineById(magazineId)
            case .readyForDisplay(let magazine):
                self.magazine = magazine
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.PDFViewPageChanged)) { _ in
            pdfView.objectWillChange.send()
        }
    }
}

extension MagazineReaderView {
    private enum MagazineReaderViewState<Results> {
        case loading, results(Results)
    }
}
