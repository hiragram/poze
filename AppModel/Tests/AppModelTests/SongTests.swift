//
//  SongTests.swift
//  
//
//  Created by Yuya Hirayama on 2024/01/21.
//

import XCTest
@testable import AppModel
import TestUtility

final class SongTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_最新プロジェクトデータからの変換() throws {
        let sectionID = UUID()

        let project = LatestStructureVersion.Project(
            metadata: .init(
                projectID: .init(),
                createdAt: .now,
                updatedAt: .now
            ),
            sections: [
                .init(
                    sectionID: sectionID,
                    name: "Section 123",
                    measures: [
                        .init(
                            measureID: .init(),
                            chordPlays: [
                                .init(
                                    chordPlayID: .init(),
                                    baseNote: .a,
                                    chordType: .minorSeventh,
                                    length: .halfNote
                                ),
                                .init(
                                    chordPlayID: .init(),
                                    baseNote: .g,
                                    chordType: .addNinth,
                                    length: .quarterNote
                                ),
                                .init(
                                    chordPlayID: .init(),
                                    baseNote: .f,
                                    chordType: .minor,
                                    length: .quarterNote
                                ),
                            ]
                        )
                    ],
                    bpmOverride: 110,
                    keyOverride: .init(
                        rootNote: .cSharp,
                        scaleType: .major
                    ),
                    timeSignatureOverride: .init(
                        baseNote: .quarter,
                        count: .four
                    )
                )
            ],
            songInfo: .init(
                title: "Konnichiwa",
                scale: .init(rootNote: .e, scaleType: .major),
                bpm: 135,
                timeSignature: .init(
                    baseNote: .quarter,
                    count: .three
                )
            )
        )

        let actual = Song.init(project: project)
        let expected = Song.init(
            title: "Konnichiwa",
            key: Scale.major(rootNote: .e),
            bpm: 135,
            timeSignature: TimeSignature.init(
                baseNote: .quarter,
                count: .three
            ),
            sections: [
                Section.init(
                    id: sectionID,
                    name: "Section 123",
                    keyOverride: Scale.major(rootNote: .cSharp),
                    bpmOverride: 110,
                    timeSignatureOverride: TimeSignature.init(
                        baseNote: .quarter,
                        count: .four
                    ),
                    measures: [
                        Measure.init(
                            measureID: .init(),
                            chords: [
                                .init(
                                    sameTimingNotesID: .init(),
                                    chord: LetterNotation.a.minorSeventh,
                                    length: .halfNote,
                                    velocity: 60
                                ),
                                .init(
                                    sameTimingNotesID: .init(),
                                    chord: LetterNotation.g.addNinth,
                                    length: .quarterNote,
                                    velocity: 60
                                ),
                                .init(
                                    sameTimingNotesID: .init(),
                                    chord: LetterNotation.f.minor,
                                    length: .quarterNote,
                                    velocity: 60
                                ),
                            ]
                        )
                    ]
                )
            ]
        )

        assertEqual(
            actual,
            expected,
            keyPaths: \.title, \.key.rootNote, \.key.name, \.key.notes, \.key.scalePattern, \.bpm, \.timeSignature.baseNote, \.timeSignature.count, \.timeSignature.measureLength, \.sections.count
        )

        zip(actual.sections, expected.sections).forEach {
            actualSection,
            expectedSection in

            assertEqual(
                actualSection,
                expectedSection,
                keyPaths: \Section.id, \Section.name, \Section.measures.count, \Section.bpmOverride, \Section.keyOverride?.rootNote, \Section.keyOverride?.scalePattern, \Section.timeSignatureOverride?.baseNote, \Section.timeSignatureOverride?.count
            )

            zip(actualSection.measures, expectedSection.measures).forEach { actualMeasure, expectedMeasure in

                assertEqual(actualMeasure, expectedMeasure, keyPaths: \.layers.count)

                zip(actualMeasure.layers, expectedMeasure.layers).forEach { actualLayer, expectedLayer in

                    assertEqual(actualLayer, expectedLayer, keyPaths: \.rhythmNotes.count)

                    zip(actualLayer.rhythmNotes, expectedLayer.rhythmNotes).forEach { actualRhythmNotes, expectedRhythmNotes in

                        assertEqual(actualRhythmNotes, expectedRhythmNotes, keyPaths: \.chord.root, \.chord.chordType, \.chord.chordName, \.chord.name, \.chord.standardTones.count, \.tones.count, \.length, \.velocity)

                        zip(actualRhythmNotes.chord.standardTones, expectedRhythmNotes.chord.standardTones).forEach { actualStandardTones, expectedStandardTones in

                            assertEqual(actualStandardTones, expectedStandardTones, keyPaths: \.letterNotation, \.octave, \.midiNoteNumber)
                        }

                        zip(actualRhythmNotes.tones, expectedRhythmNotes.tones).forEach { actualTones, expectedTones in

                            assertEqual(actualTones, expectedTones, keyPaths: \.midiNote.letterNotation, \.midiNote.octave, \.velocity)
                        }
                    }
                }
            }
        }
    }
}
