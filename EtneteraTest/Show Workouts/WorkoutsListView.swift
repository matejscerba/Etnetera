//
//  ContentView.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import SwiftUI

struct WorkoutsListView: View {
    @State var selectedStorage: Storage = .all
    @ObservedObject var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedStorage) {
                ForEach(Storage.allCases) { option in
                    Text(option.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            List {
                if user.workouts.filtered(storage: selectedStorage).count == 0 {
                    HStack {
                        Spacer()
                        Text("Could not load any workout...")
                            .padding(.top, 20)
                            .font(.body)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(user.workouts.filtered(storage: selectedStorage)) { workout in
                        if let _ = workout.coordinates {
                            NavigationLink(destination: ShowMapView(workout: workout)) {
                                WorkoutItem(workout: workout)
                            }
                            .listRowBackground(BackgroundColor(storage: workout.storage))
                            .tint(Color.black)
                        } else {
                            WorkoutItem(workout: workout)
                                .listRowBackground(BackgroundColor(storage: workout.storage))
                        }
                    }
                    .onDelete(perform: deleteWorkouts)
                }
            }
            .cornerRadius(8)
            .refreshable {
                user.reload()
            }
        }
        .padding()
        .toolbar {
            ToolbarItem {
                NavigationLink {
                    AddWorkoutView(user: user)
                } label: {
                    Label("Add workout", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Workouts")
    }

    private func deleteWorkouts(offsets: IndexSet) {
        for index in offsets {
            user.deleteWorkout(user.workouts.filtered(storage: selectedStorage)[index])
        }
    }
}

struct WorkoutsListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsListView(user: User.sample)
    }
}
