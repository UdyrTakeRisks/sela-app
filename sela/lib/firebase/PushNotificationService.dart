import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:googleapis/fcm/v1.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sela/main.dart';

class PushNotificationService {
  // static Future<String> getToken() async {
  //   final serviceAcountJson = {
  //
  //       "type": "service_account",
  //       "project_id": "sela-app-ce1dc",
  //       "private_key_id": "3e9997e151a3a5f516ed22e8892a1f430d16f16a",
  //       "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCQz/te/VOB3fRd\nr5XSpUwrRdZruDPajMF+ybwRsnl2KTd4GGRne3yahCY2eUEF2xsf1SfHmfvRbEKw\nAHUt/xkRB0K0zRSV4RYMQB5hcsf+nsyo/dLXTdQPVxo3kfc9v+LljFK2IONYjDtL\nAuQSy71z7kh3hMYwNDdQ8t3srxUdM3Eu9hItWwr/k++A2HA35PhvdjOA176a+FDq\ngrv4BTHEQVlcPhrh+Hs25M1Bae5HD0KeMch/fk5lKMarZOLAoCWatkBeu8SkaheS\ngnYkJdYHaVuKePwq8DjiyE8/BJZExEkQ7nNzxCd8nrDy9JoBR980+als+cNogfyi\nNrO5GXQNAgMBAAECgf8EPhOfNMy9gUMne31oLm+M1P7zKPJb9MO2czKPUis8yvhV\nDGHkpjmATV7RObwt771bsWL49gnqmMFbZqgIMPELDqtloJx5x55dvYMmV7aEPyK/\n0K/cnusXh/W8qwoTRQvgrbu+mjgO4AzcpbkI0+849kIpPjqQLvdv562YwYhc0pmz\nJsJXwYM+Krs9LWgSFHqUhE3Q7tR98r/BWu/OU3QvkSyuTqEqnBMU+m9hchNH4k8d\npdEdJMRCZLo7jzXqHE0S7mmrR2V4ihIlqGI8ulMtSmXz8IzaKBG2pf6S9qDr+ahJ\nngc+gqesvJLdRJ4DydWDTRfy7MjODPUb+P1BzHECgYEAyYk9W0I8jY4Uc+hEaJaV\nLo/Flpx5FqDij/s11kjkBzcyABej4jbQCDvrP+2ad6Ia4H6yKCI4QjKLNwSNk5NH\nI93K/RjZMgQ+bt4xkLYJHPCGaSQgFiFIlZuXenhvWurRFXDy/0rmdTxuSbMtk3H1\nnb6IkXFPX5cvMCcmfSkTq4kCgYEAt/J12T/wOTgrB1ds7hk9CKyjgHXiMxK4MXRG\nV6YpXVklLqugsQlkfYG0tEbQ93MkhEMbhl6fdejiRxSD6arrP7T8yGF58IA7TQHY\nYHte3nlX2QV67SS7Y3L2iOon6fABkQ4Szjic3yHBhe/YuKObrqUHD3KASugFk9LI\nlR/Lz2UCgYBv/NvkVwUQ36+LzLgeqfZRvkBcdaxvn4zl1wDOhwh23fvhw0Ek1bJ5\nsNoDVwOrkJ+AucZDuOgsGKv1MYl+RKuWSYufYmxmd6c9sig2soCT3S/DQvi1c19D\nCwd8XWn7SlpOoMnWhIdVA/SA7ZjYws1qD1MSBrXFd1wYVNj1WZr9iQKBgQCrxXd1\nQvbBiAjuVx56jQjoo8YevHZZeR6V192kFZ9E82z8UvrAt2Omq8uiGQskN9qew8fd\nR1kjEzDSbX7tYlVB7XGscRIcmrJFq/ZxymMB31BAcZSkBIwURxOfMQHKu/vKh9jZ\nyBX9a5k6yImZifZkNOkN7L+Os3IZ41i5oLKC3QKBgGVG5aeV2R3PK0XGvkrRsl3K\nSqyi9Vfcrrdp03isSFSydQp6INe9vSOGRN55E26eTBTBDuPyq5Zm7W/EO9UXOwH+\nLyDsPWqzPRIvo/duF8ncKhG5cWM5clMzADE6nhnTo48T024eJhP5C8XuMebgiZMN\nbNH1WJdXeSSNfi6ESTCf\n-----END PRIVATE KEY-----\n",
  //       "client_email": "sela-app@sela-app-ce1dc.iam.gserviceaccount.com",
  //       "client_id": "103323811947561853287",
  //       "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //       "token_uri": "https://oauth2.googleapis.com/token",
  //       "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  //       "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/sela-app%40sela-app-ce1dc.iam.gserviceaccount.com",
  //       "universe_domain": "googleapis.com"
  //
  //   };
  //   List<String> scopes = [
  //     "https://www.googleapis.com/auth/firebase.database",
  //     "https://www.googleapis.com/auth/userinfo.email",
  //     "https://www.googleapis.com/auth/firebase.messaging",
  //     "https://www.googleapis.com/auth/cloud-platform"
  //   ];
  //   http.Client client = await auth.clientViaServiceAccount(
  //     auth.ServiceAccountCredentials.fromJson(serviceAcountJson),
  //     scopes
  //   );
  //   auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
  //     auth.ServiceAccountCredentials.fromJson(serviceAcountJson),
  //     scopes,
  //     client
  //   );
  //   client.close();
  //   return credentials.accessToken.data;
  // }
  // static sendNotification(String deviceToken, BuildContext context, String title) async {
  //   final String serverAccessTokenKey = await getToken();
  //   String endpointFirebase= "https://fcm.googleapis.com/v1/projects/sela-app-ce1dc/messages:send";
  //
  //   final Map<String,dynamic>message = {
  //     "message": {
  //       "token": deviceToken,
  //       "notification": {
  //         "title": "Test",
  //         "body": "This is a Firebase Cloud Messaging Topic Message!",
  //       },
  //       'data': {
  //         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //         'id': '1',
  //         'status': 'done'
  //       }
  //     }
  //   };
  //   final http.Response response = await http.post(
  //     Uri.parse(endpointFirebase),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $serverAccessTokenKey',
  //     },
  //     body: jsonEncode(message),
  //   );
  //   if(response.statusCode == 200) {
  //     print("Notification sent successfully");
  //   }
  //   else {
  //     print("Failed to send notification: ${response.statusCode}");
  //   }
  // }

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
Future<void> initNotificatons() async{
  await _firebaseMessaging.requestPermission();
  String? token = await _firebaseMessaging.getToken();
  print("Token: $token");

}
void handleMessages(RemoteMessage? message){
  if(message==null)return;
  navigatorKey.currentState!.pushNamed('/notification', arguments: message);
}

Future handleBackgroundMessage() async{
 FirebaseMessaging.instance.getInitialMessage().then((handleMessages));
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
}
}