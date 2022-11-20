import 'dart:html';

void reload() {
  window.location.reload();
}

void openLink(String href) {
  var aEle = AnchorElement(href: href);
  aEle.target = '_self';
  window.document.querySelector('body')!.append(aEle);
  aEle.click();
}
