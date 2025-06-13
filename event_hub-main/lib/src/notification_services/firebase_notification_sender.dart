import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class FirebaseNotificationSender {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "telekom-f3eb5",
      "private_key_id": "de7a504cc2a96637cef9d70e7bc98bc766929ebe",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDgn7fQKyMggxDG\nr2IAiEM/ismy+whSSWQi3B0wA5YMoe1TWdWj3cLgVL8IKHZYCuD2n2JhF15/mvwI\nsyM6HMNI/fVmbKTsPMyXROuaJVfjNzO/9uMs/849KQ5rYEm89MPT7aAZNipEakPY\n1PPxsA5/hlNwfVYai8Bk8S7o07D3Imo2Fq+NHnTmtzJXshZRkqQzAtEu3MoOjDCu\nYNP5nieKScQum5Jt2b5pdrG3ahtZdUayRhfn77r2j3yX0aW7KqoLmc+70QQi35IC\nveisjj1C5Jkk6AYsKYvJsUQz6+PsUm1vvAEweQyw4wdAsUZ0yD/SvHiQc1eSSeCN\nFCy/OlWHAgMBAAECggEAbTK4NWcDKKcO3MgeKIwVxSo/a9dF8FrlZ10Cg3j61SFT\nMpYVmhgQyOXqCJlDDwIa40oQlYq60eYSaFhN485f0XhEeIqQkpfsDg3fS4yj8T3A\n1q27OwEQzgLLk7+3mTiUis6Wais+2Quf+CVugixIoA45OhJ0bWtLGMd3OpDPExSq\ngaOvxdNLgFYVDOD/KYBMJaWtyoEzZmb/fIEkOjFH0Gds89GtzgvzU5XCmhdwhLdB\niPvKmvna5R1qKY00x2XgdBVG4IVRZRbQ+5nX6FGEB2GOq6tsVoeFlj05aAZlUYPs\n6IqjMwUHNn9jzdozoe+2DNGBnSYx+oocnguGrfk8YQKBgQD8P7hl5mKUu+JrGgKH\nMkzxiw+hpf7UWATfH1drE2xZa6TuJSf2FFU15HjpoanfkEx7T4lzxC2nL1gEtnZi\njAhZkqhErr65LBcTt5sgZcfaQbmz5x3m4/YYGAPxfAu5HIDFLFU8cHIKbu/zAm6Z\nmvU1mdf8anXKWD4SGY+eDmoOMwKBgQDj9tUyVlNX/ZCAH0OppnXEWZOSZc9J1AOw\nBiUTsySkvb781jLFI2kz5aEif2mwpdawcy6lsTzGbIumfhRG+MuJL1PeomUrB24p\nW8tMra2B0fjutoZm4Cm2XyZFZuo/o76DnoYTWkztybDJYLL2a2039D5lFQ3KKNFp\n6gTjmBkfXQKBgQDA+J5AljbkQbe853D3rGtgfVm/+BUyrQNNDdT6fSluXwMVjCc+\nAeAOEnLNiHdEKEfaLcahYXrrYzSaplt6mFXq8F757BTL5Abjdpqd9j8loRJHpo8h\ni1NAq16Y5qSxQDTioj+ytPMJOEUoSrwBlqHwF3k8CNWDrm4NurA74hsQMQKBgQCW\npW58RlnrYvCUCpUfTpayu/NuooMaqdYKA/WKkC8eAxpsYWzJpD4Igq46avLAPsei\ncWuZKYgdJGwhCV6DDDUNIk6NaMnsZouhHz05Hej0Snrz3YDyCR7nmvdik8EnbyEe\nP6sgrOL7nPaMDbAWciWJ/YkiKYikWNcS5Ah5EvE/LQKBgQCN5bDD5YAGhKkHC/bv\neg0ZRlzawZndUDTinWvkudbqVd7ZZ1vx55yRvkcFJma9UG0pf/oyk7hak+3+ZHOt\nfbXLAY7p6AX8y5yoKRGLELRG4hmZNM9bZg7cKkiCh20oGzx68+0UVhadFTsHNogH\n9/6/kQ/0e55AoSKQwSeRQbCLDg==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-wfsaf@telekom-f3eb5.iam.gserviceaccount.com",
      "client_id": "109081747895675778876",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-wfsaf%40telekom-f3eb5.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );
    client.close();
    return credentials.accessToken.data;
  }

  // Function to send notification using HTTP v1 API
  static Future<void> sendNotification(
    Map<String, dynamic> messagePayload,
  ) async {
    String url =
        'https://fcm.googleapis.com/v1/projects/telekom-f3eb5/messages:send';
    Uri uri = Uri.parse(url);

    String accessToken = await getAccessToken();

    var response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
      body: jsonEncode(messagePayload),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  static Future<void> sendToToken({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    var messagePayload = {
      'message': {
        'token': token,
        'notification': {'title': title, 'body': body},
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'id': '1',
          ...?data, // Merge additional data if provided
        },
      },
    };

    await sendNotification(messagePayload);
  }

  static Future<void> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    var messagePayload = {
      'message': {
        'topic': topic,
        'notification': {'title': title, 'body': body},
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'status': 'done',
          'id': '1',
          ...?data,
        },
      },
    };

    await sendNotification(messagePayload);
  }
}


// await FirebaseNotificationSender.sendToToken(
//   token: 'your-target-fcm-token',
//   title: 'Hello User',
//   body: 'You have a new message!',
// );


// await FirebaseNotificationSender.sendToTopic(
//   topic: 'updates',
//   title: 'New Update',
//   body: 'We’ve added new features to the app!',
// );
