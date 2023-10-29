//
//  MagazineReaderView.swift
//  Volume
//
//  Created by Justin Ngai on 9/3/2022.
//  Copyright © 2022 Cornell AppDev. All rights reserved.
//

import AppDevAnalytics
import Combine
import LinkPresentation
import PDFKit
import SDWebImageSwiftUI
import SwiftUI

struct MagazineReaderView: View {

    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var networkState: NetworkState
    @EnvironmentObject private var userData: UserData

    @StateObject var pdfView = PDFViewUnselectable(frame: CGRect(origin: .zero, size: Constants.pdfViewSize))

    @State private var cancellableReadMutation: AnyCancellable?
    @State private var magazine: Magazine?
    @State private var pdfDoc: PDFDocument?
    @State private var queryBag = Set<AnyCancellable>()
    @State private var showScrollbar: Bool = false

    let initType: ReaderViewInitType<Magazine>
    let navigationSource: NavigationSource

    // MARK: - Constants

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

    // MARK: - Data

    private func fetchPDF(url: URL) async {
        pdfDoc = PDFDocument(url: url)
    }

    private func markMagazineRead() async {
        guard let uuid = userData.uuid, let magazineID = magazine?.id else { return }
        cancellableReadMutation = Network.shared.publisher(
            for: ReadMagazineMutation(
                id: magazineID,
                uuid: uuid
            )
        )
        .map(\.readMagazine?.id)
        .sink { completion in
            if case let .failure(error) = completion {
                print("Error: ReadMagazineMutation failed on MagazineReaderView: \(error.localizedDescription)")
            }
        } receiveValue: { id in
#if DEBUG
            print("Marked magazine read with ID: \(id ?? "nil")")
#endif
        }
    }

    private func fetchMagazineById(_ magazineId: String) {
        Network.shared.publisher(
            for: GetMagazineByIdQuery(id: magazineId)
        )
        .compactMap(\.magazine?.fragments.magazineFields)
        .sink { completion in
            networkState.handleCompletion(screen: .reads, completion)
        } receiveValue: { magazineFields in
            Task {
                magazine = await Magazine(from: magazineFields)
            }
        }
        .store(in: &queryBag)
    }

    // MARK: - UI

    private var navbar: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .shadow(
                    color: .black.opacity(Constants.navbarOpacity),
                    radius: Constants.navbarRadius,
                    y: Constants.navbarY
                )

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
                        Haptics.shared.play(.light)
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

                if let pdfDoc = pdfDoc {
                    PDFKitView(
                        pdfView: pdfView,
                        pdfDoc: pdfDoc
                    )
                    .overlay(
                        showScrollbar
                             ? PageIndicatorView(
                                totalPage: pdfDoc.pageCount,
                                pdfView: pdfView
                             ).padding([.top, .trailing])
                             : nil,
                             alignment: .topTrailing
                    )
                } else {
                    PDFKitView(pdfView: pdfView, pdfDoc: PDFDocument())
                        .overlay(ProgressView())
                }

                if showScrollbar {
                    MagsScrollbarView(pdfView: pdfView)
                        .frame(height: Constants.scrollbarHeight)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        .zIndex(1)
                }

                ReaderToolbarView(content: magazine, navigationSource: .magazineDetail)
            }

            VStack(spacing: 0) {
                navbar

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if magazine == nil {
                switch initType {
                case .fetchRequired(let magazineId):
                    fetchMagazineById(magazineId)
                case .readyForDisplay(let magazine):
                    self.magazine = magazine

                    AppDevAnalytics.log(
                        VolumeEvent.openMagazine.toEvent(
                            .magazine,
                            value: magazine.id,
                            navigationSource: navigationSource
                        )
                    )

                    Task {
                        await markMagazineRead()
                    }

                    if let url = magazine.pdfUrl {
                        Task {
                            await fetchPDF(url: url)
                        }
                    }
                }
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
