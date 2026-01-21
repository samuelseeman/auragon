//
//  MigraineLog.swift
//  auragon
//
//  Created by Samuel Seeman on 1/20/26.
//


import Foundation
import SwiftData

@Model
class MigraineLog {
    var id: UUID
    var startTime: Date
    var endTime: Date?
    var painLevel: Int // 1-10
    var triggers: [String] // e.g. ["Bright Light", "Stress"]
    var medicationsTaken: [String] // e.g. ["Ibuprofen"]
    var reliefMethods: [String] // e.g. ["Sleep", "Ice Pack"]
    var notes: String
    
    // We will hook this up to Weather later, but let's prep the fields
    var recordedPressure: Double? 
    
    init(startTime: Date = Date(), 
         painLevel: Int = 5, 
         triggers: [String] = [], 
         medicationsTaken: [String] = [], 
         reliefMethods: [String] = [], 
         notes: String = "") {
        self.id = UUID()
        self.startTime = startTime
        self.painLevel = painLevel
        self.triggers = triggers
        self.medicationsTaken = medicationsTaken
        self.reliefMethods = reliefMethods
        self.notes = notes
    }
}