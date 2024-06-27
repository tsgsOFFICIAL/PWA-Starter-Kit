const notificationLanguage = document.currentScript.getAttribute('data-language');
let swRegistration;

getSwRegistration();

async function getSwRegistration() {
    swRegistration = await navigator.serviceWorker.getRegistration();
    if (Notification.permission === 'granted') {
        // Permission granted
    } else if (Notification.permission === 'denied') {
        // Permission denied
    } else {
        // Permission not granted, nor denied yet
    }
}

async function sendNotification(notifyTitle, notifyBody) {
    if (Notification.permission === 'granted') {
        showNotification(notifyTitle, notifyBody);
    } else {
        if (Notification.permission !== 'denied') {
            const permission = await Notification.requestPermission();

            if (permission === 'granted') {
                showNotification(notifyTitle, notifyBody);
            }
        }
    }
}

function showNotification(notifyTitle, notifyBody) {
    const notifyImg = `./assets/pwa/icons/128x128.png`;

    const payload = {
        body: notifyBody,
        icon: notifyImg,
    };

    if ('showNotification' in swRegistration) {
        swRegistration.showNotification(notifyTitle, payload);
    } else {
        new Notification(notifyTitle, payload);
    }
}