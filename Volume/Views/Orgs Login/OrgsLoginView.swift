//
//  OrgsLoginView.swift
//  Volume
//
//  Created by Vin Bui on 9/29/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import SwiftUI

struct OrgsLoginView: View {

    // MARK: - Properties

    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()

    @FocusState private var accessCodeIsFocused: Bool
    @FocusState private var slugIsFocused: Bool

    // MARK: - Constants

    private struct Constants {
        static let borderWidth: CGFloat = 1
        static let buttonTextFont: Font = .helveticaNeueMedium(size: 16)
        static let errorMessageFont: Font = .helveticaRegular(size: 14)
        static let inputSpacing: CGFloat = 24
        static let labelFont: Font = .newYorkRegular(size: 16)
        static let labelSpacing: CGFloat = 8
        static let maxAccessCodeLength: Int = 6
        static let sidePadding: CGFloat = 16
        static let textColor: Color = Color.volume.textGray
        static let textFieldBorderColor: Color = Color.volume.outlineGray
        static let textFieldFont: Font = .helveticaRegular(size: 16)
        static let textFieldPadding: EdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        static let topPadding: CGFloat = 28
    }

    // MARK: - UI

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: Constants.inputSpacing) {
                    slugInput
                    codeInput
                    saveInfo

                    VStack(alignment: .leading, spacing: 8) {
                        authenticateButton
                        viewModel.showErrorMessage ? errorMessage : nil
                    }

                    Spacer()
                }

                if viewModel.showSpinner {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .padding(.top, Constants.topPadding)
            .padding(.horizontal, Constants.sidePadding)
            .background(Color.volume.backgroundGray)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Organization Login")
                        .font(.newYorkMedium(size: 20))
                }

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image.volume.backArrow
                            .foregroundColor(Color.black)
                    }
                    .buttonStyle(EmptyButtonStyle())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                FlyerUploadView(organization: viewModel.organization)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.orgLoginInfo) { _ in
            viewModel.updateAuthenticateButton()
        }
        .onAppear {
            slugIsFocused = true  // First responder
            viewModel.isAuthenticated = false
            viewModel.fetchSavedInfo()
        }
    }

    private var slugInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Organization Slug")
                .font(Constants.labelFont)

            TextField("Enter your slug", text: $viewModel.slug)
                .font(Constants.textFieldFont)
                .padding(Constants.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            viewModel.showErrorMessage
                            ? Color.volume.errorRed
                            : slugIsFocused
                                ? Color.volume.orange
                                : Constants.textFieldBorderColor,
                            style: StrokeStyle(lineWidth: Constants.borderWidth)
                        )
                )
                .focused($slugIsFocused)
        }
        .foregroundColor(Constants.textColor)
    }

    private var codeInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Access Code")
                .font(Constants.labelFont)

            SecureField("Enter your access code", text: $viewModel.accessCode)
                .font(Constants.textFieldFont)
                .padding(Constants.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            viewModel.showErrorMessage
                            ? Color.volume.errorRed
                            : accessCodeIsFocused
                                ? Color.volume.orange
                                : Constants.textFieldBorderColor,
                            style: StrokeStyle(lineWidth: Constants.borderWidth)
                        )
                )
                .focused($accessCodeIsFocused)
                .keyboardType(.numberPad)
                .onReceive(Just(viewModel.slug)) { _ in
                    if viewModel.accessCode.count > Constants.maxAccessCodeLength {
                        viewModel.accessCode = String(viewModel.accessCode.prefix(Constants.maxAccessCodeLength))
                    }
                }
        }
        .foregroundColor(Constants.textColor)
    }

    private var authenticateButton: some View {
        Button {
            Task {
                await viewModel.authenticate(accessCode: viewModel.accessCode, slug: viewModel.slug)
            }
        } label: {
            Text("Authenticate")
                .font(Constants.buttonTextFont)
                .foregroundColor(viewModel.buttonEnabled ? Color.volume.offWhite : Constants.textColor)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(
                            viewModel.buttonEnabled
                            ? Color.volume.orange
                            : Color.volume.buttonDisabledGray
                        )
                )
        }
        .padding(.top, 8)
        .disabled(!viewModel.buttonEnabled)
    }

    private var errorMessage: some View {
        HStack(alignment: .center, spacing: 4) {
            Image.volume.error
                .frame(width: 16, height: 16)

            Text("Invalid slug or code. Please try again.")
                .font(Constants.errorMessageFont)
                .foregroundColor(Constants.textColor)
        }
    }

    private var saveInfo: some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                viewModel.isInfoSaved.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            viewModel.isInfoSaved
                            ? Color.volume.orange
                            : Constants.textFieldBorderColor,
                            style: StrokeStyle(lineWidth: Constants.borderWidth)
                        )

                    if viewModel.isInfoSaved {
                        Image.volume.checkmark
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color.white)
                    }
                }
            }
            .background(viewModel.isInfoSaved ? Color.volume.orange : nil)
            .cornerRadius(4)
            .frame(width: 24, height: 24)

            Text("Save login info")
                .font(Constants.textFieldFont)
                .foregroundColor(Constants.textColor)
        }
    }

}

// MARK: - Uncomment below if needed

//struct OrgsLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrgsLoginView()
//    }
//}
