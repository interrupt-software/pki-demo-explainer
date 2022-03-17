window.onload = function () {

  async function startSSLServer() {
    const response = await fetch("/start_ssl_server");
    return
  }

  const server_data = document.getElementById("server-data");
  const fake_button = document.getElementById("fake-buttom");

  fake_button.addEventListener('click', () => {

    startSSLServer();

  })

}