package com.main;

import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

public class Utils {
	
	public static Date getDateWithTimezone() {
		Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Europe/Madrid"));
		return calendar.getTime();
	}
}
