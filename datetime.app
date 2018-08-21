module elib/elib-utils/datetime

  function latest(t1: DateTime, t2: DateTime): DateTime {
  	if(t1 == null) { return t2; }
  	if(t2 == null) { return t1; }
  	if(t1.after(t2)) { return t1; } else { return t2; }
  }
  
  function earliest(t1: DateTime, t2: DateTime): DateTime {
  	if(t1 == null) { return t2; }
  	if(t2 == null) { return t1; }
  	if(t1.before(t2)) { return t1; } else { return t2; }
  }

  function age(now: DateTime, time : DateTime) : String {
    var thenTime : Long := time.getTime();
    var nowTime : Long := now.getTime();
    var sign := "";
    var interval : Long := (nowTime - thenTime) / 60000L;
    if(interval < 0){
    	sign := "-";
    	interval := 0-interval;
    }
    
    if(interval < 2)  { return sign + "1 minute"; }
    if(interval < 100) { return sign + interval + " minutes"; }
    if(interval < 120) { return  sign + "2 hours"; }
    interval := interval / 60L;
    if(interval < 24) { return sign + interval + " hours"; }
    if(interval < 36) { return sign + "1 day"; }
    if(interval < 48) { return sign + "2 days"; }
    interval := interval / 24L;
    if(interval <= 30) { return sign + interval + " days"; }
    interval := 1 + interval / 30L;
    if(interval <= 12) { return sign + interval + " months"; }
    interval := interval / 12L;
    return sign + interval + " years";
  }
  
  function age(time : DateTime) : String {
  	return age(now(), time);
  }
  
  function remaining(time: DateTime): String {
  	return age(time, now());
  }

  function seconds(x : Long) : Long {
    var factor : Long := 1000L;
    return factor * x;
  }

  function minutes(x : Long) : Long {
    var factor : Long := 60L;
    return seconds(x * factor);
  }

  function hours(x : Long) : Long {
    var factor : Long := 60L;
    return minutes(factor * x);
  }

  function days(x : Long) : Long {
    var factor : Long := 24L;
    return hours(x * factor);
  }

  function nextday(time : DateTime) : DateTime {
    var nextday : DateTime := now();
    //log(" time == null: " + (time == null));
    nextday.setTime(time.getTime() + days(1L));
    return nextday;
  }
  
  function add(x : DateTime, y : DateTime) : DateTime {
    var z : DateTime := now();
    z.setTime(x.getTime() + y.getTime());
    return z;
  }
  
  function add(x: DateTime, y: Long): DateTime {
    var z : DateTime := now();
    z.setTime(x.getTime() + y);
    return z;
  }

  function numberof(i : Int, one : String, many : String) : String {
    if(i <= 0) { return "no " + many; }
    if(i == 1) { return "one " + one; }
    return i + " " + many;
  }
  
  function days(start : Date, end : Date) : List<Date> {
    var days : List<Date>;
    if(start != null) {
      if(end == null) {
        days.add(start);
      } else {
        var next := start;
        while(!next.after(end)) {
          //log("next day: " + next);
          days.add(next);
          next := nextday(next);
        }
      }
    }
    return days;
  }
  
  function diff(t1: DateTime, t2 : DateTime): Long {
  	return t1.getTime() - t2.getTime();
  }
  
  function diffMinnutes(t1: DateTime, t2 : DateTime): Long {
  	return diff(t1, t2) / (1000L * 60L);
  }
  
  function diffHours(t1: DateTime, t2 : DateTime): Long {
  	return diffMinnutes(t1, t2) / 60L;
  }
  
  function diffDays(t1: DateTime, t2 : DateTime): Long {
  	return diffHours(t1, t2) / 24L;
  }
  function diffDateDays(t1: DateTime, t2 : DateTime): Long {
  	var normalized1 := DateTime( t1.getDay() + "-" + (t1.getMonth()+1) + "-" + t1.getYear() + " 12:00", "d-M-yyyy HH:mm");
  	var normalized2 := DateTime( t2.getDay() + "-" + (t2.getMonth()+1) + "-" + t2.getYear() + " 12:00", "d-M-yyyy HH:mm");
  	var day1 := normalized1.getTime() / (24L*60L*60L*1000L);
  	var day2 := normalized2.getTime() / (24L*60L*60L*1000L);
  	return day1 - day2;
  }
  
  function easterDayOfYear( year : Int ) : Int{
    case(year){
      2014{ return 110; }
      2015{ return 95;  }
      2016{ return 87;  }
      2017{ return 106; }
      2018{ return 91;  }
      2019{ return 111; }
      2020{ return 103; }
      2021{ return 94;  }
      2022{ return 107; }
      2023{ return 99;  }
      2024{ return 91;  }
      2025{ return 110; }
      2026{ return 95;  }
      2027{ return 87;  }
      default{ return -1; }
    }
  }
  
  //Based on server time, it returns true for weekend days (Sa+Sun) and Easter, Good Friday, Ascension Day, Ascension, Christmass and new years day
  //When working hours are considered, it returns true from 18.00 to 7.59
  function isRestDay( considerWorkingHours : Bool ) : Bool{
    var now := now();
    var easterDayOfYear := easterDayOfYear( now.getYear() );
    var doy := now.getDayOfYear();
    
    var d := now.getDay();
    var m := now.getMonth();    
    var day := now.format("EEE").toLowerCase();
    var hour := now.getHour();
    var restTime := considerWorkingHours && (hour < 8 || hour > 17);
    return restTime || day == "sat"
        || day == "sun"
        || doy+2 == easterDayOfYear || doy == easterDayOfYear || doy-1 == easterDayOfYear //Good Friday, Easter
        || doy == easterDayOfYear+39 || doy == easterDayOfYear+49 || doy == easterDayOfYear+50 //Ascension day, Ascension
        || ( d == 5 && m == 5)  // lib day
        || ( d == 1 && m == 1)  // new year
        || ( (d == 25 || d == 26) && m == 12); //christmass   
  }
  
  native class java.sql.Timestamp as Timestamp : DateTime {
    constructor(Int)
  }
