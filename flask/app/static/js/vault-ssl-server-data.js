window.onload = function () {

  const server_data = document.getElementById("server-data");
  const fake_button = document.getElementById("fake-buttom");

  async function fetchSSLServerData() {
    var log_data = null;
    try {
      var response = await fetch("/get_ssl_server_data");
      if (response.ok) {
        try {
          log_data = await response.text();
        } catch (e) {
          server_data.innerHTML += e + `<br>`;
        }
      }
      else {
        throw new Error(Date() + " " + response.statusText + ": Unable to load SSL server data.");
      }
    } catch (e) {
      server_data.innerHTML += e + `<br>`;
    }
    return log_data
  }

  async function sendSSLMessage() {
    var jsonbody = NaN;
    try {
      var response = await fetch("/send_ssl_message");
      if (response.ok) {
        try {
          jsonbody = await response.json();
        } catch (e) {
          server_data.innerHTML += e + `<br>`;
        }
      } else {
        throw new Error(Date() + " " + response.statusText + ": Failed to send SSL encryted message.");
      }
    } catch (e) {
      server_data.innerHTML += e + `<br>`;
    }
    return jsonbody;
  }

  fake_button.addEventListener('click', () => {

    server_data.innerHTML = "";

    try {
      sendSSLMessage().then(jsonbody => {

        if (jsonbody) {

          fetchSSLServerData().then(logdata => {
            var serverdata = null;

            try {
              if (logdata) {
                serverdata = logdata.replace(/(\d{1,4}-\d{1,2}-\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2},\d{1,3})/g, "<br/>$1");
                server_data.innerHTML += serverdata;
              }
              else {
                throw new Error(Date() + ": Unable to request SSL server data.");
              }
            }
            catch (e) {
              server_data.innerHTML += e + `<br>`;
            }
            if (serverdata) {
              server_data.innerHTML = serverdata;
            }
          })
        }

      });

    } catch (e) {
      server_data.innerHTML = e + `<br>`;
    }

  })
}
