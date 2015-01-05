#include <nan.h>
#include <iostream>
#include <string>

using namespace v8;
using namespace std;

NAN_METHOD(Hex2dec) {
  NanScope();

  v8::String::Utf8Value inStr(args[0]->ToString());
  std::string stdStr = std::string(*inStr);
  const char *cStr = stdStr.c_str();
  int len = stdStr.length();
  if (len < 16) {
    int64_t val = strtoll(cStr, NULL, 16);
    char buff[32] = {0};
    sprintf(buff, "%lld", val);
    NanReturnValue(NanNew(buff));
  } else if (len == 16) {
    if (cStr[0] < '8') {
      int64_t val = strtoll(cStr, NULL, 16);
      char buff[32] = {0};
      sprintf(buff, "%lld", val);
      NanReturnValue(NanNew(buff));
    } else {
      uint64_t val = strtoull(cStr, NULL, 16);
      val = val & 0x7fffffffffffffff;
      if (val == 0) {
        NanReturnValue(NanNew("-9223372036854775808"));
      }
      val -= 1;
      val = ~val;
      val = val & 0x7fffffffffffffff;
      char buff[32] = {0};
      sprintf(buff, "-%lld", val);
      NanReturnValue(NanNew(buff));
    }
  } else {
    NanReturnValue(NanNew("Out of range"));
  }
}

NAN_METHOD(Dec2hex) {
  NanScope();
  v8::String::Utf8Value inStr(args[0]->ToString());
  std::string stdStr = std::string(*inStr);
  const char *cStr = stdStr.c_str();
  int64_t val = strtoll(cStr, NULL, 10);
  char buff[32] = {0};
  sprintf(buff, "%llX", val);
  NanReturnValue(NanNew(buff));
}

void init(Handle<Object> exports) {
  exports->Set(NanNew("hex2dec"), NanNew<FunctionTemplate>(Hex2dec)->GetFunction());
  exports->Set(NanNew("dec2hex"), NanNew<FunctionTemplate>(Dec2hex)->GetFunction());
}

NODE_MODULE(addon, init)
