window.onload = function () {
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
            document.getElementById('tooltiptext').innerHTML = 'Go to page 1';

        } else if (box_is_active === "true") {
            window.location.href = "index.html"
        }

    })

}