BEGIN {
  BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
  result = ""

  while (length(ARGV[1]) > 0) {
	group1 = substr(ARGV[1], 1, 1)
	group2 = substr(ARGV[1], 2, 1)
	group3 = substr(ARGV[1], 3, 1)
	group4 = substr(ARGV[1], 4, 1)
	
	value1 = index(BASE64, group1) - 1
	if (value1 < 0) value1 = 0
	value2 = index(BASE64, group2) - 1
	if (value2 < 0) value2 = 0
	value3 = index(BASE64, group3) - 1
	if (value3 < 0) value3 = 0
	value4 = index(BASE64, group4) - 1
	if (value4 < 0) value4 = 0
	
	result1 = value1 * 4 + value2 / 16
	result2 = (value2 % 16) * 16 + (value3 / 4)
	result3 = (value3 % 4) * 64 + value4
	
	result = result sprintf("%02x", result1) sprintf("%02x", result2) sprintf("%02x", result3)
	
	ARGV[1] = substr(ARGV[1], 5)
  }
  
  print substr(result, 1, 32)
  
  exit
}
