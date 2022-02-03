//
//  DurationPickerView.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 02.02.2022.
//

import SwiftUI

struct DurationPickerView: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    var body: some View {
//        VStack {
//            Text("Duration")
//            GeometryReader { geometry in
//                HStack(spacing: 0) {
//                    Picker("", selection: $hours) {
//                        ForEach(0..<24) { hour in
//                            Text("\(hour) h").tag(hour)
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .frame(maxWidth: geometry.size.width / 3)
//                    .compositingGroup()
//                    .clipped(antialiased: true)
//                    Picker("", selection: $minutes) {
//                        ForEach(0..<60) { minute in
//                            Text("\(minute) m").tag(minute)
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .frame(maxWidth: geometry.size.width / 3)
//                    .compositingGroup()
//                    .clipped(antialiased: true)
//                    Picker("", selection: $seconds) {
//                        ForEach(0..<60) { second in
//                            Text("\(second) s").tag(second)
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .frame(maxWidth: geometry.size.width / 3)
//                    .compositingGroup()
//                    .clipped(antialiased: true)
//                }
//                .padding(.bottom, 10)
//            }
//            HStack {
//                Spacer()
//                Text((hours == 0 && minutes == 0 && seconds == 0) ? "Duration must be greater than 0" : "")
//                    .font(.caption)
//                    .foregroundColor(Color.gray)
//                Spacer()
//            }
//        }
//        .frame(minHeight: 100)
        VStack {
            Text("Duration")
            HStack(spacing: 0) {
                Spacer()
                Picker("", selection: $hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour) h").tag(hour)
                    }
                }
                Spacer()
                Picker("", selection: $minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute) m").tag(minute)
                    }
                }
                Spacer()
                Picker("", selection: $seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second) s").tag(second)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 10)
            HStack {
                Spacer()
                Text((hours == 0 && minutes == 0 && seconds == 0) ? "Duration must be greater than 0" : "")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Spacer()
            }
        }
    }
}

struct DurationPicker_Preview: PreviewProvider {
    @State static var hours: Int = 0
    @State static var minutes: Int = 0
    @State static var seconds: Int = 0
    
    static var previews: some View {
        DurationPickerView(hours: $hours, minutes: $minutes, seconds: $seconds)
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
