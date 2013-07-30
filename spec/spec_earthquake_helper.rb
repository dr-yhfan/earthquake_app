module SpecEarthquakeHelper
  def populate_earthquakes
    Earthquake.parse_csv(test_data)
  end
  
  def clear_earthquakes
    Earthquake.delete_all
  end
  
  def all_data_array
    expected_data_all
  end
  
  def since_data_array
    # expected result since 1374966000 = 2013-07-27T23:00:00Z
    expected_data_all[0..22]
  end
  
  def on_data_array
    # expected result on 1374966000 = 2013-07-27T23:00:00Z
    expected_data_all[19..138]
  end
  
  def over_data_array
    # expected result over magnitude 4.0
    expected_data_all.values_at(28, 29, 38, 41, 44, 45, 54, 55, 56, 78, 79, 85, 90, 98, 100, 114, 117, 131, 132, 133, 134, 149, 155, 158, 160, 174, 177, 179, 185)
  end
  
  def near_data_array
    # expected result within a 5-mile radius of a point in Los Angeles, (33.98, -117.15)
    expected_data_all.values_at(0, 121, 127, 128, 129)
  end
  
  def all_parameters_data_array
    # expected result for...
    #   since 1374886800 = 2013-07-27T01:00:00Z
    #   on 1374886800
    #   over 1.2
    #   near (33.98, -117.15)
    expected_data_all.values_at(121, 129)
  end
  
  define_method :do_test do |parameters, expected_result|
    if parameters.present?
      parameter_collection = parameters.inject({}) do |collection, item|
        collection[item[0]] = item[1]
        collection
      end
      parameter_collection[:format] = :json
      get 'earthquakes', parameter_collection
    else
      get 'earthquakes', format: :json
    end
    response.should be_success
    
    records = JSON.parse(response.body)
    records.size.should == expected_result.size
    
    records.each_with_index do |r, n|
      @essential_fields.each do |c|
        r[c].should == expected_result[n][c]
      end
    end
  end

  private
  
  def test_data
    "Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region\r\n" +
    "ci,11340418,2,\"Sunday, July 28, 2013 05:00:10 UTC\",34.0115,-117.1838,1.0,7.70,18,\"Greater Los Angeles area, California\"\r\n" +
    "ak,10768318,1,\"Sunday, July 28, 2013 04:43:32 UTC\",60.1361,-141.4384,1.8,0.60,13,\"Southern Alaska\"\r\n" +
    "nc,72035290,0,\"Sunday, July 28, 2013 04:39:44 UTC\",38.7922,-122.8083,1.0,3.70,18,\"Northern California\"\r\n" +
    "nc,72035285,0,\"Sunday, July 28, 2013 04:09:26 UTC\",36.6508,-121.2683,1.0,8.90, 6,\"Central California\"\r\n" +
    "nc,72035275,0,\"Sunday, July 28, 2013 04:01:34 UTC\",37.6718,-119.0092,1.1,0.20, 5,\"Long Valley area, California\"\r\n" +
    "nn,00418875,1,\"Sunday, July 28, 2013 03:29:54 UTC\",39.0850,-119.0675,1.4,27.00,14,\"Nevada\"\r\n" +
    "ak,10768301,1,\"Sunday, July 28, 2013 03:24:22 UTC\",56.4276,-154.5349,2.5,8.00, 6,\"Kodiak Island region, Alaska\"\r\n" +
    "ak,10768294,1,\"Sunday, July 28, 2013 03:19:04 UTC\",60.5700,-152.0219,2.7,90.00,39,\"Southern Alaska\"\r\n" +
    "nc,72035235,0,\"Sunday, July 28, 2013 03:06:05 UTC\",38.8240,-122.7965,1.1,3.20,20,\"Northern California\"\r\n" +
    "nn,00418874,1,\"Sunday, July 28, 2013 02:34:47 UTC\",38.6580,-119.8163,1.3,8.10, 5,\"Northern California\"\r\n" +
    "nn,00418872,1,\"Sunday, July 28, 2013 01:51:18 UTC\",38.6237,-118.4575,1.6,7.30,22,\"Nevada\"\r\n" +
    "ak,10768286,1,\"Sunday, July 28, 2013 01:30:38 UTC\",62.9256,-148.7069,1.1,8.20,10,\"Central Alaska\"\r\n" +
    "ci,11340394,2,\"Sunday, July 28, 2013 01:20:38 UTC\",35.7452,-117.6490,1.8,3.60,33,\"Southern California\"\r\n" +
    "us,c000iqz3,6,\"Sunday, July 28, 2013 01:04:49 UTC\",35.0585,-97.8951,2.8,4.80,14,\"Oklahoma\"\r\n" +
    "ak,10768278,1,\"Sunday, July 28, 2013 01:01:48 UTC\",63.5901,-150.6671,1.3,4.60, 8,\"Central Alaska\"\r\n" +
    "ak,10768275,1,\"Sunday, July 28, 2013 00:54:07 UTC\",59.3718,-152.4939,2.1,87.20,22,\"Southern Alaska\"\r\n" +
    "ak,10768272,1,\"Sunday, July 28, 2013 00:49:30 UTC\",63.4316,-147.5429,1.0,0.00, 6,\"Central Alaska\"\r\n" +
    "ci,11340378,2,\"Sunday, July 28, 2013 00:47:17 UTC\",36.5038,-117.9188,1.9,9.00,13,\"Central California\"\r\n" +
    "nc,72035200,1,\"Sunday, July 28, 2013 00:18:30 UTC\",35.5513,-120.7835,2.6,4.60,73,\"Central California\"\r\n" +
    "nn,00418867,1,\"Saturday, July 27, 2013 23:53:54 UTC\",38.9352,-118.8163,1.1,17.80, 7,\"Nevada\"\r\n" +
    "nn,00418865,1,\"Saturday, July 27, 2013 23:49:48 UTC\",38.9357,-118.8168,1.0,19.50, 5,\"Nevada\"\r\n" +
    "ci,11340362,2,\"Saturday, July 27, 2013 23:25:07 UTC\",35.4855,-118.2930,1.3,1.70,20,\"Central California\"\r\n" +
    "uw,60559447,2,\"Saturday, July 27, 2013 23:24:05 UTC\",48.0505,-123.4008,1.9,40.50,22,\"Olympic Peninsula, Washington\"\r\n" +
    "ak,10768255,1,\"Saturday, July 27, 2013 22:59:09 UTC\",61.0248,-147.1599,1.6,21.00, 9,\"Southern Alaska\"\r\n" +
    "ak,10768246,1,\"Saturday, July 27, 2013 22:37:18 UTC\",61.6431,-149.9491,1.4,57.50, 9,\"Southern Alaska\"\r\n" +
    "ak,10768240,1,\"Saturday, July 27, 2013 22:33:39 UTC\",64.9066,-149.5960,2.1,11.30,12,\"Central Alaska\"\r\n" +
    "ak,10768235,1,\"Saturday, July 27, 2013 22:23:48 UTC\",64.2513,-145.3586,2.0,0.10,11,\"Central Alaska\"\r\n" +
    "ci,11340346,2,\"Saturday, July 27, 2013 22:23:02 UTC\",33.6812,-116.6813,1.0,19.20,26,\"Southern California\"\r\n" +
    "us,c000iqw5,2,\"Saturday, July 27, 2013 22:22:43 UTC\",36.6031,70.6687,4.4,214.70,17,\"Hindu Kush region, Afghanistan\"\r\n" +
    "us,c000iqve,9,\"Saturday, July 27, 2013 22:18:31 UTC\",-6.7882,131.8179,5.0,34.50,46,\"Kepulauan Tanimbar, Indonesia\"\r\n" +
    "ak,10768226,1,\"Saturday, July 27, 2013 21:46:17 UTC\",62.8785,-148.9065,2.5,11.60,19,\"Central Alaska\"\r\n" +
    "us,c000iqum,7,\"Saturday, July 27, 2013 21:39:09 UTC\",36.9240,56.0930,4.0,17.60, 0,\"northeastern Iran\"\r\n" +
    "uw,60559417,3,\"Saturday, July 27, 2013 21:34:36 UTC\",47.3227,-122.0165,1.7,12.70,21,\"Puget Sound region, Washington\"\r\n" +
    "uw,60559402,1,\"Saturday, July 27, 2013 21:11:47 UTC\",49.3593,-120.4893,2.3,0.00,11,\"British Columbia, Canada\"\r\n" +
    "ak,10768219,1,\"Saturday, July 27, 2013 21:04:01 UTC\",60.9314,-146.9619,1.3,23.00, 8,\"Southern Alaska\"\r\n" +
    "ci,11340338,2,\"Saturday, July 27, 2013 20:46:15 UTC\",32.9088,-116.2643,1.4,7.10,19,\"Southern California\"\r\n" +
    "us,c000iqst,8,\"Saturday, July 27, 2013 20:23:41 UTC\",36.5910,-97.2256,3.1,5.30,45,\"Oklahoma\"\r\n" +
    "hv,60533936,2,\"Saturday, July 27, 2013 19:26:47 UTC\",21.2273,-156.8978,2.5,0.00,12,\"Maui region, Hawaii\"\r\n" +
    "us,c000iqr5,8,\"Saturday, July 27, 2013 19:11:03 UTC\",50.3991,-130.1280,4.3,18.10,112,\"Vancouver Island, Canada region\"\r\n" +
    "us,c000iqqu,8,\"Saturday, July 27, 2013 18:48:30 UTC\",50.3367,-130.2613,3.9,13.80,126,\"Vancouver Island, Canada region\"\r\n" +
    "ak,10768200,1,\"Saturday, July 27, 2013 18:33:40 UTC\",60.5285,-147.6926,1.8,6.20,15,\"Southern Alaska\"\r\n" +
    "us,c000iqpr,5,\"Saturday, July 27, 2013 17:55:10 UTC\",7.3603,126.8959,4.9,74.90,50,\"Mindanao, Philippines\"\r\n" +
    "ak,10768190,1,\"Saturday, July 27, 2013 17:53:15 UTC\",61.6516,-149.8365,2.3,20.00,37,\"Southern Alaska\"\r\n" +
    "nc,72035070,1,\"Saturday, July 27, 2013 17:50:58 UTC\",38.8380,-122.8295,1.6,2.30,27,\"Northern California\"\r\n" +
    "us,c000iqpm,5,\"Saturday, July 27, 2013 17:47:47 UTC\",36.7068,141.0207,4.4,48.80,26,\"near the east coast of Honshu, Japan\"\r\n" +
    "us,c000iqp1,A,\"Saturday, July 27, 2013 17:36:19 UTC\",38.3827,72.6614,4.3,56.40,24,\"Tajikistan\"\r\n" +
    "nn,00418836,1,\"Saturday, July 27, 2013 17:25:32 UTC\",37.1957,-117.3893,1.4,12.30,26,\"Nevada\"\r\n" +
    "ci,11340282,2,\"Saturday, July 27, 2013 17:23:59 UTC\",33.3477,-116.4162,1.2,15.70,19,\"Southern California\"\r\n" +
    "nc,72035060,1,\"Saturday, July 27, 2013 17:17:59 UTC\",38.8088,-122.8122,1.3,2.40,25,\"Northern California\"\r\n" +
    "nn,00418834,1,\"Saturday, July 27, 2013 17:15:28 UTC\",39.1007,-118.9980,1.8,10.10,18,\"Nevada\"\r\n" +
    "ci,11340266,2,\"Saturday, July 27, 2013 17:11:22 UTC\",33.9268,-116.3518,1.1,7.30,15,\"Southern California\"\r\n" +
    "nn,00418827,1,\"Saturday, July 27, 2013 16:44:52 UTC\",39.0932,-118.9942,1.1,3.60, 6,\"Nevada\"\r\n" +
    "nn,00418826,1,\"Saturday, July 27, 2013 16:42:50 UTC\",38.5590,-116.7272,1.8,5.50,20,\"Nevada\"\r\n" +
    "ci,11340250,2,\"Saturday, July 27, 2013 16:32:25 UTC\",32.6842,-115.8960,1.5,5.60,19,\"Southern California\"\r\n" +
    "us,c000iqmr,4,\"Saturday, July 27, 2013 16:22:51 UTC\",76.9935,18.3054,4.2,10.00,33,\"Svalbard region\"\r\n" +
    "us,c000iqmh,9,\"Saturday, July 27, 2013 16:06:48 UTC\",13.5317,-91.2442,4.3,58.20,41,\"offshore Guatemala\"\r\n" +
    "us,c000iqmk,8,\"Saturday, July 27, 2013 16:03:10 UTC\",-15.4834,-173.0312,4.8,32.90,57,\"Tonga\"\r\n" +
    "uw,60559247,1,\"Saturday, July 27, 2013 15:37:57 UTC\",44.1035,-122.9135,1.1,10.00,13,\"Oregon\"\r\n" +
    "uw,60559232,3,\"Saturday, July 27, 2013 15:00:41 UTC\",47.3153,-122.0013,2.5,11.20,51,\"Puget Sound region, Washington\"\r\n" +
    "nn,00418818,1,\"Saturday, July 27, 2013 14:59:32 UTC\",39.6339,-119.8762,1.0,5.50,16,\"Nevada\"\r\n" +
    "pr,13208016,0,\"Saturday, July 27, 2013 14:52:42 UTC\",19.4022,-64.8425,2.9,24.00, 3,\"Virgin Islands region\"\r\n" +
    "ak,10768135,1,\"Saturday, July 27, 2013 14:43:54 UTC\",60.9662,-147.0260,1.0,87.10, 6,\"Southern Alaska\"\r\n" +
    "ak,10768128,1,\"Saturday, July 27, 2013 14:31:11 UTC\",63.2977,-148.1759,1.9,87.30,26,\"Central Alaska\"\r\n" +
    "ak,10768122,1,\"Saturday, July 27, 2013 14:01:54 UTC\",62.3582,-152.2444,1.4,0.10,10,\"Central Alaska\"\r\n" +
    "nc,72034955,0,\"Saturday, July 27, 2013 13:37:01 UTC\",40.2027,-121.0005,2.0,4.90, 7,\"Northern California\"\r\n" +
    "ci,11340218,2,\"Saturday, July 27, 2013 13:24:02 UTC\",34.0345,-117.5535,1.7,12.80,70,\"Greater Los Angeles area, California\"\r\n" +
    "nc,72034935,0,\"Saturday, July 27, 2013 13:12:35 UTC\",38.8252,-122.7928,1.1,3.10,22,\"Northern California\"\r\n" +
    "hv,60533861,2,\"Saturday, July 27, 2013 12:51:56 UTC\",19.4135,-155.2847,1.9,2.70,14,\"Island of Hawaii, Hawaii\"\r\n" +
    "hv,60533856,1,\"Saturday, July 27, 2013 12:20:41 UTC\",19.5467,-155.2600,2.1,4.90,19,\"Island of Hawaii, Hawaii\"\r\n" +
    "hv,60533851,2,\"Saturday, July 27, 2013 12:20:35 UTC\",19.4977,-155.2925,2.4,30.50,92,\"Island of Hawaii, Hawaii\"\r\n" +
    "pr,13208015,0,\"Saturday, July 27, 2013 12:19:16 UTC\",18.6375,-64.1740,3.1,50.00, 6,\"Virgin Islands region\"\r\n" +
    "ak,10768101,1,\"Saturday, July 27, 2013 12:03:23 UTC\",59.3245,-153.5602,1.8,116.50, 9,\"Southern Alaska\"\r\n" +
    "pr,13208013,0,\"Saturday, July 27, 2013 11:41:12 UTC\",19.2348,-64.7955,2.4,36.00, 5,\"Virgin Islands region\"\r\n" +
    "pr,13208011,0,\"Saturday, July 27, 2013 11:39:04 UTC\",18.2331,-64.2405,3.6,16.00,18,\"Virgin Islands region\"\r\n" +
    "nc,72034900,0,\"Saturday, July 27, 2013 10:55:06 UTC\",38.8327,-122.8788,1.3,2.70,21,\"Northern California\"\r\n" +
    "ak,10768086,1,\"Saturday, July 27, 2013 10:51:08 UTC\",66.0642,-149.1577,1.3,22.80, 7,\"northern Alaska\"\r\n" +
    "ak,10768079,1,\"Saturday, July 27, 2013 10:39:50 UTC\",60.1814,-152.3296,2.6,99.40,43,\"Southern Alaska\"\r\n" +
    "pr,13208012,0,\"Saturday, July 27, 2013 10:35:09 UTC\",18.6665,-65.0767,2.7,15.00, 7,\"Virgin Islands region\"\r\n" +
    "us,c000iqik,3,\"Saturday, July 27, 2013 10:34:43 UTC\",-5.4035,129.4476,4.4,220.10,12,\"Banda Sea\"\r\n" +
    "us,c000iqib,4,\"Saturday, July 27, 2013 10:34:01 UTC\",-34.7700,-71.9300,4.5,35.00, 0,\"Libertador General Bernardo O'Higgins, Chile\"\r\n" +
    "nc,72034890,0,\"Saturday, July 27, 2013 10:32:26 UTC\",37.6027,-122.4608,1.1,8.50, 7,\"San Francisco Bay area, California\"\r\n" +
    "ak,10768074,1,\"Saturday, July 27, 2013 10:17:51 UTC\",61.1408,-147.2928,1.4,1.80,10,\"Southern Alaska\"\r\n" +
    "nc,72034850,1,\"Saturday, July 27, 2013 10:01:59 UTC\",38.8328,-122.8083,1.7,2.80,26,\"Northern California\"\r\n" +
    "nm,072713a,A,\"Saturday, July 27, 2013 09:58:19 UTC\",35.9720,-91.2925,2.2,16.60,11,\"Arkansas\"\r\n" +
    "nc,72034845,0,\"Saturday, July 27, 2013 09:48:11 UTC\",40.3865,-124.3152,1.8,22.20, 5,\"Northern California\"\r\n" +
    "us,c000iqht,5,\"Saturday, July 27, 2013 09:42:53 UTC\",52.2515,159.7412,4.6,35.10,52,\"off the east coast of the Kamchatka Peninsula, Russia\"\r\n" +
    "ci,11340194,2,\"Saturday, July 27, 2013 09:36:36 UTC\",34.0138,-116.7963,1.1,17.20,10,\"Southern California\"\r\n" +
    "ak,10768058,2,\"Saturday, July 27, 2013 09:30:34 UTC\",63.9587,-149.5248,1.0,131.50,17,\"Central Alaska\"\r\n" +
    "ak,10768055,1,\"Saturday, July 27, 2013 09:27:44 UTC\",61.7670,-149.8397,1.3,36.50,11,\"Southern Alaska\"\r\n" +
    "nn,00418793,1,\"Saturday, July 27, 2013 09:08:55 UTC\",38.0243,-118.0635,1.4,7.00,23,\"Nevada\"\r\n" +
    "us,c000iqhn,7,\"Saturday, July 27, 2013 09:04:50 UTC\",40.0669,142.8767,4.6,44.30,26,\"near the east coast of Honshu, Japan\"\r\n" +
    "pr,13208014,0,\"Saturday, July 27, 2013 08:49:40 UTC\",18.1487,-65.7628,2.0,19.00, 4,\"Puerto Rico region\"\r\n" +
    "ak,10768043,1,\"Saturday, July 27, 2013 08:29:26 UTC\",62.7300,-149.9240,1.7,5.10,17,\"Central Alaska\"\r\n" +
    "pr,13208006,0,\"Saturday, July 27, 2013 08:13:58 UTC\",18.1653,-64.2809,2.9,8.00,13,\"Virgin Islands region\"\r\n" +
    "ci,11340178,2,\"Saturday, July 27, 2013 08:10:54 UTC\",33.8857,-116.8452,1.0,17.10,14,\"Southern California\"\r\n" +
    "pr,13208009,0,\"Saturday, July 27, 2013 07:52:33 UTC\",18.1639,-65.7585,1.1,22.00, 6,\"Puerto Rico\"\r\n" +
    "ci,11340162,2,\"Saturday, July 27, 2013 07:51:10 UTC\",32.9880,-116.4447,1.1,12.70,20,\"Southern California\"\r\n" +
    "ci,11340154,2,\"Saturday, July 27, 2013 07:50:31 UTC\",33.5055,-116.4537,1.1,11.70,31,\"Southern California\"\r\n" +
    "us,c000iqh1,6,\"Saturday, July 27, 2013 07:37:23 UTC\",-3.0594,129.9002,4.5,9.30,23,\"Seram, Indonesia\"\r\n" +
    "ak,10768030,1,\"Saturday, July 27, 2013 07:24:16 UTC\",62.8868,-150.8683,1.5,87.20,21,\"Central Alaska\"\r\n" +
    "us,c000iqgt,4,\"Saturday, July 27, 2013 06:46:46 UTC\",-2.9763,128.1495,4.6,67.10,26,\"Ceram Sea, Indonesia\"\r\n" +
    "pr,13208005,0,\"Saturday, July 27, 2013 06:39:16 UTC\",19.2369,-64.5658,3.3,55.00, 8,\"Virgin Islands region\"\r\n" +
    "ak,10768019,1,\"Saturday, July 27, 2013 06:37:03 UTC\",60.1129,-141.4777,1.7,0.80,14,\"Southern Alaska\"\r\n" +
    "pr,13208008,0,\"Saturday, July 27, 2013 06:31:55 UTC\",19.2919,-64.6380,2.8,13.00, 5,\"Virgin Islands region\"\r\n" +
    "pr,13208004,0,\"Saturday, July 27, 2013 06:27:03 UTC\",19.1245,-64.4627,3.0,73.00, 6,\"Virgin Islands region\"\r\n" +
    "nc,72034770,0,\"Saturday, July 27, 2013 06:11:00 UTC\",38.8792,-122.7928,1.3,3.00,16,\"Northern California\"\r\n" +
    "pr,13208002,0,\"Saturday, July 27, 2013 06:10:46 UTC\",19.3960,-64.5316,3.6,51.00,18,\"Virgin Islands region\"\r\n" +
    "pr,13208007,0,\"Saturday, July 27, 2013 06:03:40 UTC\",19.3414,-64.6654,2.4,11.00, 5,\"Virgin Islands region\"\r\n" +
    "ci,11340138,2,\"Saturday, July 27, 2013 05:34:09 UTC\",33.2478,-116.2622,1.6,11.20,47,\"Southern California\"\r\n" +
    "pr,13208003,0,\"Saturday, July 27, 2013 05:30:31 UTC\",18.1601,-68.0535,3.1,105.00,14,\"Mona Passage, Dominican Republic\"\r\n" +
    "pr,13208010,0,\"Saturday, July 27, 2013 05:27:40 UTC\",18.3829,-64.3441,2.6,82.00, 4,\"Virgin Islands region\"\r\n" +
    "ak,10768009,1,\"Saturday, July 27, 2013 05:16:21 UTC\",62.9152,-148.7842,1.7,1.70,11,\"Central Alaska\"\r\n" +
    "ak,10768003,1,\"Saturday, July 27, 2013 04:56:54 UTC\",61.0583,-152.1902,2.1,115.20,25,\"Southern Alaska\"\r\n" +
    "pr,13208001,0,\"Saturday, July 27, 2013 04:43:53 UTC\",19.2705,-64.4985,3.1,62.00, 6,\"Virgin Islands region\"\r\n" +
    "us,c000iqf9,5,\"Saturday, July 27, 2013 04:38:34 UTC\",40.1652,21.9452,4.1,10.30,22,\"Greece\"\r\n" +
    "ak,10767994,1,\"Saturday, July 27, 2013 04:26:12 UTC\",60.1707,-140.9277,1.4,13.70,13,\"Southern Yukon Territory, Canada\"\r\n" +
    "pr,13208000,0,\"Saturday, July 27, 2013 04:25:28 UTC\",18.1910,-64.2725,3.5,32.00,22,\"Virgin Islands region\"\r\n" +
    "us,c000iqf8,6,\"Saturday, July 27, 2013 04:24:39 UTC\",13.1336,145.4580,5.4,46.60,59,\"Guam region\"\r\n" +
    "ci,11340122,2,\"Saturday, July 27, 2013 03:57:29 UTC\",33.9525,-116.7313,1.2,18.60,26,\"Southern California\"\r\n" +
    "ak,10767985,1,\"Saturday, July 27, 2013 03:14:36 UTC\",57.8474,-153.6641,1.3,41.60, 4,\"Kodiak Island region, Alaska\"\r\n" +
    "nn,00418786,1,\"Saturday, July 27, 2013 03:05:40 UTC\",36.6136,-115.4711,1.4,5.00,11,\"Nevada\"\r\n" +
    "ci,11340106,2,\"Saturday, July 27, 2013 02:57:42 UTC\",33.9672,-117.1198,1.4,14.10,43,\"Greater Los Angeles area, California\"\r\n" +
    "ak,10767973,1,\"Saturday, July 27, 2013 02:51:21 UTC\",61.8244,-150.9653,2.3,80.20,29,\"Southern Alaska\"\r\n" +
    "ak,10767968,1,\"Saturday, July 27, 2013 02:42:39 UTC\",59.0410,-152.7081,2.3,74.50,31,\"Southern Alaska\"\r\n" +
    "ak,10767966,1,\"Saturday, July 27, 2013 02:26:03 UTC\",61.5612,-141.1682,1.2,4.10, 7,\"Southern Alaska\"\r\n" +
    "nc,72034505,0,\"Saturday, July 27, 2013 02:19:14 UTC\",38.8577,-122.8098,1.0,0.80, 9,\"Northern California\"\r\n" +
    "ak,10767950,1,\"Saturday, July 27, 2013 02:04:08 UTC\",61.5685,-141.2394,2.1,0.00,27,\"Southern Alaska\"\r\n" +
    "ci,11340098,2,\"Saturday, July 27, 2013 01:47:40 UTC\",33.9657,-117.1317,1.2,16.50,28,\"Greater Los Angeles area, California\"\r\n" +
    "ci,11340090,2,\"Saturday, July 27, 2013 01:46:27 UTC\",33.9555,-117.1225,1.0,14.00,23,\"Greater Los Angeles area, California\"\r\n" +
    "ci,11340082,2,\"Saturday, July 27, 2013 01:42:55 UTC\",33.9613,-117.1325,2.2,16.80,90,\"Greater Los Angeles area, California\"\r\n" +
    "ak,10767937,1,\"Saturday, July 27, 2013 01:28:56 UTC\",61.8219,-151.1165,1.7,62.50,11,\"Southern Alaska\"\r\n" +
    "us,c000iqdc,4,\"Saturday, July 27, 2013 01:27:11 UTC\",27.6000,139.8856,4.2,469.80,27,\"Bonin Islands, Japan region\"\r\n" +
    "us,c000iqd0,4,\"Saturday, July 27, 2013 01:14:46 UTC\",32.8765,141.7421,4.6,28.70,25,\"Izu Islands, Japan region\"\r\n" +
    "us,c000iqcp,8,\"Saturday, July 27, 2013 01:09:02 UTC\",32.9802,141.6500,5.6,30.80,69,\"Izu Islands, Japan region\"\r\n" +
    "us,c000iqcq,6,\"Saturday, July 27, 2013 01:01:29 UTC\",-9.9558,107.5961,4.5,10.00,14,\"south of Java, Indonesia\"\r\n" +
    "ak,10767918,1,\"Saturday, July 27, 2013 00:52:52 UTC\",56.5427,-157.5837,3.3,84.50,42,\"Alaska Peninsula\"\r\n" +
    "ci,11340074,2,\"Saturday, July 27, 2013 00:26:12 UTC\",36.0208,-117.7760,1.5,2.00,15,\"Central California\"\r\n" +
    "ci,11340066,2,\"Saturday, July 27, 2013 00:17:33 UTC\",36.0192,-117.7840,1.4,2.70,13,\"Central California\"\r\n" +
    "ci,11340058,2,\"Saturday, July 27, 2013 00:11:00 UTC\",33.9655,-116.8092,1.1,16.70,19,\"Southern California\"\r\n" +
    "nc,72034385,0,\"Friday, July 26, 2013 23:49:59 UTC\",38.8375,-122.8077,1.3,2.30,18,\"Northern California\"\r\n" +
    "ak,10767775,1,\"Friday, July 26, 2013 23:25:08 UTC\",61.5668,-141.1227,1.3,1.20, 9,\"Southern Alaska\"\r\n" +
    "nn,00418776,1,\"Friday, July 26, 2013 23:17:37 UTC\",39.0916,-119.0071,1.0,9.20, 6,\"Nevada\"\r\n" +
    "ak,10767766,2,\"Friday, July 26, 2013 22:59:33 UTC\",64.9919,-147.3194,1.1,4.40, 9,\"Central Alaska\"\r\n" +
    "nn,00418782,1,\"Friday, July 26, 2013 22:52:22 UTC\",38.4096,-118.7340,1.1,10.50, 5,\"Nevada\"\r\n" +
    "ak,10767752,1,\"Friday, July 26, 2013 22:08:43 UTC\",60.9270,-147.5376,1.2,19.60, 7,\"Southern Alaska\"\r\n" +
    "hv,60533561,1,\"Friday, July 26, 2013 22:03:28 UTC\",19.4010,-155.2793,1.8,1.30,29,\"Island of Hawaii, Hawaii\"\r\n" +
    "ci,11340042,4,\"Friday, July 26, 2013 21:55:58 UTC\",33.8623,-117.6978,1.4,9.00,37,\"Greater Los Angeles area, California\"\r\n" +
    "uw,60558967,2,\"Friday, July 26, 2013 21:49:21 UTC\",48.0955,-121.9492,1.8,0.00,37,\"Puget Sound region, Washington\"\r\n" +
    "ak,10767723,1,\"Friday, July 26, 2013 21:39:16 UTC\",62.9666,-149.3856,1.2,66.80, 6,\"Central Alaska\"\r\n" +
    "us,c000iq6f,8,\"Friday, July 26, 2013 21:32:59 UTC\",-57.7893,-23.9594,6.2,10.00,65,\"South Sandwich Islands region\"\r\n" +
    "nc,72034290,0,\"Friday, July 26, 2013 21:24:29 UTC\",37.6388,-118.8787,1.2,8.10,14,\"Long Valley area, California\"\r\n" +
    "nc,72034285,0,\"Friday, July 26, 2013 21:20:04 UTC\",36.8853,-121.6107,2.4,1.30,14,\"Central California\"\r\n" +
    "nc,72034280,1,\"Friday, July 26, 2013 21:19:17 UTC\",38.8338,-122.7780,1.3,2.60,26,\"Northern California\"\r\n" +
    "uw,60558947,1,\"Friday, July 26, 2013 21:12:07 UTC\",49.4418,-120.5050,2.4,0.00, 8,\"British Columbia, Canada\"\r\n" +
    "ci,11340018,4,\"Friday, July 26, 2013 20:51:15 UTC\",33.0353,-116.4215,1.1,7.40,23,\"Southern California\"\r\n" +
    "ak,10767684,2,\"Friday, July 26, 2013 20:37:19 UTC\",58.0237,-151.7451,4.3,39.80,84,\"Kodiak Island region, Alaska\"\r\n" +
    "nc,72034250,0,\"Friday, July 26, 2013 20:17:05 UTC\",39.1323,-123.1315,1.8,8.30,11,\"Northern California\"\r\n" +
    "pr,13207007,0,\"Friday, July 26, 2013 20:16:36 UTC\",18.8353,-64.9128,2.5,62.00, 5,\"Virgin Islands region\"\r\n" +
    "us,c000iq40,4,\"Friday, July 26, 2013 19:59:31 UTC\",9.4749,122.3884,4.4,53.20,15,\"Negros, Philippines\"\r\n" +
    "ak,10767672,1,\"Friday, July 26, 2013 19:58:48 UTC\",64.2372,-147.3225,1.0,30.10, 5,\"Central Alaska\"\r\n" +
    "us,c000ipxp,A,\"Friday, July 26, 2013 19:08:29 UTC\",-23.0963,179.1808,5.1,547.20,138,\"south of the Fiji Islands\"\r\n" +
    "nc,72034215,4,\"Friday, July 26, 2013 19:04:24 UTC\",37.7472,-122.1590,1.2,12.80,26,\"San Francisco Bay area, California\"\r\n" +
    "hv,60533466,1,\"Friday, July 26, 2013 18:37:30 UTC\",19.4007,-155.2865,2.1,1.50,26,\"Island of Hawaii, Hawaii\"\r\n" +
    "ak,10767634,1,\"Friday, July 26, 2013 18:17:28 UTC\",61.6225,-146.3933,3.1,11.00,62,\"Southern Alaska\"\r\n" +
    "ak,10767629,1,\"Friday, July 26, 2013 18:05:48 UTC\",61.5305,-141.2727,1.1,14.00, 6,\"Southern Alaska\"\r\n" +
    "nc,72034185,0,\"Friday, July 26, 2013 17:52:02 UTC\",36.8002,-121.4258,1.3,11.10,22,\"Central California\"\r\n" +
    "nc,72034170,3,\"Friday, July 26, 2013 17:24:07 UTC\",37.4703,-118.8138,2.2,8.80,43,\"Central California\"\r\n" +
    "uu,60032012,2,\"Friday, July 26, 2013 17:20:05 UTC\",38.9255,-112.9440,1.6,11.20, 9,\"Utah\"\r\n" +
    "uw,60558817,1,\"Friday, July 26, 2013 17:05:52 UTC\",47.8703,-121.6590,1.8,13.30,13,\"Washington\"\r\n" +
    "nc,72034160,2,\"Friday, July 26, 2013 17:04:43 UTC\",37.6360,-118.8808,1.4,8.70,32,\"Long Valley area, California\"\r\n" +
    "ak,10767599,1,\"Friday, July 26, 2013 16:54:44 UTC\",64.0593,-145.9625,1.3,46.90, 9,\"Central Alaska\"\r\n" +
    "nc,72034140,0,\"Friday, July 26, 2013 16:43:43 UTC\",38.8388,-122.8283,1.1,2.70,15,\"Northern California\"\r\n" +
    "ci,11339954,4,\"Friday, July 26, 2013 16:41:31 UTC\",33.7423,-118.2832,1.5,9.70,10,\"Greater Los Angeles area, California\"\r\n" +
    "nc,72034135,3,\"Friday, July 26, 2013 16:38:55 UTC\",36.3028,-120.8472,1.2,6.90,22,\"Central California\"\r\n" +
    "us,c000ipsc,5,\"Friday, July 26, 2013 16:25:08 UTC\",32.9279,104.8623,4.6,31.40,38,\"Sichuan-Gansu border region, China\"\r\n" +
    "nc,72034130,0,\"Friday, July 26, 2013 16:24:28 UTC\",37.3725,-121.7270,1.1,8.60, 9,\"San Francisco Bay area, California\"\r\n" +
    "nc,72034120,1,\"Friday, July 26, 2013 16:15:22 UTC\",37.3673,-121.7270,1.5,8.10,26,\"San Francisco Bay area, California\"\r\n" +
    "us,c000ips2,7,\"Friday, July 26, 2013 16:14:02 UTC\",36.2810,69.9576,4.4,148.00,32,\"Hindu Kush region, Afghanistan\"\r\n" +
    "uw,60558792,1,\"Friday, July 26, 2013 16:04:09 UTC\",44.2712,-122.7088,1.5,0.00,11,\"Oregon\"\r\n" +
    "us,c000iprk,9,\"Friday, July 26, 2013 15:56:51 UTC\",51.7462,-176.7481,4.5,60.90,33,\"Andreanof Islands, Aleutian Islands, Alaska\"\r\n" +
    "hv,60533351,2,\"Friday, July 26, 2013 15:50:07 UTC\",19.4060,-155.2765,2.1,1.90,36,\"Island of Hawaii, Hawaii\"\r\n" +
    "pr,13207006,0,\"Friday, July 26, 2013 15:37:58 UTC\",18.1781,-68.4160,2.6,90.00, 7,\"Mona Passage, Dominican Republic\"\r\n" +
    "ak,10767549,1,\"Friday, July 26, 2013 15:36:43 UTC\",60.4727,-147.2632,1.9,35.10, 9,\"Southern Alaska\"\r\n" +
    "hv,60533331,1,\"Friday, July 26, 2013 15:28:50 UTC\",19.3917,-155.2630,1.9,1.00,19,\"Island of Hawaii, Hawaii\"\r\n" +
    "hv,60533321,1,\"Friday, July 26, 2013 15:27:11 UTC\",19.4018,-155.2773,2.1,0.50,26,\"Island of Hawaii, Hawaii\"\r\n" +
    "us,c000ipp1,5,\"Friday, July 26, 2013 14:36:20 UTC\",-0.4327,99.1852,4.9,59.00,41,\"southern Sumatra, Indonesia\"\r\n" +
    "ak,10767532,1,\"Friday, July 26, 2013 14:29:33 UTC\",60.2003,-151.4280,1.5,27.40, 6,\"Kenai Peninsula, Alaska\"\r\n" +
    "ak,10767524,1,\"Friday, July 26, 2013 14:13:00 UTC\",60.4608,-142.9366,1.1,5.10, 6,\"Southern Alaska\"\r\n" +
    "nn,00418725,1,\"Friday, July 26, 2013 14:07:38 UTC\",38.4108,-118.7408,1.1,3.20,14,\"Nevada\"\r\n" +
    "uw,60558752,3,\"Friday, July 26, 2013 14:04:26 UTC\",47.8042,-120.7062,1.0,15.40, 9,\"Washington\"\r\n" +
    "ak,10767519,1,\"Friday, July 26, 2013 14:01:07 UTC\",62.2006,-151.1820,1.2,84.70, 5,\"Central Alaska\"\r\n" +
    "ci,11339938,4,\"Friday, July 26, 2013 14:00:47 UTC\",32.9723,-115.8805,3.1,8.50,53,\"Southern California\"\r\n"
  end
  
  def expected_data_all
    [{"source"=>"ci", "eqid"=>"11340418", "version"=>"2", "occurred_at"=>"2013-07-28T05:00:10.000Z", "magnitude"=>1.0, "depth"=>7.7, "number_of_stations_reported"=>18, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-117.1838 34.0115)"},
     {"source"=>"ak", "eqid"=>"10768318", "version"=>"1", "occurred_at"=>"2013-07-28T04:43:32.000Z", "magnitude"=>1.8, "depth"=>0.6, "number_of_stations_reported"=>13, "region"=>"Southern Alaska", "location"=>"POINT (-141.4384 60.1361)"},
     {"source"=>"nc", "eqid"=>"72035290", "version"=>"0", "occurred_at"=>"2013-07-28T04:39:44.000Z", "magnitude"=>1.0, "depth"=>3.7, "number_of_stations_reported"=>18, "region"=>"Northern California", "location"=>"POINT (-122.8083 38.7922)"},
     {"source"=>"nc", "eqid"=>"72035285", "version"=>"0", "occurred_at"=>"2013-07-28T04:09:26.000Z", "magnitude"=>1.0, "depth"=>8.9, "number_of_stations_reported"=>6, "region"=>"Central California", "location"=>"POINT (-121.2683 36.6508)"},
     {"source"=>"nc", "eqid"=>"72035275", "version"=>"0", "occurred_at"=>"2013-07-28T04:01:34.000Z", "magnitude"=>1.1, "depth"=>0.2, "number_of_stations_reported"=>5, "region"=>"Long Valley area, California", "location"=>"POINT (-119.0092 37.6718)"},
     {"source"=>"nn", "eqid"=>"00418875", "version"=>"1", "occurred_at"=>"2013-07-28T03:29:54.000Z", "magnitude"=>1.4, "depth"=>27.0, "number_of_stations_reported"=>14, "region"=>"Nevada", "location"=>"POINT (-119.0675 39.085)"},
     {"source"=>"ak", "eqid"=>"10768301", "version"=>"1", "occurred_at"=>"2013-07-28T03:24:22.000Z", "magnitude"=>2.5, "depth"=>8.0, "number_of_stations_reported"=>6, "region"=>"Kodiak Island region, Alaska", "location"=>"POINT (-154.5349 56.4276)"},
     {"source"=>"ak", "eqid"=>"10768294", "version"=>"1", "occurred_at"=>"2013-07-28T03:19:04.000Z", "magnitude"=>2.7, "depth"=>90.0, "number_of_stations_reported"=>39, "region"=>"Southern Alaska", "location"=>"POINT (-152.0219 60.57)"},
     {"source"=>"nc", "eqid"=>"72035235", "version"=>"0", "occurred_at"=>"2013-07-28T03:06:05.000Z", "magnitude"=>1.1, "depth"=>3.2, "number_of_stations_reported"=>20, "region"=>"Northern California", "location"=>"POINT (-122.7965 38.824)"},
     {"source"=>"nn", "eqid"=>"00418874", "version"=>"1", "occurred_at"=>"2013-07-28T02:34:47.000Z", "magnitude"=>1.3, "depth"=>8.1, "number_of_stations_reported"=>5, "region"=>"Northern California", "location"=>"POINT (-119.8163 38.658)"},
     {"source"=>"nn", "eqid"=>"00418872", "version"=>"1", "occurred_at"=>"2013-07-28T01:51:18.000Z", "magnitude"=>1.6, "depth"=>7.3, "number_of_stations_reported"=>22, "region"=>"Nevada", "location"=>"POINT (-118.4575 38.6237)"},
     {"source"=>"ak", "eqid"=>"10768286", "version"=>"1", "occurred_at"=>"2013-07-28T01:30:38.000Z", "magnitude"=>1.1, "depth"=>8.2, "number_of_stations_reported"=>10, "region"=>"Central Alaska", "location"=>"POINT (-148.7069 62.9256)"},
     {"source"=>"ci", "eqid"=>"11340394", "version"=>"2", "occurred_at"=>"2013-07-28T01:20:38.000Z", "magnitude"=>1.8, "depth"=>3.6, "number_of_stations_reported"=>33, "region"=>"Southern California", "location"=>"POINT (-117.649 35.7452)"},
     {"source"=>"us", "eqid"=>"c000iqz3", "version"=>"6", "occurred_at"=>"2013-07-28T01:04:49.000Z", "magnitude"=>2.8, "depth"=>4.8, "number_of_stations_reported"=>14, "region"=>"Oklahoma", "location"=>"POINT (-97.8951 35.0585)"},
     {"source"=>"ak", "eqid"=>"10768278", "version"=>"1", "occurred_at"=>"2013-07-28T01:01:48.000Z", "magnitude"=>1.3, "depth"=>4.6, "number_of_stations_reported"=>8, "region"=>"Central Alaska", "location"=>"POINT (-150.6671 63.5901)"},
     {"source"=>"ak", "eqid"=>"10768275", "version"=>"1", "occurred_at"=>"2013-07-28T00:54:07.000Z", "magnitude"=>2.1, "depth"=>87.2, "number_of_stations_reported"=>22, "region"=>"Southern Alaska", "location"=>"POINT (-152.4939 59.3718)"},
     {"source"=>"ak", "eqid"=>"10768272", "version"=>"1", "occurred_at"=>"2013-07-28T00:49:30.000Z", "magnitude"=>1.0, "depth"=>0.0, "number_of_stations_reported"=>6, "region"=>"Central Alaska", "location"=>"POINT (-147.5429 63.4316)"},
     {"source"=>"ci", "eqid"=>"11340378", "version"=>"2", "occurred_at"=>"2013-07-28T00:47:17.000Z", "magnitude"=>1.9, "depth"=>9.0, "number_of_stations_reported"=>13, "region"=>"Central California", "location"=>"POINT (-117.9188 36.5038)"},
     {"source"=>"nc", "eqid"=>"72035200", "version"=>"1", "occurred_at"=>"2013-07-28T00:18:30.000Z", "magnitude"=>2.6, "depth"=>4.6, "number_of_stations_reported"=>73, "region"=>"Central California", "location"=>"POINT (-120.7835 35.5513)"},
     {"source"=>"nn", "eqid"=>"00418867", "version"=>"1", "occurred_at"=>"2013-07-27T23:53:54.000Z", "magnitude"=>1.1, "depth"=>17.8, "number_of_stations_reported"=>7, "region"=>"Nevada", "location"=>"POINT (-118.8163 38.9352)"},
     {"source"=>"nn", "eqid"=>"00418865", "version"=>"1", "occurred_at"=>"2013-07-27T23:49:48.000Z", "magnitude"=>1.0, "depth"=>19.5, "number_of_stations_reported"=>5, "region"=>"Nevada", "location"=>"POINT (-118.8168 38.9357)"},
     {"source"=>"ci", "eqid"=>"11340362", "version"=>"2", "occurred_at"=>"2013-07-27T23:25:07.000Z", "magnitude"=>1.3, "depth"=>1.7, "number_of_stations_reported"=>20, "region"=>"Central California", "location"=>"POINT (-118.293 35.4855)"},
     {"source"=>"uw", "eqid"=>"60559447", "version"=>"2", "occurred_at"=>"2013-07-27T23:24:05.000Z", "magnitude"=>1.9, "depth"=>40.5, "number_of_stations_reported"=>22, "region"=>"Olympic Peninsula, Washington", "location"=>"POINT (-123.4008 48.0505)"},
     {"source"=>"ak", "eqid"=>"10768255", "version"=>"1", "occurred_at"=>"2013-07-27T22:59:09.000Z", "magnitude"=>1.6, "depth"=>21.0, "number_of_stations_reported"=>9, "region"=>"Southern Alaska", "location"=>"POINT (-147.1599 61.0248)"},
     {"source"=>"ak", "eqid"=>"10768246", "version"=>"1", "occurred_at"=>"2013-07-27T22:37:18.000Z", "magnitude"=>1.4, "depth"=>57.5, "number_of_stations_reported"=>9, "region"=>"Southern Alaska", "location"=>"POINT (-149.9491 61.6431)"},
     {"source"=>"ak", "eqid"=>"10768240", "version"=>"1", "occurred_at"=>"2013-07-27T22:33:39.000Z", "magnitude"=>2.1, "depth"=>11.3, "number_of_stations_reported"=>12, "region"=>"Central Alaska", "location"=>"POINT (-149.596 64.9066)"},
     {"source"=>"ak", "eqid"=>"10768235", "version"=>"1", "occurred_at"=>"2013-07-27T22:23:48.000Z", "magnitude"=>2.0, "depth"=>0.1, "number_of_stations_reported"=>11, "region"=>"Central Alaska", "location"=>"POINT (-145.3586 64.2513)"},
     {"source"=>"ci", "eqid"=>"11340346", "version"=>"2", "occurred_at"=>"2013-07-27T22:23:02.000Z", "magnitude"=>1.0, "depth"=>19.2, "number_of_stations_reported"=>26, "region"=>"Southern California", "location"=>"POINT (-116.6813 33.6812)"},
     {"source"=>"us", "eqid"=>"c000iqw5", "version"=>"2", "occurred_at"=>"2013-07-27T22:22:43.000Z", "magnitude"=>4.4, "depth"=>214.7, "number_of_stations_reported"=>17, "region"=>"Hindu Kush region, Afghanistan", "location"=>"POINT (70.6687 36.6031)"},
     {"source"=>"us", "eqid"=>"c000iqve", "version"=>"9", "occurred_at"=>"2013-07-27T22:18:31.000Z", "magnitude"=>5.0, "depth"=>34.5, "number_of_stations_reported"=>46, "region"=>"Kepulauan Tanimbar, Indonesia", "location"=>"POINT (131.8179 -6.7882)"},
     {"source"=>"ak", "eqid"=>"10768226", "version"=>"1", "occurred_at"=>"2013-07-27T21:46:17.000Z", "magnitude"=>2.5, "depth"=>11.6, "number_of_stations_reported"=>19, "region"=>"Central Alaska", "location"=>"POINT (-148.9065 62.8785)"},
     {"source"=>"us", "eqid"=>"c000iqum", "version"=>"7", "occurred_at"=>"2013-07-27T21:39:09.000Z", "magnitude"=>4.0, "depth"=>17.6, "number_of_stations_reported"=>0, "region"=>"northeastern Iran", "location"=>"POINT (56.093 36.924)"},
     {"source"=>"uw", "eqid"=>"60559417", "version"=>"3", "occurred_at"=>"2013-07-27T21:34:36.000Z", "magnitude"=>1.7, "depth"=>12.7, "number_of_stations_reported"=>21, "region"=>"Puget Sound region, Washington", "location"=>"POINT (-122.0165 47.3227)"},
     {"source"=>"uw", "eqid"=>"60559402", "version"=>"1", "occurred_at"=>"2013-07-27T21:11:47.000Z", "magnitude"=>2.3, "depth"=>0.0, "number_of_stations_reported"=>11, "region"=>"British Columbia, Canada", "location"=>"POINT (-120.4893 49.3593)"},
     {"source"=>"ak", "eqid"=>"10768219", "version"=>"1", "occurred_at"=>"2013-07-27T21:04:01.000Z", "magnitude"=>1.3, "depth"=>23.0, "number_of_stations_reported"=>8, "region"=>"Southern Alaska", "location"=>"POINT (-146.9619 60.9314)"},
     {"source"=>"ci", "eqid"=>"11340338", "version"=>"2", "occurred_at"=>"2013-07-27T20:46:15.000Z", "magnitude"=>1.4, "depth"=>7.1, "number_of_stations_reported"=>19, "region"=>"Southern California", "location"=>"POINT (-116.2643 32.9088)"},
     {"source"=>"us", "eqid"=>"c000iqst", "version"=>"8", "occurred_at"=>"2013-07-27T20:23:41.000Z", "magnitude"=>3.1, "depth"=>5.3, "number_of_stations_reported"=>45, "region"=>"Oklahoma", "location"=>"POINT (-97.2256 36.591)"},
     {"source"=>"hv", "eqid"=>"60533936", "version"=>"2", "occurred_at"=>"2013-07-27T19:26:47.000Z", "magnitude"=>2.5, "depth"=>0.0, "number_of_stations_reported"=>12, "region"=>"Maui region, Hawaii", "location"=>"POINT (-156.8978 21.2273)"},
     {"source"=>"us", "eqid"=>"c000iqr5", "version"=>"8", "occurred_at"=>"2013-07-27T19:11:03.000Z", "magnitude"=>4.3, "depth"=>18.1, "number_of_stations_reported"=>112, "region"=>"Vancouver Island, Canada region", "location"=>"POINT (-130.128 50.3991)"},
     {"source"=>"us", "eqid"=>"c000iqqu", "version"=>"8", "occurred_at"=>"2013-07-27T18:48:30.000Z", "magnitude"=>3.9, "depth"=>13.8, "number_of_stations_reported"=>126, "region"=>"Vancouver Island, Canada region", "location"=>"POINT (-130.2613 50.3367)"},
     {"source"=>"ak", "eqid"=>"10768200", "version"=>"1", "occurred_at"=>"2013-07-27T18:33:40.000Z", "magnitude"=>1.8, "depth"=>6.2, "number_of_stations_reported"=>15, "region"=>"Southern Alaska", "location"=>"POINT (-147.6926 60.5285)"},
     {"source"=>"us", "eqid"=>"c000iqpr", "version"=>"5", "occurred_at"=>"2013-07-27T17:55:10.000Z", "magnitude"=>4.9, "depth"=>74.9, "number_of_stations_reported"=>50, "region"=>"Mindanao, Philippines", "location"=>"POINT (126.8959 7.3603)"},
     {"source"=>"ak", "eqid"=>"10768190", "version"=>"1", "occurred_at"=>"2013-07-27T17:53:15.000Z", "magnitude"=>2.3, "depth"=>20.0, "number_of_stations_reported"=>37, "region"=>"Southern Alaska", "location"=>"POINT (-149.8365 61.6516)"},
     {"source"=>"nc", "eqid"=>"72035070", "version"=>"1", "occurred_at"=>"2013-07-27T17:50:58.000Z", "magnitude"=>1.6, "depth"=>2.3, "number_of_stations_reported"=>27, "region"=>"Northern California", "location"=>"POINT (-122.8295 38.838)"},
     {"source"=>"us", "eqid"=>"c000iqpm", "version"=>"5", "occurred_at"=>"2013-07-27T17:47:47.000Z", "magnitude"=>4.4, "depth"=>48.8, "number_of_stations_reported"=>26, "region"=>"near the east coast of Honshu, Japan", "location"=>"POINT (141.0207 36.7068)"},
     {"source"=>"us", "eqid"=>"c000iqp1", "version"=>"A", "occurred_at"=>"2013-07-27T17:36:19.000Z", "magnitude"=>4.3, "depth"=>56.4, "number_of_stations_reported"=>24, "region"=>"Tajikistan", "location"=>"POINT (72.6614 38.3827)"},
     {"source"=>"nn", "eqid"=>"00418836", "version"=>"1", "occurred_at"=>"2013-07-27T17:25:32.000Z", "magnitude"=>1.4, "depth"=>12.3, "number_of_stations_reported"=>26, "region"=>"Nevada", "location"=>"POINT (-117.3893 37.1957)"},
     {"source"=>"ci", "eqid"=>"11340282", "version"=>"2", "occurred_at"=>"2013-07-27T17:23:59.000Z", "magnitude"=>1.2, "depth"=>15.7, "number_of_stations_reported"=>19, "region"=>"Southern California", "location"=>"POINT (-116.4162 33.3477)"},
     {"source"=>"nc", "eqid"=>"72035060", "version"=>"1", "occurred_at"=>"2013-07-27T17:17:59.000Z", "magnitude"=>1.3, "depth"=>2.4, "number_of_stations_reported"=>25, "region"=>"Northern California", "location"=>"POINT (-122.8122 38.8088)"},
     {"source"=>"nn", "eqid"=>"00418834", "version"=>"1", "occurred_at"=>"2013-07-27T17:15:28.000Z", "magnitude"=>1.8, "depth"=>10.1, "number_of_stations_reported"=>18, "region"=>"Nevada", "location"=>"POINT (-118.998 39.1007)"},
     {"source"=>"ci", "eqid"=>"11340266", "version"=>"2", "occurred_at"=>"2013-07-27T17:11:22.000Z", "magnitude"=>1.1, "depth"=>7.3, "number_of_stations_reported"=>15, "region"=>"Southern California", "location"=>"POINT (-116.3518 33.9268)"},
     {"source"=>"nn", "eqid"=>"00418827", "version"=>"1", "occurred_at"=>"2013-07-27T16:44:52.000Z", "magnitude"=>1.1, "depth"=>3.6, "number_of_stations_reported"=>6, "region"=>"Nevada", "location"=>"POINT (-118.9942 39.0932)"},
     {"source"=>"nn", "eqid"=>"00418826", "version"=>"1", "occurred_at"=>"2013-07-27T16:42:50.000Z", "magnitude"=>1.8, "depth"=>5.5, "number_of_stations_reported"=>20, "region"=>"Nevada", "location"=>"POINT (-116.7272 38.559)"},
     {"source"=>"ci", "eqid"=>"11340250", "version"=>"2", "occurred_at"=>"2013-07-27T16:32:25.000Z", "magnitude"=>1.5, "depth"=>5.6, "number_of_stations_reported"=>19, "region"=>"Southern California", "location"=>"POINT (-115.896 32.6842)"},
     {"source"=>"us", "eqid"=>"c000iqmr", "version"=>"4", "occurred_at"=>"2013-07-27T16:22:51.000Z", "magnitude"=>4.2, "depth"=>10.0, "number_of_stations_reported"=>33, "region"=>"Svalbard region", "location"=>"POINT (18.3054 76.9935)"},
     {"source"=>"us", "eqid"=>"c000iqmh", "version"=>"9", "occurred_at"=>"2013-07-27T16:06:48.000Z", "magnitude"=>4.3, "depth"=>58.2, "number_of_stations_reported"=>41, "region"=>"offshore Guatemala", "location"=>"POINT (-91.2442 13.5317)"},
     {"source"=>"us", "eqid"=>"c000iqmk", "version"=>"8", "occurred_at"=>"2013-07-27T16:03:10.000Z", "magnitude"=>4.8, "depth"=>32.9, "number_of_stations_reported"=>57, "region"=>"Tonga", "location"=>"POINT (-173.0312 -15.4834)"},
     {"source"=>"uw", "eqid"=>"60559247", "version"=>"1", "occurred_at"=>"2013-07-27T15:37:57.000Z", "magnitude"=>1.1, "depth"=>10.0, "number_of_stations_reported"=>13, "region"=>"Oregon", "location"=>"POINT (-122.9135 44.1035)"},
     {"source"=>"uw", "eqid"=>"60559232", "version"=>"3", "occurred_at"=>"2013-07-27T15:00:41.000Z", "magnitude"=>2.5, "depth"=>11.2, "number_of_stations_reported"=>51, "region"=>"Puget Sound region, Washington", "location"=>"POINT (-122.0013 47.3153)"},
     {"source"=>"nn", "eqid"=>"00418818", "version"=>"1", "occurred_at"=>"2013-07-27T14:59:32.000Z", "magnitude"=>1.0, "depth"=>5.5, "number_of_stations_reported"=>16, "region"=>"Nevada", "location"=>"POINT (-119.8762 39.6339)"},
     {"source"=>"pr", "eqid"=>"13208016", "version"=>"0", "occurred_at"=>"2013-07-27T14:52:42.000Z", "magnitude"=>2.9, "depth"=>24.0, "number_of_stations_reported"=>3, "region"=>"Virgin Islands region", "location"=>"POINT (-64.8425 19.4022)"},
     {"source"=>"ak", "eqid"=>"10768135", "version"=>"1", "occurred_at"=>"2013-07-27T14:43:54.000Z", "magnitude"=>1.0, "depth"=>87.1, "number_of_stations_reported"=>6, "region"=>"Southern Alaska", "location"=>"POINT (-147.026 60.9662)"},
     {"source"=>"ak", "eqid"=>"10768128", "version"=>"1", "occurred_at"=>"2013-07-27T14:31:11.000Z", "magnitude"=>1.9, "depth"=>87.3, "number_of_stations_reported"=>26, "region"=>"Central Alaska", "location"=>"POINT (-148.1759 63.2977)"},
     {"source"=>"ak", "eqid"=>"10768122", "version"=>"1", "occurred_at"=>"2013-07-27T14:01:54.000Z", "magnitude"=>1.4, "depth"=>0.1, "number_of_stations_reported"=>10, "region"=>"Central Alaska", "location"=>"POINT (-152.2444 62.3582)"},
     {"source"=>"nc", "eqid"=>"72034955", "version"=>"0", "occurred_at"=>"2013-07-27T13:37:01.000Z", "magnitude"=>2.0, "depth"=>4.9, "number_of_stations_reported"=>7, "region"=>"Northern California", "location"=>"POINT (-121.0005 40.2027)"},
     {"source"=>"ci", "eqid"=>"11340218", "version"=>"2", "occurred_at"=>"2013-07-27T13:24:02.000Z", "magnitude"=>1.7, "depth"=>12.8, "number_of_stations_reported"=>70, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-117.5535 34.0345)"},
     {"source"=>"nc", "eqid"=>"72034935", "version"=>"0", "occurred_at"=>"2013-07-27T13:12:35.000Z", "magnitude"=>1.1, "depth"=>3.1, "number_of_stations_reported"=>22, "region"=>"Northern California", "location"=>"POINT (-122.7928 38.8252)"},
     {"source"=>"hv", "eqid"=>"60533861", "version"=>"2", "occurred_at"=>"2013-07-27T12:51:56.000Z", "magnitude"=>1.9, "depth"=>2.7, "number_of_stations_reported"=>14, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.2847 19.4135)"},
     {"source"=>"hv", "eqid"=>"60533856", "version"=>"1", "occurred_at"=>"2013-07-27T12:20:41.000Z", "magnitude"=>2.1, "depth"=>4.9, "number_of_stations_reported"=>19, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.26 19.5467)"},
     {"source"=>"hv", "eqid"=>"60533851", "version"=>"2", "occurred_at"=>"2013-07-27T12:20:35.000Z", "magnitude"=>2.4, "depth"=>30.5, "number_of_stations_reported"=>92, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.2925 19.4977)"},
     {"source"=>"pr", "eqid"=>"13208015", "version"=>"0", "occurred_at"=>"2013-07-27T12:19:16.000Z", "magnitude"=>3.1, "depth"=>50.0, "number_of_stations_reported"=>6, "region"=>"Virgin Islands region", "location"=>"POINT (-64.174 18.6375)"},
     {"source"=>"ak", "eqid"=>"10768101", "version"=>"1", "occurred_at"=>"2013-07-27T12:03:23.000Z", "magnitude"=>1.8, "depth"=>116.5, "number_of_stations_reported"=>9, "region"=>"Southern Alaska", "location"=>"POINT (-153.5602 59.3245)"},
     {"source"=>"pr", "eqid"=>"13208013", "version"=>"0", "occurred_at"=>"2013-07-27T11:41:12.000Z", "magnitude"=>2.4, "depth"=>36.0, "number_of_stations_reported"=>5, "region"=>"Virgin Islands region", "location"=>"POINT (-64.7955 19.2348)"},
     {"source"=>"pr", "eqid"=>"13208011", "version"=>"0", "occurred_at"=>"2013-07-27T11:39:04.000Z", "magnitude"=>3.6, "depth"=>16.0, "number_of_stations_reported"=>18, "region"=>"Virgin Islands region", "location"=>"POINT (-64.2405 18.2331)"},
     {"source"=>"nc", "eqid"=>"72034900", "version"=>"0", "occurred_at"=>"2013-07-27T10:55:06.000Z", "magnitude"=>1.3, "depth"=>2.7, "number_of_stations_reported"=>21, "region"=>"Northern California", "location"=>"POINT (-122.8788 38.8327)"},
     {"source"=>"ak", "eqid"=>"10768086", "version"=>"1", "occurred_at"=>"2013-07-27T10:51:08.000Z", "magnitude"=>1.3, "depth"=>22.8, "number_of_stations_reported"=>7, "region"=>"northern Alaska", "location"=>"POINT (-149.1577 66.0642)"},
     {"source"=>"ak", "eqid"=>"10768079", "version"=>"1", "occurred_at"=>"2013-07-27T10:39:50.000Z", "magnitude"=>2.6, "depth"=>99.4, "number_of_stations_reported"=>43, "region"=>"Southern Alaska", "location"=>"POINT (-152.3296 60.1814)"},
     {"source"=>"pr", "eqid"=>"13208012", "version"=>"0", "occurred_at"=>"2013-07-27T10:35:09.000Z", "magnitude"=>2.7, "depth"=>15.0, "number_of_stations_reported"=>7, "region"=>"Virgin Islands region", "location"=>"POINT (-65.0767 18.6665)"},
     {"source"=>"us", "eqid"=>"c000iqik", "version"=>"3", "occurred_at"=>"2013-07-27T10:34:43.000Z", "magnitude"=>4.4, "depth"=>220.1, "number_of_stations_reported"=>12, "region"=>"Banda Sea", "location"=>"POINT (129.4476 -5.4035)"},
     {"source"=>"us", "eqid"=>"c000iqib", "version"=>"4", "occurred_at"=>"2013-07-27T10:34:01.000Z", "magnitude"=>4.5, "depth"=>35.0, "number_of_stations_reported"=>0, "region"=>"Libertador General Bernardo O'Higgins, Chile", "location"=>"POINT (-71.93 -34.77)"},
     {"source"=>"nc", "eqid"=>"72034890", "version"=>"0", "occurred_at"=>"2013-07-27T10:32:26.000Z", "magnitude"=>1.1, "depth"=>8.5, "number_of_stations_reported"=>7, "region"=>"San Francisco Bay area, California", "location"=>"POINT (-122.4608 37.6027)"},
     {"source"=>"ak", "eqid"=>"10768074", "version"=>"1", "occurred_at"=>"2013-07-27T10:17:51.000Z", "magnitude"=>1.4, "depth"=>1.8, "number_of_stations_reported"=>10, "region"=>"Southern Alaska", "location"=>"POINT (-147.2928 61.1408)"},
     {"source"=>"nc", "eqid"=>"72034850", "version"=>"1", "occurred_at"=>"2013-07-27T10:01:59.000Z", "magnitude"=>1.7, "depth"=>2.8, "number_of_stations_reported"=>26, "region"=>"Northern California", "location"=>"POINT (-122.8083 38.8328)"},
     {"source"=>"nm", "eqid"=>"072713a", "version"=>"A", "occurred_at"=>"2013-07-27T09:58:19.000Z", "magnitude"=>2.2, "depth"=>16.6, "number_of_stations_reported"=>11, "region"=>"Arkansas", "location"=>"POINT (-91.2925 35.972)"},
     {"source"=>"nc", "eqid"=>"72034845", "version"=>"0", "occurred_at"=>"2013-07-27T09:48:11.000Z", "magnitude"=>1.8, "depth"=>22.2, "number_of_stations_reported"=>5, "region"=>"Northern California", "location"=>"POINT (-124.3152 40.3865)"},
     {"source"=>"us", "eqid"=>"c000iqht", "version"=>"5", "occurred_at"=>"2013-07-27T09:42:53.000Z", "magnitude"=>4.6, "depth"=>35.1, "number_of_stations_reported"=>52, "region"=>"off the east coast of the Kamchatka Peninsula, Russia", "location"=>"POINT (159.7412 52.2515)"},
     {"source"=>"ci", "eqid"=>"11340194", "version"=>"2", "occurred_at"=>"2013-07-27T09:36:36.000Z", "magnitude"=>1.1, "depth"=>17.2, "number_of_stations_reported"=>10, "region"=>"Southern California", "location"=>"POINT (-116.7963 34.0138)"},
     {"source"=>"ak", "eqid"=>"10768058", "version"=>"2", "occurred_at"=>"2013-07-27T09:30:34.000Z", "magnitude"=>1.0, "depth"=>131.5, "number_of_stations_reported"=>17, "region"=>"Central Alaska", "location"=>"POINT (-149.5248 63.9587)"},
     {"source"=>"ak", "eqid"=>"10768055", "version"=>"1", "occurred_at"=>"2013-07-27T09:27:44.000Z", "magnitude"=>1.3, "depth"=>36.5, "number_of_stations_reported"=>11, "region"=>"Southern Alaska", "location"=>"POINT (-149.8397 61.767)"},
     {"source"=>"nn", "eqid"=>"00418793", "version"=>"1", "occurred_at"=>"2013-07-27T09:08:55.000Z", "magnitude"=>1.4, "depth"=>7.0, "number_of_stations_reported"=>23, "region"=>"Nevada", "location"=>"POINT (-118.0635 38.0243)"},
     {"source"=>"us", "eqid"=>"c000iqhn", "version"=>"7", "occurred_at"=>"2013-07-27T09:04:50.000Z", "magnitude"=>4.6, "depth"=>44.3, "number_of_stations_reported"=>26, "region"=>"near the east coast of Honshu, Japan", "location"=>"POINT (142.8767 40.0669)"},
     {"source"=>"pr", "eqid"=>"13208014", "version"=>"0", "occurred_at"=>"2013-07-27T08:49:40.000Z", "magnitude"=>2.0, "depth"=>19.0, "number_of_stations_reported"=>4, "region"=>"Puerto Rico region", "location"=>"POINT (-65.7628 18.1487)"},
     {"source"=>"ak", "eqid"=>"10768043", "version"=>"1", "occurred_at"=>"2013-07-27T08:29:26.000Z", "magnitude"=>1.7, "depth"=>5.1, "number_of_stations_reported"=>17, "region"=>"Central Alaska", "location"=>"POINT (-149.924 62.73)"},
     {"source"=>"pr", "eqid"=>"13208006", "version"=>"0", "occurred_at"=>"2013-07-27T08:13:58.000Z", "magnitude"=>2.9, "depth"=>8.0, "number_of_stations_reported"=>13, "region"=>"Virgin Islands region", "location"=>"POINT (-64.2809 18.1653)"},
     {"source"=>"ci", "eqid"=>"11340178", "version"=>"2", "occurred_at"=>"2013-07-27T08:10:54.000Z", "magnitude"=>1.0, "depth"=>17.1, "number_of_stations_reported"=>14, "region"=>"Southern California", "location"=>"POINT (-116.8452 33.8857)"},
     {"source"=>"pr", "eqid"=>"13208009", "version"=>"0", "occurred_at"=>"2013-07-27T07:52:33.000Z", "magnitude"=>1.1, "depth"=>22.0, "number_of_stations_reported"=>6, "region"=>"Puerto Rico", "location"=>"POINT (-65.7585 18.1639)"},
     {"source"=>"ci", "eqid"=>"11340162", "version"=>"2", "occurred_at"=>"2013-07-27T07:51:10.000Z", "magnitude"=>1.1, "depth"=>12.7, "number_of_stations_reported"=>20, "region"=>"Southern California", "location"=>"POINT (-116.4447 32.988)"},
     {"source"=>"ci", "eqid"=>"11340154", "version"=>"2", "occurred_at"=>"2013-07-27T07:50:31.000Z", "magnitude"=>1.1, "depth"=>11.7, "number_of_stations_reported"=>31, "region"=>"Southern California", "location"=>"POINT (-116.4537 33.5055)"},
     {"source"=>"us", "eqid"=>"c000iqh1", "version"=>"6", "occurred_at"=>"2013-07-27T07:37:23.000Z", "magnitude"=>4.5, "depth"=>9.3, "number_of_stations_reported"=>23, "region"=>"Seram, Indonesia", "location"=>"POINT (129.9002 -3.0594)"},
     {"source"=>"ak", "eqid"=>"10768030", "version"=>"1", "occurred_at"=>"2013-07-27T07:24:16.000Z", "magnitude"=>1.5, "depth"=>87.2, "number_of_stations_reported"=>21, "region"=>"Central Alaska", "location"=>"POINT (-150.8683 62.8868)"},
     {"source"=>"us", "eqid"=>"c000iqgt", "version"=>"4", "occurred_at"=>"2013-07-27T06:46:46.000Z", "magnitude"=>4.6, "depth"=>67.1, "number_of_stations_reported"=>26, "region"=>"Ceram Sea, Indonesia", "location"=>"POINT (128.1495 -2.9763)"},
     {"source"=>"pr", "eqid"=>"13208005", "version"=>"0", "occurred_at"=>"2013-07-27T06:39:16.000Z", "magnitude"=>3.3, "depth"=>55.0, "number_of_stations_reported"=>8, "region"=>"Virgin Islands region", "location"=>"POINT (-64.5658 19.2369)"},
     {"source"=>"ak", "eqid"=>"10768019", "version"=>"1", "occurred_at"=>"2013-07-27T06:37:03.000Z", "magnitude"=>1.7, "depth"=>0.8, "number_of_stations_reported"=>14, "region"=>"Southern Alaska", "location"=>"POINT (-141.4777 60.1129)"},
     {"source"=>"pr", "eqid"=>"13208008", "version"=>"0", "occurred_at"=>"2013-07-27T06:31:55.000Z", "magnitude"=>2.8, "depth"=>13.0, "number_of_stations_reported"=>5, "region"=>"Virgin Islands region", "location"=>"POINT (-64.638 19.2919)"},
     {"source"=>"pr", "eqid"=>"13208004", "version"=>"0", "occurred_at"=>"2013-07-27T06:27:03.000Z", "magnitude"=>3.0, "depth"=>73.0, "number_of_stations_reported"=>6, "region"=>"Virgin Islands region", "location"=>"POINT (-64.4627 19.1245)"},
     {"source"=>"nc", "eqid"=>"72034770", "version"=>"0", "occurred_at"=>"2013-07-27T06:11:00.000Z", "magnitude"=>1.3, "depth"=>3.0, "number_of_stations_reported"=>16, "region"=>"Northern California", "location"=>"POINT (-122.7928 38.8792)"},
     {"source"=>"pr", "eqid"=>"13208002", "version"=>"0", "occurred_at"=>"2013-07-27T06:10:46.000Z", "magnitude"=>3.6, "depth"=>51.0, "number_of_stations_reported"=>18, "region"=>"Virgin Islands region", "location"=>"POINT (-64.5316 19.396)"},
     {"source"=>"pr", "eqid"=>"13208007", "version"=>"0", "occurred_at"=>"2013-07-27T06:03:40.000Z", "magnitude"=>2.4, "depth"=>11.0, "number_of_stations_reported"=>5, "region"=>"Virgin Islands region", "location"=>"POINT (-64.6654 19.3414)"},
     {"source"=>"ci", "eqid"=>"11340138", "version"=>"2", "occurred_at"=>"2013-07-27T05:34:09.000Z", "magnitude"=>1.6, "depth"=>11.2, "number_of_stations_reported"=>47, "region"=>"Southern California", "location"=>"POINT (-116.2622 33.2478)"},
     {"source"=>"pr", "eqid"=>"13208003", "version"=>"0", "occurred_at"=>"2013-07-27T05:30:31.000Z", "magnitude"=>3.1, "depth"=>105.0, "number_of_stations_reported"=>14, "region"=>"Mona Passage, Dominican Republic", "location"=>"POINT (-68.0535 18.1601)"},
     {"source"=>"pr", "eqid"=>"13208010", "version"=>"0", "occurred_at"=>"2013-07-27T05:27:40.000Z", "magnitude"=>2.6, "depth"=>82.0, "number_of_stations_reported"=>4, "region"=>"Virgin Islands region", "location"=>"POINT (-64.3441 18.3829)"},
     {"source"=>"ak", "eqid"=>"10768009", "version"=>"1", "occurred_at"=>"2013-07-27T05:16:21.000Z", "magnitude"=>1.7, "depth"=>1.7, "number_of_stations_reported"=>11, "region"=>"Central Alaska", "location"=>"POINT (-148.7842 62.9152)"},
     {"source"=>"ak", "eqid"=>"10768003", "version"=>"1", "occurred_at"=>"2013-07-27T04:56:54.000Z", "magnitude"=>2.1, "depth"=>115.2, "number_of_stations_reported"=>25, "region"=>"Southern Alaska", "location"=>"POINT (-152.1902 61.0583)"},
     {"source"=>"pr", "eqid"=>"13208001", "version"=>"0", "occurred_at"=>"2013-07-27T04:43:53.000Z", "magnitude"=>3.1, "depth"=>62.0, "number_of_stations_reported"=>6, "region"=>"Virgin Islands region", "location"=>"POINT (-64.4985 19.2705)"},
     {"source"=>"us", "eqid"=>"c000iqf9", "version"=>"5", "occurred_at"=>"2013-07-27T04:38:34.000Z", "magnitude"=>4.1, "depth"=>10.3, "number_of_stations_reported"=>22, "region"=>"Greece", "location"=>"POINT (21.9452 40.1652)"},
     {"source"=>"ak", "eqid"=>"10767994", "version"=>"1", "occurred_at"=>"2013-07-27T04:26:12.000Z", "magnitude"=>1.4, "depth"=>13.7, "number_of_stations_reported"=>13, "region"=>"Southern Yukon Territory, Canada", "location"=>"POINT (-140.9277 60.1707)"},
     {"source"=>"pr", "eqid"=>"13208000", "version"=>"0", "occurred_at"=>"2013-07-27T04:25:28.000Z", "magnitude"=>3.5, "depth"=>32.0, "number_of_stations_reported"=>22, "region"=>"Virgin Islands region", "location"=>"POINT (-64.2725 18.191)"},
     {"source"=>"us", "eqid"=>"c000iqf8", "version"=>"6", "occurred_at"=>"2013-07-27T04:24:39.000Z", "magnitude"=>5.4, "depth"=>46.6, "number_of_stations_reported"=>59, "region"=>"Guam region", "location"=>"POINT (145.458 13.1336)"},
     {"source"=>"ci", "eqid"=>"11340122", "version"=>"2", "occurred_at"=>"2013-07-27T03:57:29.000Z", "magnitude"=>1.2, "depth"=>18.6, "number_of_stations_reported"=>26, "region"=>"Southern California", "location"=>"POINT (-116.7313 33.9525)"},
     {"source"=>"ak", "eqid"=>"10767985", "version"=>"1", "occurred_at"=>"2013-07-27T03:14:36.000Z", "magnitude"=>1.3, "depth"=>41.6, "number_of_stations_reported"=>4, "region"=>"Kodiak Island region, Alaska", "location"=>"POINT (-153.6641 57.8474)"},
     {"source"=>"nn", "eqid"=>"00418786", "version"=>"1", "occurred_at"=>"2013-07-27T03:05:40.000Z", "magnitude"=>1.4, "depth"=>5.0, "number_of_stations_reported"=>11, "region"=>"Nevada", "location"=>"POINT (-115.4711 36.6136)"},
     {"source"=>"ci", "eqid"=>"11340106", "version"=>"2", "occurred_at"=>"2013-07-27T02:57:42.000Z", "magnitude"=>1.4, "depth"=>14.1, "number_of_stations_reported"=>43, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-117.1198 33.9672)"},
     {"source"=>"ak", "eqid"=>"10767973", "version"=>"1", "occurred_at"=>"2013-07-27T02:51:21.000Z", "magnitude"=>2.3, "depth"=>80.2, "number_of_stations_reported"=>29, "region"=>"Southern Alaska", "location"=>"POINT (-150.9653 61.8244)"},
     {"source"=>"ak", "eqid"=>"10767968", "version"=>"1", "occurred_at"=>"2013-07-27T02:42:39.000Z", "magnitude"=>2.3, "depth"=>74.5, "number_of_stations_reported"=>31, "region"=>"Southern Alaska", "location"=>"POINT (-152.7081 59.041)"},
     {"source"=>"ak", "eqid"=>"10767966", "version"=>"1", "occurred_at"=>"2013-07-27T02:26:03.000Z", "magnitude"=>1.2, "depth"=>4.1, "number_of_stations_reported"=>7, "region"=>"Southern Alaska", "location"=>"POINT (-141.1682 61.5612)"},
     {"source"=>"nc", "eqid"=>"72034505", "version"=>"0", "occurred_at"=>"2013-07-27T02:19:14.000Z", "magnitude"=>1.0, "depth"=>0.8, "number_of_stations_reported"=>9, "region"=>"Northern California", "location"=>"POINT (-122.8098 38.8577)"},
     {"source"=>"ak", "eqid"=>"10767950", "version"=>"1", "occurred_at"=>"2013-07-27T02:04:08.000Z", "magnitude"=>2.1, "depth"=>0.0, "number_of_stations_reported"=>27, "region"=>"Southern Alaska", "location"=>"POINT (-141.2394 61.5685)"},
     {"source"=>"ci", "eqid"=>"11340098", "version"=>"2", "occurred_at"=>"2013-07-27T01:47:40.000Z", "magnitude"=>1.2, "depth"=>16.5, "number_of_stations_reported"=>28, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-117.1317 33.9657)"},
     {"source"=>"ci", "eqid"=>"11340090", "version"=>"2", "occurred_at"=>"2013-07-27T01:46:27.000Z", "magnitude"=>1.0, "depth"=>14.0, "number_of_stations_reported"=>23, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-117.1225 33.9555)"},
     {"source"=>"ci", "eqid"=>"11340082", "version"=>"2", "occurred_at"=>"2013-07-27T01:42:55.000Z", "magnitude"=>2.2, "depth"=>16.8, "number_of_stations_reported"=>90, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-117.1325 33.9613)"},
     {"source"=>"ak", "eqid"=>"10767937", "version"=>"1", "occurred_at"=>"2013-07-27T01:28:56.000Z", "magnitude"=>1.7, "depth"=>62.5, "number_of_stations_reported"=>11, "region"=>"Southern Alaska", "location"=>"POINT (-151.1165 61.8219)"},
     {"source"=>"us", "eqid"=>"c000iqdc", "version"=>"4", "occurred_at"=>"2013-07-27T01:27:11.000Z", "magnitude"=>4.2, "depth"=>469.8, "number_of_stations_reported"=>27, "region"=>"Bonin Islands, Japan region", "location"=>"POINT (139.8856 27.6)"},
     {"source"=>"us", "eqid"=>"c000iqd0", "version"=>"4", "occurred_at"=>"2013-07-27T01:14:46.000Z", "magnitude"=>4.6, "depth"=>28.7, "number_of_stations_reported"=>25, "region"=>"Izu Islands, Japan region", "location"=>"POINT (141.7421 32.8765)"},
     {"source"=>"us", "eqid"=>"c000iqcp", "version"=>"8", "occurred_at"=>"2013-07-27T01:09:02.000Z", "magnitude"=>5.6, "depth"=>30.8, "number_of_stations_reported"=>69, "region"=>"Izu Islands, Japan region", "location"=>"POINT (141.65 32.9802)"},
     {"source"=>"us", "eqid"=>"c000iqcq", "version"=>"6", "occurred_at"=>"2013-07-27T01:01:29.000Z", "magnitude"=>4.5, "depth"=>10.0, "number_of_stations_reported"=>14, "region"=>"south of Java, Indonesia", "location"=>"POINT (107.5961 -9.9558)"},
     {"source"=>"ak", "eqid"=>"10767918", "version"=>"1", "occurred_at"=>"2013-07-27T00:52:52.000Z", "magnitude"=>3.3, "depth"=>84.5, "number_of_stations_reported"=>42, "region"=>"Alaska Peninsula", "location"=>"POINT (-157.5837 56.5427)"},
     {"source"=>"ci", "eqid"=>"11340074", "version"=>"2", "occurred_at"=>"2013-07-27T00:26:12.000Z", "magnitude"=>1.5, "depth"=>2.0, "number_of_stations_reported"=>15, "region"=>"Central California", "location"=>"POINT (-117.776 36.0208)"},
     {"source"=>"ci", "eqid"=>"11340066", "version"=>"2", "occurred_at"=>"2013-07-27T00:17:33.000Z", "magnitude"=>1.4, "depth"=>2.7, "number_of_stations_reported"=>13, "region"=>"Central California", "location"=>"POINT (-117.784 36.0192)"},
     {"source"=>"ci", "eqid"=>"11340058", "version"=>"2", "occurred_at"=>"2013-07-27T00:11:00.000Z", "magnitude"=>1.1, "depth"=>16.7, "number_of_stations_reported"=>19, "region"=>"Southern California", "location"=>"POINT (-116.8092 33.9655)"},
     {"source"=>"nc", "eqid"=>"72034385", "version"=>"0", "occurred_at"=>"2013-07-26T23:49:59.000Z", "magnitude"=>1.3, "depth"=>2.3, "number_of_stations_reported"=>18, "region"=>"Northern California", "location"=>"POINT (-122.8077 38.8375)"},
     {"source"=>"ak", "eqid"=>"10767775", "version"=>"1", "occurred_at"=>"2013-07-26T23:25:08.000Z", "magnitude"=>1.3, "depth"=>1.2, "number_of_stations_reported"=>9, "region"=>"Southern Alaska", "location"=>"POINT (-141.1227 61.5668)"},
     {"source"=>"nn", "eqid"=>"00418776", "version"=>"1", "occurred_at"=>"2013-07-26T23:17:37.000Z", "magnitude"=>1.0, "depth"=>9.2, "number_of_stations_reported"=>6, "region"=>"Nevada", "location"=>"POINT (-119.0071 39.0916)"},
     {"source"=>"ak", "eqid"=>"10767766", "version"=>"2", "occurred_at"=>"2013-07-26T22:59:33.000Z", "magnitude"=>1.1, "depth"=>4.4, "number_of_stations_reported"=>9, "region"=>"Central Alaska", "location"=>"POINT (-147.3194 64.9919)"},
     {"source"=>"nn", "eqid"=>"00418782", "version"=>"1", "occurred_at"=>"2013-07-26T22:52:22.000Z", "magnitude"=>1.1, "depth"=>10.5, "number_of_stations_reported"=>5, "region"=>"Nevada", "location"=>"POINT (-118.734 38.4096)"},
     {"source"=>"ak", "eqid"=>"10767752", "version"=>"1", "occurred_at"=>"2013-07-26T22:08:43.000Z", "magnitude"=>1.2, "depth"=>19.6, "number_of_stations_reported"=>7, "region"=>"Southern Alaska", "location"=>"POINT (-147.5376 60.927)"},
     {"source"=>"hv", "eqid"=>"60533561", "version"=>"1", "occurred_at"=>"2013-07-26T22:03:28.000Z", "magnitude"=>1.8, "depth"=>1.3, "number_of_stations_reported"=>29, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.2793 19.401)"},
     {"source"=>"ci", "eqid"=>"11340042", "version"=>"4", "occurred_at"=>"2013-07-26T21:55:58.000Z", "magnitude"=>1.4, "depth"=>9.0, "number_of_stations_reported"=>37, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-117.6978 33.8623)"},
     {"source"=>"uw", "eqid"=>"60558967", "version"=>"2", "occurred_at"=>"2013-07-26T21:49:21.000Z", "magnitude"=>1.8, "depth"=>0.0, "number_of_stations_reported"=>37, "region"=>"Puget Sound region, Washington", "location"=>"POINT (-121.9492 48.0955)"},
     {"source"=>"ak", "eqid"=>"10767723", "version"=>"1", "occurred_at"=>"2013-07-26T21:39:16.000Z", "magnitude"=>1.2, "depth"=>66.8, "number_of_stations_reported"=>6, "region"=>"Central Alaska", "location"=>"POINT (-149.3856 62.9666)"},
     {"source"=>"us", "eqid"=>"c000iq6f", "version"=>"8", "occurred_at"=>"2013-07-26T21:32:59.000Z", "magnitude"=>6.2, "depth"=>10.0, "number_of_stations_reported"=>65, "region"=>"South Sandwich Islands region", "location"=>"POINT (-23.9594 -57.7893)"},
     {"source"=>"nc", "eqid"=>"72034290", "version"=>"0", "occurred_at"=>"2013-07-26T21:24:29.000Z", "magnitude"=>1.2, "depth"=>8.1, "number_of_stations_reported"=>14, "region"=>"Long Valley area, California", "location"=>"POINT (-118.8787 37.6388)"},
     {"source"=>"nc", "eqid"=>"72034285", "version"=>"0", "occurred_at"=>"2013-07-26T21:20:04.000Z", "magnitude"=>2.4, "depth"=>1.3, "number_of_stations_reported"=>14, "region"=>"Central California", "location"=>"POINT (-121.6107 36.8853)"},
     {"source"=>"nc", "eqid"=>"72034280", "version"=>"1", "occurred_at"=>"2013-07-26T21:19:17.000Z", "magnitude"=>1.3, "depth"=>2.6, "number_of_stations_reported"=>26, "region"=>"Northern California", "location"=>"POINT (-122.778 38.8338)"},
     {"source"=>"uw", "eqid"=>"60558947", "version"=>"1", "occurred_at"=>"2013-07-26T21:12:07.000Z", "magnitude"=>2.4, "depth"=>0.0, "number_of_stations_reported"=>8, "region"=>"British Columbia, Canada", "location"=>"POINT (-120.505 49.4418)"},
     {"source"=>"ci", "eqid"=>"11340018", "version"=>"4", "occurred_at"=>"2013-07-26T20:51:15.000Z", "magnitude"=>1.1, "depth"=>7.4, "number_of_stations_reported"=>23, "region"=>"Southern California", "location"=>"POINT (-116.4215 33.0353)"},
     {"source"=>"ak", "eqid"=>"10767684", "version"=>"2", "occurred_at"=>"2013-07-26T20:37:19.000Z", "magnitude"=>4.3, "depth"=>39.8, "number_of_stations_reported"=>84, "region"=>"Kodiak Island region, Alaska", "location"=>"POINT (-151.7451 58.0237)"},
     {"source"=>"nc", "eqid"=>"72034250", "version"=>"0", "occurred_at"=>"2013-07-26T20:17:05.000Z", "magnitude"=>1.8, "depth"=>8.3, "number_of_stations_reported"=>11, "region"=>"Northern California", "location"=>"POINT (-123.1315 39.1323)"},
     {"source"=>"pr", "eqid"=>"13207007", "version"=>"0", "occurred_at"=>"2013-07-26T20:16:36.000Z", "magnitude"=>2.5, "depth"=>62.0, "number_of_stations_reported"=>5, "region"=>"Virgin Islands region", "location"=>"POINT (-64.9128 18.8353)"},
     {"source"=>"us", "eqid"=>"c000iq40", "version"=>"4", "occurred_at"=>"2013-07-26T19:59:31.000Z", "magnitude"=>4.4, "depth"=>53.2, "number_of_stations_reported"=>15, "region"=>"Negros, Philippines", "location"=>"POINT (122.3884 9.4749)"},
     {"source"=>"ak", "eqid"=>"10767672", "version"=>"1", "occurred_at"=>"2013-07-26T19:58:48.000Z", "magnitude"=>1.0, "depth"=>30.1, "number_of_stations_reported"=>5, "region"=>"Central Alaska", "location"=>"POINT (-147.3225 64.2372)"},
     {"source"=>"us", "eqid"=>"c000ipxp", "version"=>"A", "occurred_at"=>"2013-07-26T19:08:29.000Z", "magnitude"=>5.1, "depth"=>547.2, "number_of_stations_reported"=>138, "region"=>"south of the Fiji Islands", "location"=>"POINT (179.1808 -23.0963)"},
     {"source"=>"nc", "eqid"=>"72034215", "version"=>"4", "occurred_at"=>"2013-07-26T19:04:24.000Z", "magnitude"=>1.2, "depth"=>12.8, "number_of_stations_reported"=>26, "region"=>"San Francisco Bay area, California", "location"=>"POINT (-122.159 37.7472)"},
     {"source"=>"hv", "eqid"=>"60533466", "version"=>"1", "occurred_at"=>"2013-07-26T18:37:30.000Z", "magnitude"=>2.1, "depth"=>1.5, "number_of_stations_reported"=>26, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.2865 19.4007)"},
     {"source"=>"ak", "eqid"=>"10767634", "version"=>"1", "occurred_at"=>"2013-07-26T18:17:28.000Z", "magnitude"=>3.1, "depth"=>11.0, "number_of_stations_reported"=>62, "region"=>"Southern Alaska", "location"=>"POINT (-146.3933 61.6225)"},
     {"source"=>"ak", "eqid"=>"10767629", "version"=>"1", "occurred_at"=>"2013-07-26T18:05:48.000Z", "magnitude"=>1.1, "depth"=>14.0, "number_of_stations_reported"=>6, "region"=>"Southern Alaska", "location"=>"POINT (-141.2727 61.5305)"},
     {"source"=>"nc", "eqid"=>"72034185", "version"=>"0", "occurred_at"=>"2013-07-26T17:52:02.000Z", "magnitude"=>1.3, "depth"=>11.1, "number_of_stations_reported"=>22, "region"=>"Central California", "location"=>"POINT (-121.4258 36.8002)"},
     {"source"=>"nc", "eqid"=>"72034170", "version"=>"3", "occurred_at"=>"2013-07-26T17:24:07.000Z", "magnitude"=>2.2, "depth"=>8.8, "number_of_stations_reported"=>43, "region"=>"Central California", "location"=>"POINT (-118.8138 37.4703)"},
     {"source"=>"uu", "eqid"=>"60032012", "version"=>"2", "occurred_at"=>"2013-07-26T17:20:05.000Z", "magnitude"=>1.6, "depth"=>11.2, "number_of_stations_reported"=>9, "region"=>"Utah", "location"=>"POINT (-112.944 38.9255)"},
     {"source"=>"uw", "eqid"=>"60558817", "version"=>"1", "occurred_at"=>"2013-07-26T17:05:52.000Z", "magnitude"=>1.8, "depth"=>13.3, "number_of_stations_reported"=>13, "region"=>"Washington", "location"=>"POINT (-121.659 47.8703)"},
     {"source"=>"nc", "eqid"=>"72034160", "version"=>"2", "occurred_at"=>"2013-07-26T17:04:43.000Z", "magnitude"=>1.4, "depth"=>8.7, "number_of_stations_reported"=>32, "region"=>"Long Valley area, California", "location"=>"POINT (-118.8808 37.636)"},
     {"source"=>"ak", "eqid"=>"10767599", "version"=>"1", "occurred_at"=>"2013-07-26T16:54:44.000Z", "magnitude"=>1.3, "depth"=>46.9, "number_of_stations_reported"=>9, "region"=>"Central Alaska", "location"=>"POINT (-145.9625 64.0593)"},
     {"source"=>"nc", "eqid"=>"72034140", "version"=>"0", "occurred_at"=>"2013-07-26T16:43:43.000Z", "magnitude"=>1.1, "depth"=>2.7, "number_of_stations_reported"=>15, "region"=>"Northern California", "location"=>"POINT (-122.8283 38.8388)"},
     {"source"=>"ci", "eqid"=>"11339954", "version"=>"4", "occurred_at"=>"2013-07-26T16:41:31.000Z", "magnitude"=>1.5, "depth"=>9.7, "number_of_stations_reported"=>10, "region"=>"Greater Los Angeles area, California", "location"=>"POINT (-118.2832 33.7423)"},
     {"source"=>"nc", "eqid"=>"72034135", "version"=>"3", "occurred_at"=>"2013-07-26T16:38:55.000Z", "magnitude"=>1.2, "depth"=>6.9, "number_of_stations_reported"=>22, "region"=>"Central California", "location"=>"POINT (-120.8472 36.3028)"},
     {"source"=>"us", "eqid"=>"c000ipsc", "version"=>"5", "occurred_at"=>"2013-07-26T16:25:08.000Z", "magnitude"=>4.6, "depth"=>31.4, "number_of_stations_reported"=>38, "region"=>"Sichuan-Gansu border region, China", "location"=>"POINT (104.8623 32.9279)"},
     {"source"=>"nc", "eqid"=>"72034130", "version"=>"0", "occurred_at"=>"2013-07-26T16:24:28.000Z", "magnitude"=>1.1, "depth"=>8.6, "number_of_stations_reported"=>9, "region"=>"San Francisco Bay area, California", "location"=>"POINT (-121.727 37.3725)"},
     {"source"=>"nc", "eqid"=>"72034120", "version"=>"1", "occurred_at"=>"2013-07-26T16:15:22.000Z", "magnitude"=>1.5, "depth"=>8.1, "number_of_stations_reported"=>26, "region"=>"San Francisco Bay area, California", "location"=>"POINT (-121.727 37.3673)"},
     {"source"=>"us", "eqid"=>"c000ips2", "version"=>"7", "occurred_at"=>"2013-07-26T16:14:02.000Z", "magnitude"=>4.4, "depth"=>148.0, "number_of_stations_reported"=>32, "region"=>"Hindu Kush region, Afghanistan", "location"=>"POINT (69.9576 36.281)"},
     {"source"=>"uw", "eqid"=>"60558792", "version"=>"1", "occurred_at"=>"2013-07-26T16:04:09.000Z", "magnitude"=>1.5, "depth"=>0.0, "number_of_stations_reported"=>11, "region"=>"Oregon", "location"=>"POINT (-122.7088 44.2712)"},
     {"source"=>"us", "eqid"=>"c000iprk", "version"=>"9", "occurred_at"=>"2013-07-26T15:56:51.000Z", "magnitude"=>4.5, "depth"=>60.9, "number_of_stations_reported"=>33, "region"=>"Andreanof Islands, Aleutian Islands, Alaska", "location"=>"POINT (-176.7481 51.7462)"},
     {"source"=>"hv", "eqid"=>"60533351", "version"=>"2", "occurred_at"=>"2013-07-26T15:50:07.000Z", "magnitude"=>2.1, "depth"=>1.9, "number_of_stations_reported"=>36, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.2765 19.406)"},
     {"source"=>"pr", "eqid"=>"13207006", "version"=>"0", "occurred_at"=>"2013-07-26T15:37:58.000Z", "magnitude"=>2.6, "depth"=>90.0, "number_of_stations_reported"=>7, "region"=>"Mona Passage, Dominican Republic", "location"=>"POINT (-68.416 18.1781)"},
     {"source"=>"ak", "eqid"=>"10767549", "version"=>"1", "occurred_at"=>"2013-07-26T15:36:43.000Z", "magnitude"=>1.9, "depth"=>35.1, "number_of_stations_reported"=>9, "region"=>"Southern Alaska", "location"=>"POINT (-147.2632 60.4727)"},
     {"source"=>"hv", "eqid"=>"60533331", "version"=>"1", "occurred_at"=>"2013-07-26T15:28:50.000Z", "magnitude"=>1.9, "depth"=>1.0, "number_of_stations_reported"=>19, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.263 19.3917)"},
     {"source"=>"hv", "eqid"=>"60533321", "version"=>"1", "occurred_at"=>"2013-07-26T15:27:11.000Z", "magnitude"=>2.1, "depth"=>0.5, "number_of_stations_reported"=>26, "region"=>"Island of Hawaii, Hawaii", "location"=>"POINT (-155.2773 19.4018)"},
     {"source"=>"us", "eqid"=>"c000ipp1", "version"=>"5", "occurred_at"=>"2013-07-26T14:36:20.000Z", "magnitude"=>4.9, "depth"=>59.0, "number_of_stations_reported"=>41, "region"=>"southern Sumatra, Indonesia", "location"=>"POINT (99.1852 -0.4327)"},
     {"source"=>"ak", "eqid"=>"10767532", "version"=>"1", "occurred_at"=>"2013-07-26T14:29:33.000Z", "magnitude"=>1.5, "depth"=>27.4, "number_of_stations_reported"=>6, "region"=>"Kenai Peninsula, Alaska", "location"=>"POINT (-151.428 60.2003)"},
     {"source"=>"ak", "eqid"=>"10767524", "version"=>"1", "occurred_at"=>"2013-07-26T14:13:00.000Z", "magnitude"=>1.1, "depth"=>5.1, "number_of_stations_reported"=>6, "region"=>"Southern Alaska", "location"=>"POINT (-142.9366 60.4608)"},
     {"source"=>"nn", "eqid"=>"00418725", "version"=>"1", "occurred_at"=>"2013-07-26T14:07:38.000Z", "magnitude"=>1.1, "depth"=>3.2, "number_of_stations_reported"=>14, "region"=>"Nevada", "location"=>"POINT (-118.7408 38.4108)"},
     {"source"=>"uw", "eqid"=>"60558752", "version"=>"3", "occurred_at"=>"2013-07-26T14:04:26.000Z", "magnitude"=>1.0, "depth"=>15.4, "number_of_stations_reported"=>9, "region"=>"Washington", "location"=>"POINT (-120.7062 47.8042)"},
     {"source"=>"ak", "eqid"=>"10767519", "version"=>"1", "occurred_at"=>"2013-07-26T14:01:07.000Z", "magnitude"=>1.2, "depth"=>84.7, "number_of_stations_reported"=>5, "region"=>"Central Alaska", "location"=>"POINT (-151.182 62.2006)"},
     {"source"=>"ci", "eqid"=>"11339938", "version"=>"4", "occurred_at"=>"2013-07-26T14:00:47.000Z", "magnitude"=>3.1, "depth"=>8.5, "number_of_stations_reported"=>53, "region"=>"Southern California", "location"=>"POINT (-115.8805 32.9723)"}]
  end
end

