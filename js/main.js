// Install PWA
const pwaCloseButton = document.querySelector("#pwa-close-prompt");
const pwaPrompt = document.querySelector("#pwa-install-banner");
const pwaInstallButton = document.querySelector("#pwa-install-button");

window.addEventListener("load", () => {
    pwaCloseButton.addEventListener("click", (e) => {
        rejectInstallPrompt();
    });
});

//#region PWA
window.addEventListener("beforeinstallprompt", (event) => {
    event.preventDefault();

    // PWA Install Prompt
    if (getCookie("pwaInstallBlocked") != "true") {
        pwaPrompt.classList.remove("hidden");
        pwaPrompt.classList.add("visible");
    }

    window.promptEvent = event;
});

pwaInstallButton.addEventListener("click", () => {
    addToHomeScreen();
});

function rejectInstallPrompt() {
    setCookie("pwaInstallBlocked", "true", 1);
    removePrompt();
}

function removePrompt() {
    pwaPrompt.classList.add("animateOut");

    pwaPrompt.addEventListener("animationend", () => {
        pwaPrompt.remove();
    });
}

function addToHomeScreen() {
    window.promptEvent.prompt();

    window.promptEvent.userChoice.then((choiceResult) => {
        if (choiceResult.outcome === "accepted") {
            // User accepted the A2HS prompt
        }

        window.promptEvent = null;
    });

    removePrompt();
}
//#endregion

function showToast(message, type = "info", duration = 5) {
    duration = duration * 1000;
    let toastIconName = "";

    switch (type) {
        case "info":
            toastIconName = "circle-info_light";
            break;
        case "success":
            toastIconName = "circle-check";
            break;
        case "warning":
            toastIconName = "warning";
            break;
        case "error":
            toastIconName = "bug";
            break;
    }

    const toastContainer = document.createElement("article");
    toastContainer.id = "toast";
    toastContainer.classList.add(type);
    toastContainer.style.setProperty("--duration", `${duration}ms`);

    const toastIcon = document.createElement("section");
    toastIcon.id = "img";
    toastContainer.appendChild(toastIcon);

    const toastImg = document.createElement("img");
    toastImg.src = `/assets/img/${toastIconName}.svg`;
    toastIcon.appendChild(toastImg);

    const toastDesc = document.createElement("section");
    toastDesc.id = "desc";
    toastDesc.textContent = message;
    toastContainer.appendChild(toastDesc);

    bodyEl.appendChild(toastContainer);

    let i = 0;

    toastContainer.addEventListener("animationstart", () => {
        toastContainer.style.setProperty("--backgroundSize", '0');
    });

    toastContainer.addEventListener("animationend", () => {
        i++;

        if (i == 2) {
            toastContainer.remove();
        }
    });
}