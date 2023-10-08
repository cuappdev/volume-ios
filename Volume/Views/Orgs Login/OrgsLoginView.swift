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
        static let buttonTextFont: Font = .helveticaNeueMedium(size: 16)
        static let errorMessageFont: Font = .helveticaNeueMedium(size: 14)
        static let inputSpacing: CGFloat = 24
        static let labelFont: Font = .newYorkRegular(size: 16)
        static let labelSpacing: CGFloat = 8
        static let maxAccessCodeLength: Int = 6
        static let navHeaderText: Font = .newYorkMedium(size: 20)
        static let sidePadding: CGFloat = 16
        static let textColor: Color = Color.volume.textGray
        static let textFieldBorderColor: Color = Color.volume.outlineGray
        static let textFieldFont: Font = .helveticaRegular(size: 16)
        static let textFieldPadding: EdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        static let topPadding: CGFloat = 28
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack(spacing: Constants.inputSpacing) {
            slugInput
            codeInput
            
            VStack(alignment: .leading, spacing: 8) {
                authenticateButton
                
                viewModel.showErrorMessage ? errorMessage : nil
            }
            
            Spacer()
        }
        .padding(.top, Constants.topPadding)
        .padding(.horizontal, Constants.sidePadding)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Organization Login")
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
        .onChange(of: viewModel.accessCode) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                viewModel.buttonEnabled = viewModel.accessCode.count == Constants.maxAccessCodeLength && !viewModel.slug.isEmpty
            }
        }
        .onChange(of: viewModel.slug) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                viewModel.buttonEnabled = viewModel.accessCode.count == Constants.maxAccessCodeLength && !viewModel.slug.isEmpty
            }
        }
        .onAppear {
            slugIsFocused = true  // First responder
        }
        .onChange(of: viewModel.organization) { organization in
            // TODO: Do something if authenticated
            print("Fetched \(String(describing: organization?.name))")
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
                            viewModel.showErrorMessage ? Color.volume.errorRed :
                                slugIsFocused ? Color.volume.orange : Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: 1)
                        )
                        .background(slugIsFocused ? Color.volume.offWhite : nil)
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
                            viewModel.showErrorMessage ? Color.volume.errorRed :
                                accessCodeIsFocused ? Color.volume.orange : Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: 1)
                        )
                        .background(accessCodeIsFocused ? Color.volume.offWhite : nil)
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
                        .foregroundColor(viewModel.buttonEnabled ? Color.volume.orange : Color.volume.buttonDisabledGray)
                )
        }
        .padding(.top, 8)
        .disabled(!viewModel.buttonEnabled)
    }
    
    private var errorMessage: some View {
        HStack(alignment: .center,spacing: 4) {
            Image.volume.error
                .frame(width: 16, height: 16)
            
            Text("Invalid slug or code. Please try again.")
                .font(Constants.errorMessageFont)
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
