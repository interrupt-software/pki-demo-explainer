window.onload = function () {

    const tale_teller = document.getElementById("tale-teller");
    const copy_root_token = document.getElementById("copy-root-token");
    const copy_icon = document.getElementById("copy-icon");

    async function fetchRootToken() {
        const response = await fetch("/root_token");
        const jsonbody = await response.json();
        return jsonbody;
    }

    var root_token;

    fetchRootToken().then(jsonbody => {
        copy_root_token.innerHTML = jsonbody["root_token"];
        root_token = jsonbody["root_token"];
    });

    tale_teller.addEventListener('click', () => {
        window.getSelection().selectAllChildren(copy_root_token);
        navigator.clipboard.writeText(root_token);
        copy_icon.innerHTML = `<img src="img/check-mark.svg" alt="Copied!">`;
    })
}