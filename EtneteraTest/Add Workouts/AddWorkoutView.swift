//
//  AddWorkoutView.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import SwiftUI
import AuthenticationServices
import CoreLocation

struct AddWorkoutView: View {
    @State private var title: String = ""
    @State private var location: String = ""
    @State var coordinates: CLLocationCoordinate2D?
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var storage: Storage = .local
    @State private var error: String?

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    @FocusState private var focusedField: Field?
    private enum Field: Int, Hashable {
        case title, location
    }

    private var invalidState: Bool {
        return title.isEmpty || location.isEmpty || (hours == 0 && minutes == 0 && seconds == 0)
    }

    @ObservedObject var user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Title")
                TextField("Required", text: $title)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .title)
                    .onSubmit {
                        focusedField = .location
                    }
                HStack {
                    Spacer()
                    Text(title.isEmpty ? "Enter title" : "")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
            }
            .padding(.bottom)
            VStack(alignment: .leading) {
                Text("Location")
                TextField("Required", text: $location)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .location)
                    .onSubmit {
                        focusedField = nil
                    }
                HStack(alignment: .top) {
                    NavigationLink(destination: MapView(coordinates: $coordinates)) {
                        if coordinates == nil {
                            Text("Select location on map")
                                .font(.body)
                                .foregroundColor(Color.blue)
                        } else {
                            Text("Change location on map")
                                .font(.body)
                                .foregroundColor(Color.blue)
                        }
                    }
                    Spacer()
                    Text(location.isEmpty ? "Enter location name" : "")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
            }
            .padding(.bottom)
            DurationPickerView(hours: $hours, minutes: $minutes, seconds: $seconds)
                .padding(.bottom)
            Text("Storage")
            Picker("", selection: $storage) {
                ForEach(Storage.savingCases) { option in
                    Text(option.rawValue.capitalized)
                        .tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom)
            Button(action: submit) {
                Text("Save workout")
            }
            .buttonStyle(.bordered)
            .disabled(invalidState)
            .padding(.bottom)
            if let err = error, !err.isEmpty {
                Text(err)
                    .font(.caption)
                    .foregroundColor(Color.red)
            }
        }
        .padding()
        .navigationTitle("Add new workout")
    }

    private func submit() {
        if User.shared.addWorkout(title: title, location: location, latitude: coordinates?.latitude, longitude: coordinates?.longitude, hours: hours, minutes: minutes, seconds: seconds, storage: storage) {
            presentationMode.wrappedValue.dismiss()
        } else {
            error = "Something went wrong with saving your workout..."
        }
    }
}

struct AddWorkoutView_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            AddWorkoutView(user: User.sample)
        }
    }
}
