window.onload = function () {

    const svg_diagram = document.getElementById('svg-diagram');
    const parser = new DOMParser();

    async function fetchSVG() {
        const response = await fetch('/img/workflow-create-intermediate.svg');
        const svgText = await response.text();
        const svgDoc = parser.parseFromString(svgText, 'text/xml');
        svg_diagram.appendChild(svgDoc.documentElement);
    }

    fetchSVG();

    const loading = setInterval(function () {
        if (document.getElementById('kubernetes_attack_surface')) {
            const interactiveContent = document.querySelectorAll("g[data-clickable='true']");
            interactiveContent.forEach(interactiveBox => {
                interactiveBox.addEventListener('click', () => {
                    controller_service.style.fill = "#FFB6A3";
                })
            });
            clearInterval(loading);
        }
    }, 100);
}
