syntax = "proto3";

package {{.package}};
option go_package="./{{.package}}";

service {{.serviceName}} {
  rpc Ping(Request) returns(Response);
}

message Request {
  string ping = 1;
}

message Response {
  string pong = 1;
}
