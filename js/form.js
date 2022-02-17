window.onload = function () {
    const form_request = document.getElementById("form-container");
    const form_results = document.getElementById("form-results");
    const form_submit = document.getElementById("ca-root-form");
    const tale_teller = document.getElementById("tale-teller");

    var root_token;
    fetch("/js/vault-unseal.json")
        .then(response => response.json())
        .then(json => root_token = json["root_token"]);

    form_submit.addEventListener("submit", () => {
        form_request.style.display = 'none';
        form_results.style.display = 'block';
        tale_teller.innerHTML = `
            <p>Your lab environment includes a HashiCorp Vault deployment. Follow the instructions to explore the deployment.
            </p>
            <p>Here is your Vault root token: <strong>${root_token}</strong>
            </p>
            `;
        tale_teller.style.display = 'block';

    });


}