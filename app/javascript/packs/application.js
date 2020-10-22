// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
import "../stylesheets/application.scss"
import flatpickr from "flatpickr";

document.addEventListener('DOMContentLoaded', function() {
    flatpickr(".start-date", {
      minDate: "today",
      defaultDate: "today",
    });
    flatpickr(".start-time", {
        enableTime: true,
        noCalendar: true,
        dateFormat: "H:i",
        defaultHour: new Date().getHours(),
        defaultMinute: new Date().getMinutes(),
    });
  });

const form = document.getElementById("new_work_group");

const urlField = document.querySelector("#no_model_fields_worksheet_url");

document.querySelectorAll(".img-container img").forEach(item => {
  item.addEventListener('click', event => {
    urlField.value = item.src;
  });
});

const modal = document.querySelector(".modal");
const closeButton = document.querySelector(".close-button");
const trigger = document.querySelector(".trigger");

const toggleModal = () => {
    modal.classList.toggle("hide-modal");
}

document.querySelector(".copy-button").addEventListener('click', async event => {
  if (!navigator.clipboard) {
    // Clipboard API not available
    return
  }
  const text = document.querySelector("#modal-content").innerText
  try {
    await navigator.clipboard.writeText(text)
    event.target.textContent = 'Copied to clipboard!'
  } catch (err) {
    console.error('Failed to copy!', err)
  }
})

trigger.addEventListener("click", toggleModal);
closeButton.addEventListener("click", toggleModal);