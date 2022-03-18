window.onload = function () {

  async function fetchSSLCAData() {
    const response = await fetch("/get_ssl_ca_data");
    const jsonbody = await response.json();
    return jsonbody;
  }

  async function fetchSSLClientData() {
    const response = await fetch("/get_ssl_domain_data");
    const jsonbody = await response.json();
    return jsonbody;
  }

  function formatSerialNumber(serialString) {
    var newString = ""
    for (var i = 0; i < serialString.length; i++) {
      if (i % 2 == 0 && i > 0) {
        newString += '-';
      }
      newString += serialString[i];
    }
    return newString;
  }

  const root_public_key_1 = document.getElementById("root-ca-serial-key-1");
  const root_public_key_2 = document.getElementById("root-ca-serial-key-2");
  const intermediate_public_key_1 = document.getElementById("intermediate-serial-key-1");
  const intermediate_public_key_2 = document.getElementById("intermediate-serial-key-2");
  const leaf_public_key = document.getElementById("leaf-serial-key");

  fetchSSLCAData().then(jsonbody => {
    root_public_key_1.innerHTML = formatSerialNumber(String(jsonbody[1]["serialNumber"]));
    root_public_key_2.innerHTML = formatSerialNumber(String(jsonbody[1]["serialNumber"]));
    intermediate_public_key_1.innerHTML = formatSerialNumber(String(jsonbody[0]["serialNumber"]));
    intermediate_public_key_2.innerHTML = formatSerialNumber(String(jsonbody[0]["serialNumber"]));
  }).catch(err => {
    console.log("Error Reading data " + err);
  });

  fetchSSLClientData().then(jsonbody => {
    leaf_public_key.innerHTML = formatSerialNumber(String(jsonbody["serialNumber"]));
  }).catch(err => {
    console.log("Error Reading data " + err);
  });

}