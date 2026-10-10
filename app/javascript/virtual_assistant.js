document.addEventListener("turbo:load", () => {

  const input = document.getElementById("virtual-assistant-input");
  const button = document.getElementById("virtual-assistant-send");
  const messages = document.getElementById("virtual-assistant-messages");

  if (!input || !button || !messages) return;

  // Evita registrar los eventos más de una vez
  if (button.dataset.initialized === "true") return;

  button.dataset.initialized = "true";

  function addMessage(text, type) {

    const wrapper = document.createElement("div");

    wrapper.className =
      type === "user"
        ? "virtual-assistant-message virtual-assistant-message-user"
        : "virtual-assistant-message virtual-assistant-message-bot";

    const bubble = document.createElement("div");

    bubble.className = "virtual-assistant-bubble";

    bubble.textContent = text;

    wrapper.appendChild(bubble);

    messages.appendChild(wrapper);

    messages.scrollTop = messages.scrollHeight;
  }


  async function sendMessage() {

    const message = input.value.trim();

    if (!message) return;

    // Mostrar inmediatamente el mensaje del usuario
    addMessage(message, "user");

    // Limpiar campo
    input.value = "";

    // Deshabilitar temporalmente el botón
    button.disabled = true;

    try {

      const csrfToken = document.querySelector(
        'meta[name="csrf-token"]'
      )?.content;

      const response = await fetch("/virtual_assistant/message", {

        method: "POST",

        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        },

        body: JSON.stringify({
          message: message
        })

      });


      if (!response.ok) {

        throw new Error(
          `Error HTTP ${response.status}`
        );

      }


      const data = await response.json();

      console.log("Respuesta Virtual Assistant:", data);

      addMessage(data.message, "bot");


      if (data.url) {

        setTimeout(() => {

          window.location.href = data.url;

        }, 800);

      }

    } catch (error) {

      console.error(
        "Error Asistente Virtual:",
        error
      );

      addMessage(
        "Ocurrió un error al procesar la solicitud.",
        "bot"
      );

    } finally {

      button.disabled = false;

    }
  }


  button.addEventListener("click", sendMessage);


  input.addEventListener("keydown", (event) => {

    if (event.key === "Enter") {

      event.preventDefault();

      sendMessage();

    }

  });

});