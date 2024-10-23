local fs = require "nixio.fs"

f = SimpleForm("qrcode", translate("感谢您的使用！"), "")
f.reset = false
f.submit = false

local htmlCode = [[
<!DOCTYPE html>
<html>
<head>
<title>感谢您的使用</title>
<meta charset="utf-8">
<style>
.container {
  display: flex;
  justify-content: space-between;
  padding: 20px;
}
.qrcode-container {
  text-align: center;
  margin-right: 200px;
}
.qrcode {
  width: 200px;
  height: 200px;
}
.label {
  font-size: 14px;
  margin-top: 10px;
}
</style>
<script type="text/javascript" src="/luci-static/resources/qrcode.min.js"></script>
</head>
<body onload="generateDefaultQRCode();">
<div class="container">
  <div class="qrcode-container">
    <div id="qrcode1" class="qrcode"></div>
    <div class="label">赞赏/支持</div>
  </div>
  <div class="qrcode-container">
    <div id="qrcode2" class="qrcode"></div>
    <div class="label">加入我们</div>
  </div>
  <div class="qrcode-container">
    <div id="qrcode3" class="qrcode"></div>
    <div class="label">项目地址</div>
  </div>
</div>

<script type="text/javascript">
function generateDefaultQRCode() {
  var Url1 = "wxp://f2f1EDK5VXacGZS6mW9CCRsXHJH3krs5wdR2GrKt3FL444pTrM55MZz_LBHTZFcDUgVC";
  var Url2 = "https://qm.qq.com/cgi-bin/qm/qr?k=KnlCNloS9hNAQfSNwyABSjhWpDVbwcQo&authKey=877Ut7w6Znfur8juelZmKELjtTrpHkk+8/Er/J6gIqF1r4lTi1fjGMMkYub8zryR&noverify=0&personal_qrcode_source=1001";
  var Url3 = "https://github.com/lucikap/luci-app-brukamen.git";

  var qrcodeElement1 = document.getElementById("qrcode1");
  var qrcode1 = new QRCode(qrcodeElement1, {
    width: 200,
    height: 200,
    colorDark: "#FF0000",
    colorLight: "#ffffff"
  });
  qrcode1.makeCode(Url1);

  var qrcodeElement2 = document.getElementById("qrcode2");
  var qrcode2 = new QRCode(qrcodeElement2, {
    width: 200,
    height: 200,
    colorDark: "#ffff00",
    colorLight: "#000000"
  });
  qrcode2.makeCode(Url2);

  var qrcodeElement3 = document.getElementById("qrcode3");
  var qrcode3 = new QRCode(qrcodeElement3, {
    width: 200,
    height: 200,
    colorDark: "#0000FF",
    colorLight: "#ffffff"
  });
  qrcode3.makeCode(Url3);
}
</script>
</body>
</html>
]]

local htmView = f:field(DummyValue, "htm_view", "")
htmView.rawhtml = true
htmView.value = htmlCode

return f
