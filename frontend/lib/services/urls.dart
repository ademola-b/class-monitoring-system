// String baseUrl = 'http://192.168.159.182:8000';
String baseUrl = 'http://192.168.88.182:8000';

Uri loginUrl = Uri.parse("$baseUrl/api/accounts/login/");
Uri userUrl = Uri.parse("$baseUrl/api/accounts/user/");
Uri deptsUrl = Uri.parse("$baseUrl/api/departments/");
Uri coursesUrl = Uri.parse("$baseUrl/api/courses/");
Uri createStudentUrl = Uri.parse("$baseUrl/api/accounts/register-student/");
Uri createLecturerUrl = Uri.parse("$baseUrl/api/accounts/register-lecturer/");
Uri saveStudentQr = Uri.parse("$baseUrl/api/accounts/save-qr/");
Uri markAttendanceUrl = Uri.parse("$baseUrl/api/mark-attendance/");
Uri lecturerDetailUrl = Uri.parse("$baseUrl/api/accounts/lecturer-detail/");
