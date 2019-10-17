//
//  ContentView.swift
//  ConversionApp
//
//  Created by Peter Salz on 17.10.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    enum Unit: Int {
        case meters = 0
        case kilometers
        case feet
        case yards
        case miles
        
        static let kilometersToMeters = 1000.0
        static let feetToMeters = 1.0 / 3.281
        static let yardsToMeters = 1.0 / 1.094
        static let milesToMeters = 1609.344
        
        static let unitStrings = ["m", "km", "ft", "yd", "mi"]
    }
    
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    @State private var inputNumber = ""
    
    func convertToMeters(_ number: Double,
                         from inputUnit: Unit) -> Double? {
        
        switch inputUnit {
            
        case .meters:
            return number
            
        case .kilometers:
            return number * Unit.kilometersToMeters
            
        case .feet:
            
            return number * Unit.feetToMeters
            
        case .yards:
            
            return number * Unit.yardsToMeters
            
        case .miles:
            
            return number * Unit.milesToMeters
            
        @unknown default:
            return nil
        }
    }
    
    func convert(_ number: Double,
                 from inputUnit: Unit,
                 to outputUnit: Unit) -> Double? {
        
        // First convert input to meters.
        guard let toMeters = convertToMeters(number,
                                             from: inputUnit) else {
            return nil
        }
        
        // Then convert to outputUnit.
        switch outputUnit {
            
        case .meters:
            return toMeters
            
        case .kilometers:
            return toMeters / Unit.kilometersToMeters
            
        case .feet:
            return toMeters / Unit.feetToMeters
            
        case .yards:
            return toMeters / Unit.yardsToMeters
            
        case .miles:
            return toMeters / Unit.milesToMeters
            
        @unknown default:
            return nil
        }
    }
    
    var outputNumber: Double {
        
        let input: Unit = Unit(rawValue: inputUnit) ?? .meters
        let output: Unit = Unit(rawValue: outputUnit) ?? .meters
        
        let number = Double(inputNumber) ?? 0
        
        let convertedNumber = convert(number,
                                      from: input,
                                      to: output) ?? 0
        
        return convertedNumber
    }
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Input")) {
                    
                    TextField("Input Value",
                              text: $inputNumber)
                        .keyboardType(.decimalPad)
                    
                    Picker("Input Unit",
                           selection: $inputUnit) {
                        
                            ForEach(0 ..< Unit.unitStrings.count) {
                                Text("\(Unit.unitStrings[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output")) {
                    
                    Picker("Output Unit",
                           selection: $outputUnit) {
                        
                            ForEach(0 ..< Unit.unitStrings.count) {
                                Text("\(Unit.unitStrings[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("\(outputNumber, specifier: "%.4f")")
                }
            }
            .navigationBarTitle("Distance conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
