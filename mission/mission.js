/* eslint-env browser */
const modeSelect = document.querySelector(".container");
const body = document.body;

const lightLogo = document.getElementById("logo");
const darkLogo = document.getElementById("dark-logo");

modeSelect.addEventListener("change", () => {
    if (modeSelect.value === "dark") {
        body.classList.add("dark-mode");
        lightLogo.style.display = "none";
        darkLogo.style.display = "block";
    } 
    else if (modeSelect.value === "light") {
        body.classList.remove("dark-mode");
        lightLogo.style.display = "block";
        darkLogo.style.display = "none";
    }
});             