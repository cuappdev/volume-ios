//
//  FlyerUploadView.swift
//  Volume
//
//  Created by Vin Bui on 9/29/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import SwiftUI

struct FlyerUploadView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    
    let organization: Organization?
    
    // MARK: - Constants
    
    private struct Constants {
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
        mainContent
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image.volume.backArrow
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
    }
    
    private var mainContent: some View {
        VStack(alignment: .leading, spacing: Constants.inputSpacing) {
            organizationName
            flyerNameInput
            
            HStack(spacing: Constants.inputSpacing) {
                startTimeInput
                endTimeInput
            }
            
            locationInput
            
            Spacer()
        }
        .padding(.top, Constants.topPadding)
        .padding(.horizontal, Constants.sidePadding)
    }
    
    private var organizationName: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Organization")
                .font(Constants.labelFont)
                .foregroundColor(Constants.textColor)
            
            Text("Cornell AppDev")
                .font(.newYorkMedium(size: 24))
        }
    }
    
    private var flyerNameInput: some View {
        VStack(alignment: .leading, spacing: Constants.labelSpacing) {
            Text("Flyer Name")
                .font(Constants.labelFont)
            
            TextField("", text: $viewModel.flyerName)
                .font(Constants.textFieldFont)
                .padding(Constants.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder( Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: 1)
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
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
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
                                Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: 1)
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
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
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
                                Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: 1)
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
            
            TextField("", text: $viewModel.flyerLocation)
                .font(Constants.textFieldFont)
                .padding(Constants.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder( Constants.textFieldBorderColor, style: StrokeStyle(lineWidth: 1)
                        )
                )
        }
        .foregroundColor(Constants.textColor)
    }
    
    // MARK: - Supporting Views
    
    private var startDatePicker: some View {
        VStack {
            Spacer()
            
            DatePicker("", selection: $viewModel.flyerStart)
                .datePickerStyle(.wheel)
                .frame(width: .zero)
                .padding(.bottom)
        }
        .transition(AnyTransition.move(edge: .bottom))
    }
    
    private var endDatePicker: some View {
        VStack {
            Spacer()
            
            DatePicker("", selection: $viewModel.flyerEnd)
                .datePickerStyle(.wheel)
                .frame(width: .zero)
                .padding(.bottom)
        }
        .transition(AnyTransition.move(edge: .bottom))
    }
    
}

// MARK: - Uncomment below if needed

struct FlyerUploadView_Provider: PreviewProvider {
    static var previews: some View {
        FlyerUploadView(organization: nil)
    }
}
