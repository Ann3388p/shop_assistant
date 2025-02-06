import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static Link? link ;
  static HttpLink httpLink = HttpLink(
   // "https://demoserver.nearshopz.com/shopassistant/v1"
 "https://testserver.nearshopz.com/shopassistant/v1"
      //'http://128.199.16.136:4000/shopassistant/v1'
   // 'https://server.nearshopz.com/shopassistant/v1'
  );
  static HttpLink alertLink = HttpLink(
   // 'https://server.nearshopz.com/scheduleapp/v1'
     'https://testserver.nearshopz.com/scheduleapp/v1'
    //     'https://demoserver.nearshopz.com/scheduleapp/v1'
  );
  static void setToken(String token) {
    print('set token is called');
    // print('token is $token');8353
    AuthLink alink = AuthLink(getToken: () async => 'Bearer ' + token);
    GraphQLConfiguration.link = alink.concat(GraphQLConfiguration.httpLink);
  }
  static void removeToken() {
    GraphQLConfiguration.link = null;
  }

  static Link? getLink() {
    print('get link is called');
    print("check graphql confif is not null ${GraphQLConfiguration.link != null}");
    print(GraphQLConfiguration.link);
    return GraphQLConfiguration.link != null
        ? GraphQLConfiguration.link
        : GraphQLConfiguration.httpLink;
  }

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: getLink()!,
      cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(
        watchQuery: Policies(fetch: FetchPolicy.networkOnly),
        query: Policies(fetch: FetchPolicy.networkOnly),
        mutate:Policies(fetch: FetchPolicy.networkOnly),
      ),
    )
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      link: getLink()!,
       cache: GraphQLCache(),
      defaultPolicies: DefaultPolicies(
        watchQuery: Policies(fetch: FetchPolicy.networkOnly),
        query: Policies(fetch: FetchPolicy.networkOnly),
        mutate:Policies(fetch: FetchPolicy.networkOnly),
      ),
      //   partialDataPolicy: PartialDataCachePolicy.reject
      // ),
    );
  }

  GraphQLClient alertClientToQuery(){
    return GraphQLClient(
      cache:GraphQLCache(),
      defaultPolicies: DefaultPolicies(
        watchQuery: Policies(fetch: FetchPolicy.networkOnly),
        query: Policies(fetch: FetchPolicy.networkOnly),
        mutate:Policies(fetch: FetchPolicy.networkOnly),
      ),
      link: alertLink,
    );
  }
}

