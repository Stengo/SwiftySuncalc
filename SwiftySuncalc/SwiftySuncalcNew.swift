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

public enum SwiftySuncalcNew {
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
    
    public static func time(
        ofSunAngle angle: Double,
        for date: Date,
        at coordinate: Coordinate
    ) -> Date {
        let name = "angle"
        suncalc.addTime(
            angle: angle,
            riseName: name,
            setName: ""
        )
        let times = suncalc.getTimes(
            date: date,
            lat: coordinate.latitude,
            lng: coordinate.longitude
        )
        return times["angle"]!
    }
    
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
