import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/AppKeys.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class HomeApi {
  Future<dynamic> doCheckKyc() async {
    print(getToken());
    var header = {
      "Content-Type": "application/json",
      "Authorization": '$authHeader',
    };
    final body = {
      "user_token": await getToken(),
      "mobile": await getMobile(),
      "email": await getEmail(),
      "merchant_id": await getMATMMerchantId(),
    };
    var client = http.Client();
    try {
      final response = await client.post(Uri.parse(checkKycUrl),
          body: jsonEncode(body), headers: header);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body) as Map;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Future<dynamic> submitBankdata({
    String name = "",
    String bankname = "",
    String type = "",
    String branchname = "",
    String accountno = "",
    String accounttype = "",
    String ifsc = "",
  }) async {
    var token = await getToken();
    var header = {
      "Content-Type": "application/json",
      "Authorization": '$authHeader',
    };
    final body = {
      "user_token": "$token",
      "bank_name": '$bankname',
      "type": '$type',
      "branch": '$branchname',
      "acc": '$accountno',
      "ifsc": '$ifsc',
      "acc_type": "$accounttype",
      "holder": '$name',
    };
    print(body);
    var client = http.Client();
    try {
      final response = await client.post(Uri.parse(addAccountUrl),
          body: jsonEncode(body), headers: header);
      if (response.statusCode == 200) {
        // print(response.body);
        return jsonDecode(response.body) as Map;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Future<dynamic> fetchBankList() async {
    var token = await getToken();
    var header = {
      "Content-Type": "application/json",
      "Authorization": '$authHeader',
    };
    final body = {
      "user_token": "$token",
    };
    print(body);
    var client = http.Client();
    try {
      final response = await client.post(Uri.parse(getBankList),
          body: jsonEncode(body), headers: header);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body) as Map;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }
}

final homeapi = HomeApi();
