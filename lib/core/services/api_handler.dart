import 'dart:async';
import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_assistant/core/utils/constants.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'graphql_configuration.dart';


class ApiHandler{
  GraphQLConfiguration graphql = GraphQLConfiguration();
  queryRequest(String query,{required Map<String,dynamic> body})async{
    GraphQLClient _client = graphql.clientToQuery();
    print('query is invoked');
    print(query);
    print('req body==>$body');
    try{
      QueryResult result = await _client.query(
          QueryOptions(document: gql(
              """ $query"""
          ),
          variables: body),
      ).timeout(timeoutDuratiom);
      if (result.hasException) {
        print("exception ==> ${result.exception}");
        if (result.exception!.linkException !=null) {
          if(result.exception!.linkException!.originalException is SocketException) {
           return ApiResponse(haserror: true, errormsg: "Network error");
          }
        }

        return ApiResponse(
            haserror: true,
            errormsg: result.exception!.graphqlErrors[0].message);
      }else{
        print("response ==>${result.data.toString()}");
        return ApiResponse(haserror: false,data: result.data,errormsg:'');
      }
    }on TimeoutException{
      return ApiResponse(haserror: true, errormsg: "Timeout error");
    }catch(e){
      print(e);
      return ApiResponse(haserror: true,errormsg: e.toString());
    }
  }

  mutationRequest(String query, {required Map<String,dynamic> body, bool scheduleAlert = false})async{
    GraphQLClient _client = scheduleAlert?graphql.alertClientToQuery() : graphql.clientToQuery();
    print('mutation is invoked');
    print(query);
    print("req body ==>$body");
    try{
      QueryResult result = await _client.mutate(
          MutationOptions(document: gql(
              """$query"""
          ),
            variables: body
         )
      ).timeout(timeoutDuratiom);
      if (result.hasException) {
        print("exception ==> ${result.exception}");
        if (result.exception!.linkException !=null) {
          if(result.exception!.linkException!.originalException is SocketException) {
            return ApiResponse(haserror: true, errormsg: "Network error");
          }
        }

        return ApiResponse(
            haserror: true,
            errormsg: result.exception!.graphqlErrors[0].message);
      }else{
        print("response ==>${result.data.toString()}");
        return ApiResponse(haserror: false,data: result.data,errormsg:'');
      }
    }on TimeoutException{
      return ApiResponse(haserror: true, errormsg: "Timeout error");
    } catch(e){
      print(e);
      return ApiResponse(haserror: true,errormsg: e.toString());
    }


  }
}