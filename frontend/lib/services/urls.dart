// String baseUrl = 'http://192.168.2.122:8000';
String baseUrl = 'http://classmonitoring.pythonanywhere.com';

Uri loginUrl = Uri.parse("$baseUrl/api/accounts/login/");
Uri userUrl = Uri.parse("$baseUrl/api/accounts/user/");
Uri fullUserUrl = Uri.parse("$baseUrl/api/accounts/full-user/");
Uri deptsUrl = Uri.parse("$baseUrl/api/departments/");
Uri coursesUrl = Uri.parse("$baseUrl/api/courses/");
Uri createStudentUrl = Uri.parse("$baseUrl/api/accounts/register-student/");
Uri createLecturerUrl = Uri.parse("$baseUrl/api/accounts/register-lecturer/");
Uri saveStudentQr = Uri.parse("$baseUrl/api/accounts/save-qr/");
Uri markAttendanceUrl = Uri.parse("$baseUrl/api/mark-attendance/");
Uri lecturerDetailUrl = Uri.parse("$baseUrl/api/accounts/lecturer-detail/");
Uri passwordChangeUrl = Uri.parse("$baseUrl/api/accounts/password/change/");

