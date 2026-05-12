// These are only needed since `html` library is not supported on other than "flutter web" platforms
class HTMLScriptElement {
  HTMLScriptElement();
  late Document document;
  late String src;
  void reload() {}
}

final document = Document();

class Document {
  late Head? head;
}

class Head {
  void append(HTMLScriptElement el) {}
}
