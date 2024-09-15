//
//  ContentView.swift
//  AudioEnginePrototype
//
//  Created by Yuya Hirayama on 2023/12/22.
//

import SwiftUI
import AudioEngine
import AppModel

struct ContentView: View {
    @ObservedObject var audioEngine: AudioEngine
    @ObservedObject var midiEngine: MIDIEngine
    
    init() {
        audioEngine = .shared
        midiEngine = .shared
    }
    
    @State private var playingChord: Set<Chord> = []
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack {
                ForEach(LetterNotation.allCases, id: \.rawValue) { letterNotation in
                    HStack {
                        specifyChord(rootNote: letterNotation, keyPath: \.major)
                        specifyChord(rootNote: letterNotation, keyPath: \.minor)
                        specifyChord(rootNote: letterNotation, keyPath: \.seventh)
                        specifyChord(rootNote: letterNotation, keyPath: \.minorSeventh)
                        specifyChord(rootNote: letterNotation, keyPath: \.majorSeventh)
                        specifyChord(rootNote: letterNotation, keyPath: \.minorSeventhFlattedFifth)
                        specifyChord(rootNote: letterNotation, keyPath: \.diminished)
                        specifyChord(rootNote: letterNotation, keyPath: \.suspendedFourth)
                        specifyChord(rootNote: letterNotation, keyPath: \.seventhSuspendedFourth)
                        specifyChord(rootNote: letterNotation, keyPath: \.augmented)
                        specifyChord(rootNote: letterNotation, keyPath: \.minorSixth)
                        specifyChord(rootNote: letterNotation, keyPath: \.addNinth)
                        specifyChord(rootNote: letterNotation, keyPath: \.sixth)
                    }
                }
            }
            .padding()
        }
        .onChange(of: playingChord) { oldValue, newValue in
            let added = newValue.subtracting(oldValue)
            added.forEach { addedChord in
                Task {
                    print("play", addedChord.name)
                    await midiEngine.audition(chord: addedChord)
                }
            }
            
            let removed = oldValue.subtracting(newValue)
            removed.forEach { removedChord in
                Task {
                    print("stop", removedChord.name)
                    await midiEngine.stopAudition(chord: removedChord)
                }
            }
        }
    }
    
    @ViewBuilder private func specifyChord(rootNote: LetterNotation, keyPath: KeyPath<LetterNotation, Chord>) -> some View {
        let chord = rootNote[keyPath: keyPath]
        
        Text(chord.name)
            .foregroundStyle(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(width: 44, height: 24)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(playingChord.contains(chord) ? .pink : .gray)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        guard playingChord.count <= 3 else {
                            return
                        }
                        playingChord.insert(chord)
                    })
                    .onEnded({ _ in
                        playingChord.remove(chord)
                    })
            )
    }
}

#Preview {
    ContentView()
}
