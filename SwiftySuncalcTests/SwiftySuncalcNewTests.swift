import XCTest
@testable import SwiftySuncalc

final class SwiftySuncalcNewTests: XCTestCase {
    let referenceDay = Date(year: 2013, month: 3, day: 4, zone: "PDT", hour: 16, minute: 0, second: 0)
    let referenceCoordinate = Coordinate(latitude: 50.5, longitude: 30.5)
    
    func testSunSchedule() {
        let referenceSunSchedule = SunSchedule(
            solarNoon: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 10, minute: 10, second: 57),
            nadir: Date(year: 2013, month: 3, day: 4, zone: "UTC", hour: 22, minute: 10, second: 57),
            sunrise: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 4, minute: 34, second: 56),
            sunset: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 15, minute: 46, second: 57),
            sunriseEnd: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 4, minute: 38, second: 19),
            sunsetStart: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 15, minute: 43, second: 34),
            dawn: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 4, minute: 2, second: 17),
            dusk: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 16, minute: 19, second: 36),
            nauticalDawn: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 3, minute: 24, second: 31),
            nauticalDusk: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 16, minute: 57, second: 22),
            nightEnd: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 2, minute: 46, second: 17),
            night: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 17, minute: 35, second: 36),
            goldenHourEnd: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 5, minute: 19, second: 1),
            goldenHour: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 15, minute: 2, second: 52)
        )
        
        let sunSchedule = SwiftySuncalcNew.sunSchedule(
            for: referenceDay,
            at: referenceCoordinate
        )
        
        XCTAssertEqual(sunSchedule, referenceSunSchedule)
    }
    
    func testTimeForSunAngle() {
        let referenceSunAngleTimes = SunAngleTimes(
            rising: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 7, minute: 23, second: 37),
            setting: Date(year: 2013, month: 3, day: 5, zone: "UTC", hour: 12, minute: 58, second: 16)
        )
        
        let sunAngleTimes = SwiftySuncalcNew.times(
            ofSunAngle: 23,
            for: referenceDay,
            at: referenceCoordinate
        )
        
        XCTAssertEqual(sunAngleTimes, referenceSunAngleTimes)
    }
    
    func testSunPosition() {
        let referenceAzimuth = -2.5003175907168385
        let referenceAltitude = -0.7000406838781611
        
        let sunPosition = SwiftySuncalcNew.sunPosition(
            for: referenceDay,
            at: referenceCoordinate
        )
        
        XCTAssertEqual(sunPosition.azimuth, referenceAzimuth, accuracy: .ulpOfOne)
        XCTAssertEqual(sunPosition.altitude, referenceAltitude, accuracy: .ulpOfOne)
    }
    
    func testMoonSchedule() {
        let referenceMoonSchedule = MoonSchedule(
            rise: Date(year: 2013, month: 3, day: 4, zone: "GMT", hour: 23, minute: 54, second: 18),
            set: Date(year: 2013, month: 3, day: 5, zone: "GMT", hour: 8, minute: 44, second: 29)
        )
        
        let moonSchedule = SwiftySuncalcNew.moonSchedule(
            for: referenceDay,
            at: referenceCoordinate
        )
        
        XCTAssertEqual(moonSchedule, referenceMoonSchedule)
    }
    
    func testMoonPosition() {
        let referenceAzimuth = -0.9783999522438226
        let referenceAltitude = 0.014551482243892251
        let referenceDistance = 364121.37256256194
        
        let moonPosition = SwiftySuncalcNew.moonPosition(
            for: referenceDay,
            at: referenceCoordinate
        )
        
        XCTAssertEqual(moonPosition.azimuth, referenceAzimuth, accuracy: .ulpOfOne)
        XCTAssertEqual(moonPosition.altitude, referenceAltitude, accuracy: .ulpOfOne)
        XCTAssertEqual(moonPosition.distance, referenceDistance, accuracy: .ulpOfOne)
    }
    
    func testMoonIllumination() {
        let referenceFraction = 0.4848068202456373
        let referencePhase = 0.7548368838538762
        let referenceAngle = 1.6732942678578346
        
        let moonIllumination = SwiftySuncalcNew.moonIllumination(
            for: referenceDay
        )
        
        XCTAssertEqual(moonIllumination.fraction, referenceFraction, accuracy: .ulpOfOne)
        XCTAssertEqual(moonIllumination.phase, referencePhase, accuracy: .ulpOfOne)
        XCTAssertEqual(moonIllumination.angle, referenceAngle, accuracy: .ulpOfOne)
    }
}

private extension Date {
    init(
        year: Int,
        month: Int,
        day: Int,
        zone: String,
        hour: Int,
        minute: Int,
        second: Int
    ) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: zone)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        self = Calendar.current.date(from: dateComponents)!
    }
}
