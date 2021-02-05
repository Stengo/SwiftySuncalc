import Foundation

private let suncalc = SwiftySuncalc()

public struct SunPosition {
    let azimuth: Double
    let altitude: Double
}

public struct MoonPosition {
    let azimuth: Double
    let altitude: Double
    let distance: Double
    let parallacticAngle: Double
}

public struct MoonIllumination {
    let fraction: Double
    let phase: Double
    let angle: Double
}

public struct Coordinate {
    let latitude: Double
    let longitude: Double
    
    public init(
        latitude: Double,
        longitude: Double
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public struct SunSchedule: Equatable {
    let solarNoon: Date
    let nadir: Date
    let sunrise: Date
    let sunset: Date
    let sunriseEnd: Date
    let sunsetStart: Date
    let dawn: Date
    let dusk: Date
    let nauticalDawn: Date
    let nauticalDusk: Date
    let nightEnd: Date
    let night: Date
    let goldenHourEnd: Date
    let goldenHour: Date
}

public struct MoonSchedule: Equatable {
    let rise: Date?
    let set: Date?
}

public struct SunAngleTimes: Equatable {
    let rising: Date
    let setting: Date
}

private struct SunCoordinates: Equatable {
    let declination: Double
    let rightAscension: Double
}

public enum SwiftySuncalcNew {
    /**
    Returns the relative position of the sun for a given time and place.

    - parameters:
        - date: The time for which to calculate the sun position.
        - coordinate: The place for which to calculate the sun position.
     */
    public static func sunPosition(
        for date: Date,
        at coordinate: Coordinate
    ) -> SunPosition {
        let longitude = radians(for: -coordinate.longitude)
        let latitude = radians(for: coordinate.latitude)
        let daysSince2000 = date.daysSince2000
        
        let sunCoordinates = self.sunCoordinates(forDaysSince2000: daysSince2000)
        let hourAngle = siderealTime(forDaysSince2000: daysSince2000, longitude: longitude) - sunCoordinates.rightAscension
        
        return SunPosition(
            azimuth: azimuth(forHourAngle: hourAngle, latitude: latitude, declination: sunCoordinates.declination),
            altitude: altitude(forHourAngle: hourAngle, latitude: latitude, declination: sunCoordinates.declination)
        )
    }
    
    /**
    Returns significant time markers in the sun's cycle for a given day and place.

    - parameters:
        - date: The day for which to calculate the sun schedule.
        - coordinate: The place for which to calculate the sun schedule.
     */
    public static func sunSchedule(
        for date: Date,
        at coordinate: Coordinate
    ) -> SunSchedule {
        let sunTimes = suncalc.getTimes(
            date: date,
            lat: coordinate.latitude,
            lng: coordinate.longitude
        )
        return SunSchedule(
            solarNoon: sunTimes["solarNoon"]!,
            nadir: sunTimes["nadir"]!,
            sunrise: sunTimes["sunrise"]!,
            sunset: sunTimes["sunset"]!,
            sunriseEnd: sunTimes["sunriseEnd"]!,
            sunsetStart: sunTimes["sunsetStart"]!,
            dawn: sunTimes["dawn"]!,
            dusk: sunTimes["dusk"]!,
            nauticalDawn: sunTimes["nauticalDawn"]!,
            nauticalDusk: sunTimes["nauticalDusk"]!,
            nightEnd: sunTimes["nightEnd"]!,
            night: sunTimes["night"]!,
            goldenHourEnd: sunTimes["goldenHourEnd"]!,
            goldenHour: sunTimes["goldenHour"]!
        )
    }
    
    /**
    Returns the time at which the sun reaches an angle for a given day and place.

    - parameters:
        - angle: The angle for which to calculate the time.
        - date: The day for which to calculate the time.
        - coordinate: The place for which to calculate the time.
     */
    public static func times(
        ofSunAngle angle: Double,
        for date: Date,
        at coordinate: Coordinate
    ) -> SunAngleTimes {
        let rising = "rising"
        let setting = "setting"
        suncalc.addTime(
            angle: angle,
            riseName: rising,
            setName: setting
        )
        let times = suncalc.getTimes(
            date: date,
            lat: coordinate.latitude,
            lng: coordinate.longitude
        )
        return SunAngleTimes(
            rising: times[rising]!,
            setting: times[setting]!
        )
    }
    
    /**
    Returns the relative position of the moon for a given time and place.

    - parameters:
        - date: The time for which to calculate the moon position.
        - coordinate: The place for which to calculate the moon position.
     */
    public static func moonPosition(
        for date: Date,
        at coordiante: Coordinate
    ) -> MoonPosition {
        let moonPosition = suncalc.getMoonPosition(
            date: date,
            lat: coordiante.latitude,
            lng: coordiante.longitude
        )
        return MoonPosition(
            azimuth: moonPosition["azimuth"]!,
            altitude: moonPosition["altitude"]!,
            distance: moonPosition["distance"]!,
            parallacticAngle: moonPosition["parallacticAngle"]!
        )
    }
    
    /**
    Returns the illumination of the moon for a given time and place.

    - parameters:
        - date: The time for which to calculate the moon illumination.
     */
    public static func moonIllumination(
        for date: Date
    ) -> MoonIllumination {
        let moonIllumination = suncalc.getMoonIllumination(date: date)
        return MoonIllumination(
            fraction: moonIllumination["fraction"]!,
            phase: moonIllumination["phase"]!,
            angle: moonIllumination["angle"]!
        )
    }
    
    /**
    Returns significant time markers in the moon's cycle for a given day and place.

    - parameters:
        - date: The day for which to calculate the moon schedule.
        - coordinate: The place for which to calculate the moon schedule.
     */
    public static func moonSchedule(
        for date: Date,
        at coordinate: Coordinate
    ) -> MoonSchedule {
        let moonTimes = suncalc.getMoonTimes(
            date: date,
            lat: coordinate.latitude,
            lng: coordinate.longitude
        )
        return MoonSchedule(
            rise: moonTimes["rise"]!,
            set: moonTimes["set"]!
        )
    }
    
    private static let obliquityOfTheEcliptic = radians(for: 23.4397)
    
    static private func radians(for degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    static private func azimuth(forHourAngle hourAngle: Double, latitude: Double, declination: Double) -> Double {
        return atan2(
            sin(hourAngle),
            cos(hourAngle) * sin(latitude) - tan(declination) * cos(latitude)
        )
    }
    
    static private func altitude(forHourAngle hourAngle: Double, latitude: Double, declination: Double) -> Double {
        return asin(sin(latitude) * sin(declination) + cos(latitude) * cos(declination) * cos(hourAngle))
    }
    
    static private func siderealTime(forDaysSince2000 daysSince2000: Double, longitude: Double) -> Double {
        let siderealTimeAtLongitudeZeroAtStartOf2000 = 280.16
        let rotationPerDay = 360.9856235
        let siderealTimeAtLongitudeZero = siderealTimeAtLongitudeZeroAtStartOf2000 + (rotationPerDay * daysSince2000)
        return radians(for: siderealTimeAtLongitudeZero) - longitude
    }
    
    static private func sunCoordinates(forDaysSince2000 daysSince2000: Double) -> SunCoordinates {
        let solarMeanAnomaly = self.solarMeanAnomaly(forDaysSince2000: daysSince2000)
        let eclipticLongitude = self.eclipticLongitude(forSolarMeanAnomaly: solarMeanAnomaly)
        let declination = self.declination(forEclipticLongitude: eclipticLongitude)
        let rightAcension = self.rightAscension(forEclipticLongitude: eclipticLongitude)
        return SunCoordinates(
            declination: declination,
            rightAscension: rightAcension
        )
    }
    
    static private func solarMeanAnomaly(forDaysSince2000 daysSince2000: Double) -> Double {
        let meanAnomalyAtStartOf2000 = 357.5291
        let rateOfChange = 0.98560028
        let meanAnomaly = meanAnomalyAtStartOf2000 + (rateOfChange * daysSince2000)
        return radians(for: meanAnomaly)
    }
    
    static private func eclipticLongitude(forSolarMeanAnomaly solarMeanAnomaly: Double) -> Double {
        let equationOfTheCenter = self.equationOfTheCenter(forSolarMeanAnomaly: solarMeanAnomaly)
        let perihelion = radians(for: 102.9372)
        return solarMeanAnomaly + equationOfTheCenter + perihelion + .pi
    }
    
    static private func equationOfTheCenter(forSolarMeanAnomaly solarMeanAnomaly: Double) -> Double {
        return radians(for: 1.9148 * sin(solarMeanAnomaly) + 0.02 * sin(2.0 * solarMeanAnomaly) + 0.0003 * sin(3.0 * solarMeanAnomaly))
    }
    
    static private func declination(forEclipticLongitude eclipticLongitude: Double) -> Double {
        return asin(sin(eclipticLongitude) * sin(obliquityOfTheEcliptic))
    }
    
    static private func rightAscension(forEclipticLongitude eclipticLongitude: Double) -> Double {
        return atan2(
            sin(eclipticLongitude) * cos(obliquityOfTheEcliptic),
            cos(eclipticLongitude)
        )
    }
}

private let secondsPerDay: Double = 60 * 60 * 24
private let julianDaysUntil1970: Double = 2440588
private let julianDaysUntil2000: Double = 2451545
private extension Date {
    var julianDays: Double {
        let daysSince1970 = timeIntervalSince1970 / secondsPerDay
        return Double(daysSince1970 - 0.5 + julianDaysUntil1970)
    }
    
    var daysSince2000: Double {
        return julianDays - julianDaysUntil2000
    }
    
    init(julianDays: Double) {
        let daysSince1970 = julianDays + 0.5 - julianDaysUntil1970
        self.init(timeIntervalSince1970: daysSince1970 * secondsPerDay)
    }
}
