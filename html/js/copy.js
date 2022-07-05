function copyToClipboard(textToCopy) {
    var inputHelper = document.createElement("input");
    inputHelper.setAttribute("value", textToCopy);
    document.body.appendChild(inputHelper);
    inputHelper.select();
    document.execCommand("copy");
    document.body.removeChild(inputHelper);
}

var copyElementContents = function () {
    elem = this
    copyToClipboard(elem.innerText.trim());
    elem.setAttribute("data-copied", "")
    setTimeout(function () {
        elem.removeAttribute("data-copied")
    }, 1500)
};

copyElements = document.querySelectorAll('[data-copyable]')
for (var i = 0; i < copyElements.length; i++) {
    copyElements[i].addEventListener('click', copyElementContents, false);
}