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

  tale_teller_1 = document.getElementById("tale-teller-1");
  tale_teller_2 = document.getElementById("tale-teller-2");
  tale_teller_3 = document.getElementById("tale-teller-3");

  if (tale_teller_1 || tale_teller_2) {

    fetchSSLCAData().then(jsonbody => {
      if (tale_teller_1) {

        var payload = `
              <table>
                <th>Root CA</th>
                <th>Data</th>
              `
        for (const key in jsonbody[1]) {

          const result = `${jsonbody[1][key]}`.replace(/,/g, ": ");

          payload += `
                <tr>
                  <td> ${key} </td>
                  <td> ${result} </td>
                </tr>`;
        }

        payload += `
              </table>
            `
        tale_teller_1.innerHTML = payload;
      }

      if (tale_teller_2) {


        payload = `
              <table>
                <th>Intermediate CA</th>
                <th>Data</th>
            `

        for (const key in jsonbody[0]) {

          const result = `${jsonbody[0][key]}`.replace(/,/g, ": ");

          payload += `
                <tr>
                  <td> ${key} </td>
                  <td> ${result} </td>
                </tr>`;
        }

        payload += `
              </table>
            `
        tale_teller_2.innerHTML = payload;
      }

    }).catch(err => {
      console.log("Error Reading data " + err);
    });
  }

  if (tale_teller_3) {
    fetchSSLClientData().then(jsonbody => {
      var payload = `
                <table>
                  <th>Leaf Domain</th>
                  <th>Data</th>
                `
      for (const key in jsonbody) {

        const result = `${jsonbody[key]}`.replace(/,/g, ": ");

        payload += `
                  <tr>
                    <td> ${key} </td>
                    <td> ${result} </td>
                  </tr>`;
      }

      payload += `
                </table>
              `
      tale_teller_3.innerHTML = payload;

    }).catch(err => {
      console.log("Error Reading data " + err);
    });

  }

}