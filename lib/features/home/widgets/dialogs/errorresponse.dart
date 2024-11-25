import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/theme.dart';

class ErrorResponse extends StatelessWidget {
  final dynamic response;
  const ErrorResponse(this.response, {super.key});

  @override
  Widget build(BuildContext context) {
    dp('reponse: ${response.runtimeType}');
    return Center(
      child: (response is http.Response)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${response.statusCode}',
                  style: tstebalmerah.copyWith(fontSize: 50),
                ),
                const SizedBox(height: 10),
                Text(
                  response.body,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            )
          : Text("$response"),
    );
  }
}
