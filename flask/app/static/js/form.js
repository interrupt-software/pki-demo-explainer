window.onload = function () {
    const form_request = document.getElementById("form-container");
    const form_results = document.getElementById("form-results");
    const form_submit = document.getElementById("ca-root-form");

    form_submit.addEventListener("submit", () => {
        form_request.style.display = 'none';
        form_results.style.display = 'block';
    });


}