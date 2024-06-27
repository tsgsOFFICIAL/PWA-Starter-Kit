// Select all .blur-load elements
const blurLoad = document.querySelectorAll('.blur-load');

// Loop through each element
blurLoad.forEach(container => {
    const img = container.querySelector('img');

    if (img.complete) {
        loaded();
    } else {
        img.addEventListener('load', loaded);
    }

    function loaded() {
        container.classList.add('loaded');
        img.removeEventListener('load', loaded);

        // remove the inline style on the container
        container.removeAttribute('style');
    }
});