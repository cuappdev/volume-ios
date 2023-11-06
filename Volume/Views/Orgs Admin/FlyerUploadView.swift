//
//  FlyerUploadView.swift
//  Volume
//
//  Created by Vin Bui on 9/29/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import PhotosUI
import SwiftUI

struct FlyerUploadView: View {

    // MARK: - Properties

    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()

    let organization: Organization?

    // MARK: - Constants

    private struct Constants {
        static let backgroundColor: Color = Color.volume.backgroundGray
        static let borderWidth: CGFloat = 1
        static let buttonTextFont: Font = .helveticaNeueMedium(size: 16)
        static let compressionQuality: CGFloat = 1
        static let inputSpacing: CGFloat = 24
        static let labelFont: Font = .newYorkRegular(size: 16)
        static let labelSpacing: CGFloat = 8
        static let sidePadding: CGFloat = 16
        static let textColor: Color = Color.volume.textGray
        static let textFieldBorderColor: Color = Color.volume.outlineGray
        static let textFieldFont: Font = .helveticaRegular(size: 14)
        static let textFieldPadding: EdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        static let topPadding: CGFloat = 28
    }

    // MARK: - UI

    var body: some View {
        ZStack(alignment: .center) {
            mainContent

            if viewModel.showSpinner {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.volume.backgroundGray)
        .overlay(
            viewModel.startIsFocused ? startDatePicker : nil
        )
        .overlay(
            viewModel.endIsFocused ? endDatePicker : nil
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Upload Flyer")
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
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

            withAnimation(.easeOut(duration: 0.3)) {
                viewModel.startIsFocused = false
                viewModel.endIsFocused = false
            }
        }
        .task {
            await viewModel.fetchCategories()
        }
        .onChange(of: viewModel.flyerStringInfo) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                viewModel.buttonEnabled = !viewModel.flyerName.isEmpty &&
                !viewModel.flyerLocation.isEmpty && !viewModel.flyerCategory.isEmpty &&
                (viewModel.flyerStart < viewModel.flyerEnd) && viewModel.flyerImageItem != nil
            }
        }
        .onChange(of: viewModel.flyerDateInfo) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                viewModel.buttonEnabled = !viewModel.flyerName.isEmpty &&
                !viewModel.flyerLocation.isEmpty && !viewModel.flyerCategory.isEmpty &&
                (viewModel.flyerStart < viewModel.flyerEnd) && viewModel.flyerImageItem != nil

