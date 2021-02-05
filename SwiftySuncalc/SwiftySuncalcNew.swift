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
        let sunPosition = suncalc.getPosition(
            date: date,
            lat: coordinate.latitude,
            lng: coordinate.longitude
        )
        return SunPosition(
            azimuth: sunPosition["azimuth"]!,
            altitude: sunPosition["altitude"]!
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
}
