window.onload = function () {

  async function fetchSSLServerData() {
    const response = await fetch("/get_ssl_server_data");
    const log_data = await response.text();
    return log_data
  }

  async function sendSSLMessage() {
    const response = await fetch("/send_ssl_message");
    const jsonbody = await response.json();
    return jsonbody;
  }

  const server_data = document.getElementById("server-data");
  const fake_button = document.getElementById("fake-buttom");

  fake_button.addEventListener('click', () => {

    sendSSLMessage();

    fetchSSLServerData().then(log_data => {
      log_data = log_data.replace(/(\d{1,4}-\d{1,2}-\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2},\d{1,3})/g, "<br/>$1");
      server_data.innerHTML = log_data;
    }).catch(err => {
      console.log("Error Reading data " + err);
    });
  })

}