                viewModel.showErrorMessage = viewModel.flyerStart > viewModel.flyerEnd
            }
        }
        .onChange(of: viewModel.flyerImageItem) { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                viewModel.buttonEnabled = !viewModel.flyerName.isEmpty &&
                !viewModel.flyerLocation.isEmpty && !viewModel.flyerCategory.isEmpty &&
                (viewModel.flyerStart < viewModel.flyerEnd) && viewModel.flyerImageItem != nil
            }
        }
    }

    private var mainContent: some View {
        GeometryReader { geometry in
            ScrollView {
                if viewModel.uploadSuccessful != nil {
                    stateMessage
                        .frame(minHeight: geometry.size.height)
                } else {
                    VStack(alignment: .leading, spacing: Constants.inputSpacing) {
                        organizationName
                        flyerNameInput

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 16) {
                                startTimeInput
                                endTimeInput
                            }

                            viewModel.showErrorMessage ? errorMessage : nil
                        }

                        locationInput
                        categoryInput
                        redirectInput

                        VStack(alignment: .leading, spacing: 40) {
                            imagePicker
                            uploadButton
                        }

                        Spacer()
                    }
                    .padding(.top, Constants.topPadding)
                    .padding(.horizontal, Constants.sidePadding)
                    .background(Constants.backgroundColor)
                }
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(viewModel.uploadSuccessful != nil)
            .frame(width: geometry.size.width)
        }
    }

    private var organizationName: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Organization")
                .font(Constants.labelFont)
                .foregroundColor(Constants.textColor)

            Text(organization?.name ?? "Invalid Organization")
                .font(.newYorkMedium(size: 24))
        }
    }

    private var flyerNameInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Flyer Name")
                .font(Constants.labelFont)

            TextField("Enter flyer name", text: $viewModel.flyerName)
                .font(Constants.textFieldFont)
                .padding(Constants.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            Constants.textFieldBorderColor,
                            style: StrokeStyle(lineWidth: Constants.borderWidth)
                        )
                )
        }
        .foregroundColor(Constants.textColor)
    }

    private var startTimeInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Start Time")
                .font(Constants.labelFont)

            Button {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )

                withAnimation(.easeOut(duration: 0.3)) {
                    viewModel.startIsFocused = true
                    viewModel.endIsFocused = false
                }
            } label: {
                Text("\(viewModel.flyerStart.simpleString) \(viewModel.flyerStart.flyerTimeString)")
                    .font(Constants.textFieldFont)
                    .padding(Constants.textFieldPadding)
                    .frame(maxWidth: .infinity)
                    .frame(alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(
                                Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: Constants.borderWidth)
                            )
                    )
            }
        }
        .foregroundColor(Constants.textColor)
    }

    private var endTimeInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("End Time")
                .font(Constants.labelFont)

            Button {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )

                withAnimation(.easeOut(duration: 0.3)) {
                    viewModel.startIsFocused = false
                    viewModel.endIsFocused = true
                }
            } label: {
                Text("\(viewModel.flyerEnd.simpleString) \(viewModel.flyerEnd.flyerTimeString)")
                    .font(Constants.textFieldFont)
                    .padding(Constants.textFieldPadding)
                    .frame(maxWidth: .infinity)
                    .frame(alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(
                                Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: Constants.borderWidth)
                            )
                    )
            }
        }
        .foregroundColor(Constants.textColor)
    }

    private var locationInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Location")
                .font(Constants.labelFont)

            TextField("Enter location", text: $viewModel.flyerLocation)
                .font(Constants.textFieldFont)
                .padding(Constants.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: Constants.borderWidth)
                        )
                )
        }
        .foregroundColor(Constants.textColor)
    }

    private var categoryInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Category")
                .font(Constants.labelFont)

            if let firstCategory = viewModel.allCategories.first {
                CategoryDropdown(
                    borderColor: Constants.textFieldBorderColor,
                    categories: viewModel.allCategories,
                    defaultSelected: firstCategory,
                    font: Constants.textFieldFont,
                    insets: Constants.textFieldPadding,
                    selected: $viewModel.flyerCategory,
                    strokeWidth: Constants.borderWidth,
                    textColor: Constants.textColor
                )
            }
        }
        .foregroundColor(Constants.textColor)
    }

    private var redirectInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Flyer Redirect Link")
                    .font(Constants.labelFont)

                Text("Optional: Clicking on the flyer in app will take you to this link")
                    .font(.helveticaRegular(size: 12))
                    .foregroundColor(Color.volume.lightGray)
            }

            TextField("", text: $viewModel.flyerURL)
                .font(Constants.textFieldFont)
                .padding(Constants.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: Constants.borderWidth)
                        )
                )
        }
        .foregroundColor(Constants.textColor)
    }

    private var imagePicker: some View {
        PhotosPicker(selection: $viewModel.flyerImageItem, matching: .images) {
            HStack(alignment: .center) {
                Image.volume.camera
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color.volume.orange)

                Text(viewModel.flyerImageItem != nil ? "1 image selected" : "Select an image...")
                    .font(.helveticaRegular(size: 16))
                    .padding(Constants.textFieldPadding)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(
                        Color.volume.orange, style: StrokeStyle(lineWidth: Constants.borderWidth)
                    )
            )
        }
        .foregroundColor(Color.volume.orange)
        .onChange(of: viewModel.flyerImageItem) { newItem in
            Task {
                // Retrieve selected asset in the form of Data
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    // Convert to UIImage and compress
                    let img = UIImage(data: data)
                    viewModel.flyerImageData = img?.jpegData(compressionQuality: Constants.compressionQuality)
                }
            }
        }
    }

    private var uploadButton: some View {
        Button {
            Task {
                await viewModel.uploadFlyer(for: organization?.id)
            }
        } label: {
            Text("Upload Flyer")
                .font(Constants.buttonTextFont)
                .foregroundColor(viewModel.buttonEnabled ? Color.white : Constants.textColor)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(
                            viewModel.buttonEnabled ? Color.volume.orange : Color.volume.buttonDisabledGray
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

            Text("End time must be after start time.")
                .font(.helveticaRegular(size: 14))
                .foregroundColor(Constants.textColor)
        }
    }

    private var stateMessage: some View {
        VStack {
            Spacer()

            VStack(alignment: .center, spacing: 8) {
                switch viewModel.uploadSuccessful {
                case .none:
                    EmptyView()
                case .some(let success):
                    Text(success ? "Flyer Published!" : "Oh no, something went wrong.")
                        .font(.newYorkMedium(size: 20))

                    Text(success ? "Thank you for using Volume." : "Please reduce the image file size and try again.")
                        .font(.helveticaRegular(size: 14))
                        .foregroundColor(Color.volume.lightGray)
                }
            }

            Spacer()
        }
        .background(Constants.backgroundColor)
    }

    // MARK: - Supporting Views

    private var startDatePicker: some View {
        VStack {
            Spacer()

            DatePicker(">>>", selection: $viewModel.flyerStart)
                .datePickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .padding([.bottom, .horizontal])
                .background(Color(.systemGray5))
        }
    }

    private var endDatePicker: some View {
        VStack {
            Spacer()

            DatePicker(">>>", selection: $viewModel.flyerEnd)
                .datePickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .padding([.bottom, .horizontal])
                .background(Color(.systemGray5))
        }
    }

}

// MARK: - Uncomment below if needed

//struct FlyerUploadView_Provider: PreviewProvider {
//    static var previews: some View {
//        FlyerUploadView(organization: nil)
//    }
//}
