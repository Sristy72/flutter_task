class PrayerResponseModel {
  final String status;
  final PrayerLocation location;
  final PrayerMethod method;
  final AsrJuristicMethod asrJuristicMethod;
  final PrayerDate date;
  final PrayerTimings timings;
  final NextPrayer nextPrayer;
  final DailyGoal dailyGoal;
  final PrayerStreak streak;
  final AiReflection aiReflection;
  final AbundanceVerse? abundanceVerse;

  const PrayerResponseModel({
    required this.status,
    required this.location,
    required this.method,
    required this.asrJuristicMethod,
    required this.date,
    required this.timings,
    required this.nextPrayer,
    required this.dailyGoal,
    required this.streak,
    required this.aiReflection,
    this.abundanceVerse,
  });

  factory PrayerResponseModel.fromJson(Map<String, dynamic> json) {
    return PrayerResponseModel(
      status: json['status']?.toString() ?? '',
      location: PrayerLocation.fromJson(
        json['location'] as Map<String, dynamic>? ?? {},
      ),
      method: PrayerMethod.fromJson(
        json['method'] as Map<String, dynamic>? ?? {},
      ),
      asrJuristicMethod: AsrJuristicMethod.fromJson(
        json['asr_juristic_method'] as Map<String, dynamic>? ?? {},
      ),
      date: PrayerDate.fromJson(
        json['date'] as Map<String, dynamic>? ?? {},
      ),
      timings: PrayerTimings.fromJson(
        json['timings'] as Map<String, dynamic>? ?? {},
      ),
      nextPrayer: NextPrayer.fromJson(
        json['next_prayer'] as Map<String, dynamic>? ?? {},
      ),
      dailyGoal: DailyGoal.fromJson(
        json['daily_goal'] as Map<String, dynamic>? ?? {},
      ),
      streak: PrayerStreak.fromJson(
        json['streak'] as Map<String, dynamic>? ?? {},
      ),
      aiReflection: AiReflection.fromJson(
        json['ai_reflection'] as Map<String, dynamic>? ?? {},
      ),
      abundanceVerse: json['abundance_verse'] != null
          ? AbundanceVerse.fromJson(json['abundance_verse'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'location': location.toJson(),
      'method': method.toJson(),
      'asr_juristic_method': asrJuristicMethod.toJson(),
      'date': date.toJson(),
      'timings': timings.toJson(),
      'next_prayer': nextPrayer.toJson(),
      'daily_goal': dailyGoal.toJson(),
      'streak': streak.toJson(),
      'ai_reflection': aiReflection.toJson(),
      if (abundanceVerse != null) 'abundance_verse': abundanceVerse!.toJson(),
    };
  }
}

// Location
class PrayerLocation {
  final String latitude;
  final String longitude;
  final String address;
  final String city;
  final String countryCode;
  final String timezone;

  const PrayerLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.countryCode,
    required this.timezone,
  });

  factory PrayerLocation.fromJson(Map<String, dynamic> json) {
    return PrayerLocation(
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      timezone: json['timezone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'country_code': countryCode,
        'timezone': timezone,
      };
}

// Prayer calculation method
class PrayerMethod {
  final int id;
  final String name;

  const PrayerMethod({
    required this.id,
    required this.name,
  });

  factory PrayerMethod.fromJson(Map<String, dynamic> json) {
    return PrayerMethod(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

// Asr juristic method
class AsrJuristicMethod {
  final int id;
  final String key;
  final String name;
  final String description;

  const AsrJuristicMethod({
    required this.id,
    required this.key,
    required this.name,
    required this.description,
  });

  factory AsrJuristicMethod.fromJson(Map<String, dynamic> json) {
    return AsrJuristicMethod(
      id: (json['id'] as num?)?.toInt() ?? 0,
      key: json['key']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'key': key,
        'name': name,
        'description': description,
      };
}

// Gregorian and Hijri dates
class PrayerDate {
  final GregorianDate gregorian;
  final HijriDate hijri;

  const PrayerDate({
    required this.gregorian,
    required this.hijri,
  });

  factory PrayerDate.fromJson(Map<String, dynamic> json) {
    return PrayerDate(
      gregorian: GregorianDate.fromJson(
        json['gregorian'] as Map<String, dynamic>? ?? {},
      ),
      hijri: HijriDate.fromJson(
        json['hijri'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'gregorian': gregorian.toJson(),
        'hijri': hijri.toJson(),
      };
}

class GregorianDate {
  final String date;
  final String weekdayEn;

  const GregorianDate({
    required this.date,
    required this.weekdayEn,
  });

  factory GregorianDate.fromJson(Map<String, dynamic> json) {
    return GregorianDate(
      date: json['date']?.toString() ?? '',
      weekdayEn: json['weekday_en']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'weekday_en': weekdayEn,
      };
}

class HijriDate {
  final String date;
  final int day;
  final String monthEn;
  final int year;

  const HijriDate({
    required this.date,
    required this.day,
    required this.monthEn,
    required this.year,
  });

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: json['date']?.toString() ?? '',
      day: (json['day'] as num?)?.toInt() ?? 1,
      monthEn: json['month_en']?.toString() ?? '',
      year: (json['year'] as num?)?.toInt() ?? 1448,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'day': day,
        'month_en': monthEn,
        'year': year,
      };
}

// Prayer timings
class PrayerTimings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const PrayerTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    return PrayerTimings(
      fajr: json['Fajr']?.toString() ?? '',
      sunrise: json['Sunrise']?.toString() ?? '',
      dhuhr: json['Dhuhr']?.toString() ?? '',
      asr: json['Asr']?.toString() ?? '',
      maghrib: json['Maghrib']?.toString() ?? '',
      isha: json['Isha']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Maghrib': maghrib,
        'Isha': isha,
      };
}

// Next prayer
class NextPrayer {
  final String name;
  final String at;
  final int secondsUntil;

  const NextPrayer({
    required this.name,
    required this.at,
    required this.secondsUntil,
  });

  factory NextPrayer.fromJson(Map<String, dynamic> json) {
    return NextPrayer(
      name: json['name']?.toString() ?? '',
      at: json['at']?.toString() ?? '',
      secondsUntil: (json['seconds_until'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'at': at,
        'seconds_until': secondsUntil,
      };
}

// Daily prayer goal
class DailyGoal {
  final int completed;
  final int target;

  const DailyGoal({
    required this.completed,
    required this.target,
  });

  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      target: (json['target'] as num?)?.toInt() ?? 5,
    );
  }

  Map<String, dynamic> toJson() => {
        'completed': completed,
        'target': target,
      };
}

// Prayer streak
class PrayerStreak {
  final int current;
  final int longest;
  final bool countedToday;
  final String? lastCountedDate;

  const PrayerStreak({
    required this.current,
    required this.longest,
    required this.countedToday,
    this.lastCountedDate,
  });

  factory PrayerStreak.fromJson(Map<String, dynamic> json) {
    return PrayerStreak(
      current: (json['current'] as num?)?.toInt() ?? 0,
      longest: (json['longest'] as num?)?.toInt() ?? 0,
      countedToday: json['counted_today'] as bool? ?? false,
      lastCountedDate: json['last_counted_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'current': current,
        'longest': longest,
        'counted_today': countedToday,
        'last_counted_date': lastCountedDate,
      };
}

// AI reflection
class AiReflection {
  final String text;
  final String source;
  final String? forDate;

  const AiReflection({
    required this.text,
    required this.source,
    this.forDate,
  });

  factory AiReflection.fromJson(Map<String, dynamic> json) {
    return AiReflection(
      text: json['text']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      forDate: json['for_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'source': source,
        'for_date': forDate,
      };
}

// Quran verse
class AbundanceVerse {
  final String kind;
  final String arabic;
  final String translation;
  final String reference;

  const AbundanceVerse({
    required this.kind,
    required this.arabic,
    required this.translation,
    required this.reference,
  });

  factory AbundanceVerse.fromJson(Map<String, dynamic> json) {
    return AbundanceVerse(
      kind: json['kind']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      translation: json['translation']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'kind': kind,
        'arabic': arabic,
        'translation': translation,
        'reference': reference,
      };
}
