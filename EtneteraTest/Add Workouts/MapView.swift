//
//  MapView.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 03.02.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var coordinates: CLLocationCoordinate2D?
    @State private var region: MKCoordinateRegion = MKCoordinateRegion.initial
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.bottom)
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20, alignment: .center)
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("Move map so that circle is at the desired location")
                            .font(.caption)
                        Button(action: select) {
                            Text("Select")
                        }
                        .font(.body)
                        .buttonStyle(.bordered)
                    }
                    Spacer()
                }
                .padding()
                .background(colorScheme == .dark ? Color.black : Color.white)
                Spacer()
            }
        }
        .navigationTitle("Select location")
    }
    
    private func select() {
        coordinates = region.center
        presentationMode.wrappedValue.dismiss()
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var coordinates: CLLocationCoordinate2D?
    static var previews: some View {
        MapView(coordinates: $coordinates)
    }
}

extension MKCoordinateRegion {
    static let initial: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.073658, longitude: 14.418540), latitudinalMeters: 3000, longitudinalMeters: 3000)
}
