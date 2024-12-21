import 'dart:convert';

class DummyJson {
  static const String _loginRequest = '''
{
"mobile": "8969893457",
"password": "chandan"
}
''';

  static const String _loginRequestSuccess = '''
{
"status": "success",
"message": "Login successful",
"data": {
"user_id": "12345",
"name": "John Doe",
"mobile": "9876543210",
"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
}
''';

  static const String _loginRequestFailed = '''
{
"status": "error",
"message": "Invalid mobile number or password"
}
''';

  static final Map<String, dynamic> loginRequest = jsonDecode(_loginRequest);
  static final Map<String, dynamic> loginRequestSuccess =
      jsonDecode(_loginRequestSuccess);
  static final Map<String, dynamic> loginRequestFailed =
      jsonDecode(_loginRequestFailed);

}
