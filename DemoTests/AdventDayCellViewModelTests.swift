//
//  AdventDayCellViewModelTests.swift
//  DemoTests
//
//  Created by JingChuang on 2025/12/13.
//

import Testing
import Dependencies
@testable import Demo

struct AdventDayCellViewModelTests {

    // MARK: - canOpen Tests

    @Test("Day 1 can open on Dec 1")
    func day1CanOpenOnDec1() {
        withDependencies {
            $0.date = .fixed(month: 12, day: 1)
        } operation: {
            let day = AdventDay(day: 1, videoURL: "", title: "Day 1")
            let viewModel = AdventDayCellViewModel(day: day)

            #expect(viewModel.canOpen == true)
        }
    }

    @Test("Day 2 cannot open on Dec 1")
    func day2CannotOpenOnDec1() {
        withDependencies {
            $0.date = .fixed(month: 12, day: 1)
        } operation: {
            let day = AdventDay(day: 2, videoURL: "", title: "Day 2")
            let viewModel = AdventDayCellViewModel(day: day)

            #expect(viewModel.canOpen == false)
        }
    }

    @Test("Days 1-15 can open on Dec 15")
    func days1to15CanOpenOnDec15() {
        withDependencies {
            $0.date = .fixed(month: 12, day: 15)
        } operation: {
            for dayNumber in 1...15 {
                let day = AdventDay(day: dayNumber, videoURL: "", title: "Day \(dayNumber)")
                let viewModel = AdventDayCellViewModel(day: day)

                #expect(viewModel.canOpen == true, "Day \(dayNumber) should be openable on Dec 15")
            }
        }
    }

    @Test("Days 16-25 cannot open on Dec 15")
    func days16to25CannotOpenOnDec15() {
        withDependencies {
            $0.date = .fixed(month: 12, day: 15)
        } operation: {
            for dayNumber in 16...25 {
                let day = AdventDay(day: dayNumber, videoURL: "", title: "Day \(dayNumber)")
                let viewModel = AdventDayCellViewModel(day: day)

                #expect(viewModel.canOpen == false, "Day \(dayNumber) should not be openable on Dec 15")
            }
        }
    }

    @Test("All days can open on Dec 25")
    func allDaysCanOpenOnDec25() {
        withDependencies {
            $0.date = .fixed(month: 12, day: 25)
        } operation: {
            for dayNumber in 1...25 {
                let day = AdventDay(day: dayNumber, videoURL: "", title: "Day \(dayNumber)")
                let viewModel = AdventDayCellViewModel(day: day)

                #expect(viewModel.canOpen == true, "Day \(dayNumber) should be openable on Dec 25")
            }
        }
    }

    @Test("No days can open in November")
    func noDaysCanOpenInNovember() {
        withDependencies {
            $0.date = .fixed(month: 11, day: 30)
        } operation: {
            for dayNumber in 1...25 {
                let day = AdventDay(day: dayNumber, videoURL: "", title: "Day \(dayNumber)")
                let viewModel = AdventDayCellViewModel(day: day)

                #expect(viewModel.canOpen == false, "Day \(dayNumber) should not be openable in November")
            }
        }
    }

    @Test("No days can open in January")
    func noDaysCanOpenInJanuary() {
        withDependencies {
            $0.date = .fixed(month: 1, day: 15)
        } operation: {
            for dayNumber in 1...25 {
                let day = AdventDay(day: dayNumber, videoURL: "", title: "Day \(dayNumber)")
                let viewModel = AdventDayCellViewModel(day: day)

                #expect(viewModel.canOpen == false, "Day \(dayNumber) should not be openable in January")
            }
        }
    }

    // MARK: - Debug Mode Tests

    @Test("All days can open in debug mode regardless of date")
    func allDaysCanOpenInDebugMode() {
        withDependencies {
            $0.date = .fixed(month: 11, day: 1)
        } operation: {
            for dayNumber in 1...25 {
                let day = AdventDay(day: dayNumber, videoURL: "", title: "Day \(dayNumber)")
                let viewModel = AdventDayCellViewModel(day: day, isDebugMode: true)

                #expect(viewModel.canOpen == true, "Day \(dayNumber) should be openable in debug mode")
            }
        }
    }

    // MARK: - isToday Tests

    @Test("isToday returns true for matching day in December")
    func isTodayReturnsTrueForMatchingDay() {
        withDependencies {
            $0.date = .fixed(month: 12, day: 10)
        } operation: {
            let day = AdventDay(day: 10, videoURL: "", title: "Day 10")
            let viewModel = AdventDayCellViewModel(day: day)

            #expect(viewModel.isToday == true)
        }
    }

    @Test("isToday returns false for non-matching day")
    func isTodayReturnsFalseForNonMatchingDay() {
        withDependencies {
            $0.date = .fixed(month: 12, day: 10)
        } operation: {
            let day = AdventDay(day: 5, videoURL: "", title: "Day 5")
            let viewModel = AdventDayCellViewModel(day: day)

            #expect(viewModel.isToday == false)
        }
    }

    @Test("isToday returns false in non-December months")
    func isTodayReturnsFalseInNonDecember() {
        withDependencies {
            $0.date = .fixed(month: 11, day: 10)
        } operation: {
            let day = AdventDay(day: 10, videoURL: "", title: "Day 10")
            let viewModel = AdventDayCellViewModel(day: day)

            #expect(viewModel.isToday == false)
        }
    }
}
