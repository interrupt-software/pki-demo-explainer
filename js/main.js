window.onload = function () {

    var root_token;
    fetch("/js/vault-unseal.json")
        .then(response => response.json())
        .then(json => root_token = json["root_token"]);

    const pretty_box = document.querySelector(".box");

    pretty_box.addEventListener('click', () => {

        const box_is_active = pretty_box.getAttribute("data-active");

        if (box_is_active === "false") {
            const explainers = document.querySelectorAll(".explainer");

            explainers.forEach(explainer => {
                explainer.style.opacity = "0";
                explainer.style.display = "block";
            })

            pretty_box.setAttribute("data-active", true);
            document.getElementById('tooltiptext').innerHTML = 'What is a root token?';

        } else if (box_is_active === "true") {
            document.getElementById("tale-teller").innerHTML = `
            <p>${root_token}</p>
            `;
        }

    })

}